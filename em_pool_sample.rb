require 'eventmachine'
require 'em-http-request'

EM.run do
  pool  = EM::Pool.new
  spawn = lambda { pool.add EM::HttpRequest.new('http://example.org') }
  p EM::HttpRequest.new('http://example.org')
  10.times { spawn[] }
  done, scheduled = 0, 0

  check = lambda do
    done += 1
    if done >= scheduled
      EM.stop
    end
  end

  pool.on_error { |conn| spawn[] }

  100.times do |i|
    pool.perform do |conn|
      req = conn.get :path => '/', :keepalive => true

      req.callback do
        p [:success, conn.object_id, i, req.response.size]
        check[]
      end

      req.errback { check[] }

      req
    end
  end
end
