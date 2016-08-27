require 'eventmachine'
require './job_processor'

class Worker
  def start
    EM.run do
      puts "main: #{Thread.current}"
      job_processor = JobProcessor.new

      job_processor.callback do |return_code|
        puts "callback: #{Thread.current}"
        puts "#{return_code}"
      end

      job_processor.errback do |return_code|
        puts "callback: #{Thread.current}"
        puts "#{return_code}"
      end

      puts '--- calling defer'
      return_code = job_processor.process(rand(3))
      puts '--- set process state'
      job_processor.succeed(return_code) if return_code == 0
      job_processor.fail(return_code)    if return_code != 0

      puts '--- defer stop'
      EM.stop
    end
  end
end


if __FILE__ == $0
  Worker.new.start
end
