# my first ruby server

require 'socket' 
require 'rubygems'
require 'json'

server = TCPServer.open("localhost", 8001) # открываем сервак на 8001 порту локалхоста

loop do
	client = server.accept
	line = client.gets
	
	# если на вход приходит запрос на координаты юзеров,
	# то выдаем в ответ JSON с координатами
	if line[0..0] == "?"
		array_of_users = line[1...-1].split(",")

		client.print "Return track for users:\n" 
		array_of_users.each do |user|
			# вместо этого надо вставить код который берет из базы
			user_data = {'udid' => user, 'lat' => rand(55-10) + rand(), 'lon' => rand(55-10) + rand(), 'alt' => rand(8700-100)}
			# =================================================
			client.print user_data.to_json # перегнали хеш в json и отправили клиенту
			client.print "\n"
		end
		client.close
	# ======================================
	else
	# если нет то парсим строку как JSON (надо добавить проверку на валидный JSON)
	# и обрабатываем данные

		result = JSON.parse(line)
		
		udid = result["udid"]
		lat = result["lat"]
		lon = result["lon"]
		alt = result["alt"]

		# ответ о том что координаты дошли
		# вместо кода ниже нужно добавить сохранение данных в бд
		answer = "Saved point for user " + udid.to_s + "\n" +
			"with latitude = " + lat.to_s + " and longitude = " + lon.to_s + ".\n" +
			"Altitude is " + alt.to_s + " meters.\n"
		client.print answer
		# =================================

		client.close
	end
	# =======================================

end