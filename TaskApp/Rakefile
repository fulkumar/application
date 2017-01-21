namespace :server do
	require 'em-websocket'

	desc 'launch chat server'
	task :up do
		connections = []
		EM.run do
			EM::WebSocket.run(:host => '0.0.0.0', :port => 8080) do |ws|
				ws.onopen do |handshake|
					puts 'Connection opened'
					connections << ws
					connections.each { |c| c.send 'new connection is opened.' }
				end

				ws.onclose do
				  puts 'Connection closed'
					# TODO: remove current connection
				end

				ws.onmessage do |msg|
					puts "Recieve message: #{msg}"
					# Broadcast message
					connections.each { |c| c.send msg }
				end
			end
		end
	end
end
