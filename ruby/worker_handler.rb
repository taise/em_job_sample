require 'eventmachine'
require './worker'

class WorkerHandler
  def start
    EM.run do
      puts "main: #{Thread.current}"
      worker = Worker.new

      worker.callback do |time, return_code|
        puts "callback: #{Thread.current}"
        puts "#{return_code} # #{time}"
      end

      worker.errback do |time, return_code|
        puts "callback: #{Thread.current}"
        puts "#{return_code} # #{time}"
      end

      puts '--- calling defer'
      time, return_code = worker.process
      puts '--- set process state'
      worker.succeed(time, return_code) if return_code == 0
      worker.fail(time, return_code)    if return_code != 0

      puts '--- defer stop'
      EM.stop
    end
  end
end


worker_handler = WorkerHandler.new
3.times do
  worker_handler.start
end
