gameOverPlayerName = ""
maxGameOverPlayerNameLength = 8
gameOverNameEnterFunction = (keyCode) ->
	if keyCode is 8
		gameOverPlayerName = gameOverPlayerName.substring 0, gameOverPlayerName.length - 1

	if gameOverPlayerName.length < maxGameOverPlayerNameLength and (48 <= keyCode <= 57 or 65 <= keyCode <= 90 or 97 <= keyCode <= 122)
		gameOverPlayerName += String.fromCharCode(keyCode).toLowerCase()




class window.GameOverScreen extends Screen
	constructor: (@score, @backgroundScroll) ->
		@spacePressed = 0
		@spaceMaxPressed = 3

		data = loadGame()
		scores = data[SAVE_HIGHSCORE_TITLE]
		sortScoreArray scores
		@isHighscore = (scores.length is 0 or (scores.length > 0 and @score >= scores[0][0])) and @score isnt 0
		@inHighscoreList = @isHighscore or scores.length < SAVE_HIGHSCORE_COUNT or (scores.length > 0 and @score >= scores[scores.length - 1][0] and @score isnt 0)

		@menuButton = new Button
			x: GAME_OVERLAY_X + GAME_OVERLAY_BUTTON_MARGIN
			y: GAME_OVERLAY_Y + GAME_OVERLAY_HEIGHT - GAME_OVERLAY_BUTTON_MARGIN - GAME_OVERLAY_BUTTON_HEIGHT
			width: GAME_OVERLAY_BUTTON_WIDTH
			height: GAME_OVERLAY_BUTTON_HEIGHT
			text: "Menu"
			hoveredText: "> Menu <"

		@playAgain = new Button
			x: GAME_OVERLAY_X + GAME_OVERLAY_BUTTON_MARGIN + (GAME_OVERLAY_WIDTH * 0.5)
			y: GAME_OVERLAY_Y + GAME_OVERLAY_HEIGHT - GAME_OVERLAY_BUTTON_MARGIN - GAME_OVERLAY_BUTTON_HEIGHT
			width: GAME_OVERLAY_BUTTON_WIDTH
			height: GAME_OVERLAY_BUTTON_HEIGHT
			text: "Play again"
			hoveredText: "> Play again <"

		gameOverPlayerName = data[SAVE_LAST_NAME_TITLE]
		setRespondToKeyDownFunction gameOverNameEnterFunction

		@time = 0




	saveScore: ->
		addScore @score, gameOverPlayerName



	tryClose: ->
		if @inHighscoreList and gameOverPlayerName.length > 0
			@saveScore()
			yes
		else if not @highscore and not @inHighscoreList
			yes
		else
			no



	
	update: (deltaTime) ->
		@time += deltaTime
		@menuButton.update deltaTime
		@playAgain.update deltaTime

		if @menuButton.clicked
			changeScreen new MainMenuScreen() if @tryClose()
			return



		if @playAgain.clicked
			changeScreen new GameScreen() if @tryClose()
			return
		



	render: (context) ->
		context.drawImage backgroundCanvas, @backgroundScroll, 0
		context.drawImage backgroundCanvas, @backgroundScroll + BACKGROUND_WIDTH, 0

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

		context.fillText "Game Over!", GAME_OVERLAY_TITLE_TEXT_X, GAME_OVERLAY_TITLE_TEXT_Y

		context.font = BODY_FONT
		context.fillText "Score: #{@score}", GAME_OVERLAY_BODY_TEXT_X, GAME_OVERLAY_BODY_TEXT_Y

		if @isHighscore
			context.fillText "New highscore!", GAME_OVERLAY_BODY_TEXT_X, GAME_OVERLAY_BODY_TEXT_Y + 64

		if @inHighscoreList
			context.textAlign = "left"
			text = "Your name: #{gameOverPlayerName}"
			context.fillText text, GAME_OVERLAY_BODY_TEXT_X * 0.6, GAME_OVERLAY_BODY_TEXT_Y + 128

			if (Math.floor(@time * 10) / 10) - Math.floor(@time) < 0.6
				textWidth = context.measureText(text).width
				context.fillRect GAME_OVERLAY_BODY_TEXT_X * 0.6 + textWidth, GAME_OVERLAY_BODY_TEXT_Y + 114, 2, 24

		@menuButton.render context
		@playAgain.render context



	close: ->
		gameOverPlayerName = ""
		setRespondToKeyDownFunction null