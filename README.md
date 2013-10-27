test-server-for-livetrack
=========================

Test server for livetrack

Server was written to test livetracking application which provides possibilty to watch friends during skiing

Server accept JSON sting from app with following format:
{"udid": 1,"lat": 54.232322,"lon": 32.23432,"alt": 3203, "time": 1382518350}

If user asks about current friends position with next query (1,2 means user id):
?1,2
server returns JSON-string as shown upper.
