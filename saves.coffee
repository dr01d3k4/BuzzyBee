window.sortScoreArray = (scores) -> scores.sort (a, b) -> b[0] - a[0]



window.getSaveExpire = ->
	now = new Date()
	now.setFullYear now.getFullYear() + 5
	now.toUTCString()



window.clearSave = ->
	# console.log "Clearing save"
	document.cookie = ""
	document.cookie = GAME_NAME + "=; expires=" + getSaveExpire()



window.saveGame = (data) ->
	saveString = ""
	saveString += data.GAME_NAME + "="
	saveString += data.GAME_NAME + SAVE_SEPERATOR + data.GAME_VERSION + SAVE_SEPERATOR

	if data[SAVE_HIGHSCORE_TITLE]?
		sortScoreArray data[SAVE_HIGHSCORE_TITLE]
		data[SAVE_HIGHSCORE_TITLE].splice SAVE_HIGHSCORE_COUNT

		saveString += SAVE_HIGHSCORE_TITLE + SAVE_SEPERATOR + data[SAVE_HIGHSCORE_TITLE].length + SAVE_SEPERATOR
		for [score, name] in data[SAVE_HIGHSCORE_TITLE]
			saveString += score + SAVE_SEPERATOR + name + SAVE_SEPERATOR

	if data[SAVE_LAST_NAME_TITLE]?
		saveString += SAVE_LAST_NAME_TITLE + SAVE_SEPERATOR + data[SAVE_LAST_NAME_TITLE] + SAVE_SEPERATOR

	if saveString.endsWith SAVE_SEPERATOR
		saveString = saveString.substr 0, saveString.length - 1

	saveString += "; expires=" + getSaveExpire()
	console.log "Saving", saveString
	document.cookie = saveString



window.loadGame = ->
	console.log "Loading", document.cookie
	data = document.cookie.split("=")[1].split(";")[0];
	console.log("Data", data);
	
	unless document.cookie.startsWith GAME_NAME
		console.log "Save data doesn't start with GAME_NAME"
		decodedData =
			GAME_NAME: ""
			GAME_VERSION: ""
		decodedData[SAVE_HIGHSCORE_TITLE] = [ ]
		decodedData[SAVE_LAST_NAME_TITLE] = ""
		return decodedData


	data = data.split SAVE_SEPERATOR

	decodedData = 
		GAME_NAME: data[0]
		GAME_VERSION: data[1]

	decodedData[SAVE_HIGHSCORE_TITLE] = [ ]
	decodedData[SAVE_LAST_NAME_TITLE] = ""

	i = 2
	while i < data.length
		if data[i] is SAVE_HIGHSCORE_TITLE
			highscores = [ ]
			i += 1

			countScores = parseInt data[i]
			for j in [0...countScores]
				i += 1
				score = parseInt data[i]
				i += 1
				name = data[i]
				highscores.push [score, name]

			sortScoreArray highscores

			decodedData[SAVE_HIGHSCORE_TITLE] = highscores

		else if data[i] is SAVE_LAST_NAME_TITLE
			i += 1
			decodedData[SAVE_LAST_NAME_TITLE] = data[i]

		i += 1

	return decodedData



window.addScore = (score = 0, name = "") ->
	console.log "Saving \"#{score}\" by \"#{name}\""

	data = loadGame()

	data["GAME_NAME"] = GAME_NAME
	data["GAME_VERSION"] = GAME_VERSION

	data[SAVE_HIGHSCORE_TITLE].push [score, name]
	data[SAVE_LAST_NAME_TITLE] = name

	saveGame(data)