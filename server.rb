# Test server for livetracking on Ruby

require 'socket' 
require 'rubygems'
require 'json'
require 'mysql'
  
server = TCPServer.open("localhost", 8001) # открываем сервак на 8001 порту локалхоста
mysqlserv = Mysql::new("localhost", "root", "root", "snowdb") # локальное подключение на вагранте


loop do
	Thread.fork(server.accept) do |client|

		line = client.gets

		# если на вход приходит запрос на координаты юзеров,
		# то выдаем в ответ JSON с координатами
		
		if line[0..0] == "?"
			array_of_users = line[1...-1].split(",")

			array_of_users.each do |user|
				# берем из базы последнюю точку для запрашиваемого юзера или юзеров, и возвращаем json
				query = "SELECT * FROM `trackpoints` WHERE `uid` = '#{user}' ORDER BY `timestamp` DESC"
				user_data = mysqlserv.query(query).fetch_hash
				# =================================================
				client.print user_data.to_json # перегнали хеш в json и отправили клиенту
				client.print "\n"
				
			end
			
		# ======================================
		else
		# если нет то парсим строку как JSON (надо добавить проверку на валидный JSON)
		#  и обрабатываем данные

			result = JSON.parse(line)
			udid = result["udid"]
			lat = result["lat"]
			lon = result["lon"]
			alt = result["alt"]
			time = result["time"]

			# сохраняем в базу координаты
			query = "INSERT INTO `trackpoints` VALUES ('#{udid}', '#{lat}', '#{lon}', '#{alt}', '#{time}')"

			mysqlserv.query(query)

			logfile = File.open("/tmp/snowlog", 'a')
			logfile.puts(Time.now.to_i.to_s + " - #{line}")
			logfile.close			
			# =================================

			
		end
		client.close
		# =======================================

	end
end
