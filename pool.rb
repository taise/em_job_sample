require 'eventmachine'
require './job_processor'
require './job_status'


def perform_process(pool, job_status)
    pool.perform do |job_processor|

      job_processor.callback do |time, job_status|
        puts "oid: #{job_processor.object_id}, time: #{time} callback: #{Thread.current}"
        job_status.success
        job_status.print
      end

      job_processor.errback do |time, job_status|
        puts "oid: #{job_processor.object_id}, time: #{time} callback: #{Thread.current}"
        job_status.fail
        job_status.print
      end

      puts '--- calling defer'
      time = rand(5)
      return_code = job_processor.process(time)

      puts '--- set process state'
      job_processor.succeed(time, job_status) if return_code == 0
      job_processor.fail(time, job_status)    if return_code != 0

      job_processor
    end
end

EM.run do
  pool = EM::Pool.new
  spawn = lambda { pool.add(JobProcessor.new) }
  3.times { spawn[] }
  job_status = JobStatus.new

  pool.on_error { |job_processor| spawn[] }
  loop do
    perform_process(pool, job_status)
  end
end
