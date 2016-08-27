require 'eventmachine'
require './job_processor'

EM.run do
  pool = EM::Pool.new
  spawn = lambda { pool.add(JobProcessor.new) }
  3.times { spawn[] }
  done, scheduled = 0, 0

  check = lambda do
    done += 1
    puts "done: #{done}, scheduled: #{scheduled}"
    if done >= scheduled
      EM.stop
    end
  end

  pool.on_error { |conn| spawn[] }

  loop do
    pool.perform do |job_processor|

      job_processor.callback do |time|
        puts "oid: #{job_processor.object_id}, time: #{time} callback: #{Thread.current}"
        check[]
      end

      job_processor.errback { check[] }

      puts '--- calling defer'
      time = rand(10)
      return_code = job_processor.process(time)
      puts '--- set process state'
      job_processor.succeed(time) if return_code == 0
      job_processor.fail(time)    if return_code != 0

      job_processor
    end
  end
end
