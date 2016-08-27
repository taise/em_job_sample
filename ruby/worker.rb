require 'eventmachine'

class Worker
  include EM::Deferrable

  SUCCESS = 0
  ERROR = 1

  def process
    time = rand(3)
    if time == 2
      return time, ERROR
    end
    sleep time
    return time, SUCCESS
  end
end
