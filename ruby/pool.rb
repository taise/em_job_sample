require 'eventmachine'
require './job_processor'

EM.run do
  pool = EM::Pool.new
  spawn = lambda { pool.add(JobProcessor.new) }
  3.times { spawn[] }
  done, scheduled = 0, 0

  p pool
  p pool.contents

  check = lambda do
    done += 1
    if done >= scheduled
      EM.stop
    end
  end

  pool.on_error { |conn| spawn[] }

  3.times do |n|
    pool.perform do |job_processor|

      job_processor.process(n)

      job_processor.callback do |return_code|
        puts "callback: #{Thread.current}"
        check[]
      end

      job_processor.errback { check[] }

      puts '--- calling defer'
      return_code = job_processor.process(rand(3))
      puts '--- set process state'
      job_processor.succeed(return_code) if return_code == 0
      job_processor.fail(return_code)    if return_code != 0

      job_processor
    end
  end
end
