require 'eventmachine'
require './job_processor'

class Worker
  def start
    EM.run do
      puts "main: #{Thread.current}"
      job_processor = JobProcessor.new

      job_processor.callback do |time, return_code|
        puts "callback: #{Thread.current}"
        puts "#{return_code} # #{time}"
      end

      job_processor.errback do |time, return_code|
        puts "callback: #{Thread.current}"
        puts "#{return_code} # #{time}"
      end

      puts '--- calling defer'
      time, return_code = job_processor.process
      puts '--- set process state'
      job_processor.succeed(time, return_code) if return_code == 0
      job_processor.fail(time, return_code)    if return_code != 0

      puts '--- defer stop'
      EM.stop
    end
  end
end


if __FILE__ == $0
  Worker.new.start
end
