class window.HighscoresScreen extends Screen
	constructor: ->
		@scores = loadGame()[SAVE_HIGHSCORE_TITLE]
		sortScoreArray @scores
		@scores.splice SAVE_HIGHSCORE_COUNT

		@menuButton = new Button
			x: GAME_OVERLAY_X + GAME_OVERLAY_BUTTON_MARGIN
			y: GAME_OVERLAY_Y + GAME_OVERLAY_HEIGHT - GAME_OVERLAY_BUTTON_MARGIN - GAME_OVERLAY_BUTTON_HEIGHT
			width: GAME_OVERLAY_BUTTON_WIDTH
			height: GAME_OVERLAY_BUTTON_HEIGHT
			text: "Menu"
			hoveredText: "> Menu <"

		@clearScores = new Button
			x: GAME_OVERLAY_X + GAME_OVERLAY_BUTTON_MARGIN + (GAME_OVERLAY_WIDTH * 0.5)
			y: GAME_OVERLAY_Y + GAME_OVERLAY_HEIGHT - GAME_OVERLAY_BUTTON_MARGIN - GAME_OVERLAY_BUTTON_HEIGHT
			width: GAME_OVERLAY_BUTTON_WIDTH
			height: GAME_OVERLAY_BUTTON_HEIGHT
			text: "Clear scores"
			hoveredText: "> Clear scores <"



	update: (deltaTime) ->
		@menuButton.update deltaTime
		@clearScores.update deltaTime

		if @menuButton.clicked
			changeScreen new MainMenuScreen()
			return

		if @clearScores.clicked
			clearSave()
			changeScreen new HighscoresScreen()
			return



	render: (context) ->
		context.drawImage backgroundCanvas, 0, 0

		context.fillStyle = Colour.TEXT_BACKGROUND
		context.fillRect GAME_OVERLAY_X, GAME_OVERLAY_Y, GAME_OVERLAY_WIDTH, GAME_OVERLAY_HEIGHT

		context.beginPath()
		context.strokeStyle = Colour.TEXT
		context.lineWidth = OUTLINE_THICKNESS
		context.rect GAME_OVERLAY_X, GAME_OVERLAY_Y, GAME_OVERLAY_WIDTH, GAME_OVERLAY_HEIGHT
		context.stroke()

		context.fillStyle = Colour.TEXT
		context.font = GAME_OVERLAY_TITLE_FONT
		context.textAlign = "center"
		context.textBaseline = "middle"

		context.fillText "Highscores", GAME_OVERLAY_TITLE_TEXT_X, GAME_OVERLAY_TITLE_TEXT_Y

		context.textAlign = "left"
		context.font = BODY_FONT
		y = GAME_OVERLAY_BODY_TEXT_Y * 0.7
		for i in [0...SAVE_HIGHSCORE_COUNT]
			context.fillText "#{i + 1}: #{if i < @scores.length then @scores[i][0].toString() + ' - ' + @scores[i][1] else '0'}", GAME_OVERLAY_BODY_TEXT_X * 0.6, y

			y += 32

		@menuButton.render context
		@clearScores.render context