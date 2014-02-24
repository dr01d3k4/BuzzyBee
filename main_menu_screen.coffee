class window.MainMenuScreen extends Screen
	constructor: ->
		createBackgroundCanvas(Math.random() < DAYTIME_CHANCE)

		@game = new GameScreen no


		MAIN_BUTTON_MARGIN = MAIN_PLAY_BOX_HEIGHT / 10
		MAIN_BUTTON_X = MAIN_PLAY_BOX_X + (MAIN_PLAY_BOX_WIDTH * 0.05)
		MAIN_BUTTON_START_Y = MAIN_PLAY_BOX_Y + MAIN_BUTTON_MARGIN
		MAIN_BUTTON_WIDTH = MAIN_PLAY_BOX_WIDTH * 0.9
		MAIN_BUTTON_HEIGHT = MAIN_PLAY_BOX_HEIGHT / 5

		@playButton = new Button
			x: MAIN_BUTTON_X
			y: MAIN_BUTTON_START_Y
			width: MAIN_BUTTON_WIDTH
			height: MAIN_BUTTON_HEIGHT
			text: "Play!"
			hoveredText: "> Play! <"


		@helpButton = new Button
			x: MAIN_BUTTON_X
			y: MAIN_BUTTON_START_Y + (MAIN_BUTTON_HEIGHT + MAIN_BUTTON_MARGIN)
			width: MAIN_BUTTON_WIDTH
			height: MAIN_BUTTON_HEIGHT
			text: "Help!"
			hoveredText: "> Help! <"


		@highscoresButton = new Button
			x: MAIN_BUTTON_X
			y: MAIN_BUTTON_START_Y + (2 * (MAIN_BUTTON_HEIGHT + MAIN_BUTTON_MARGIN))
			width: MAIN_BUTTON_WIDTH
			height: MAIN_BUTTON_HEIGHT
			text: "Highscores"
			hoveredText: "> Highscores <"




	update: (deltaTime) ->
		@game.update deltaTime

		@playButton.update deltaTime
		@helpButton.update deltaTime
		@highscoresButton.update deltaTime

		if isKeyPressed(Key.JUMP) or @playButton.clicked
			changeScreen new GameScreen()
			return

		if @helpButton.clicked
			changeScreen new HelpScreen()
			return

		if @highscoresButton.clicked
			changeScreen new HighscoresScreen()
			return



	render: (context) ->
		@game.render context

		context.font = GAME_OVERLAY_TITLE_FONT
		context.textAlign = "center"
		context.textBaseline = "middle"

		titleText = "Buzzy Bee!"
		width = context.measureText(titleText).width + MAIN_TITLE_EXTRA_WIDTH
		height = 45

		context.translate MAIN_TITLE_X, MAIN_TITLE_Y
		context.rotate MAIN_TITLE_ANGLE
		context.fillStyle = Colour.TEXT_BACKGROUND
		context.fillRect -width / 2, -MAIN_TITLE_HEIGHT / 2, width, MAIN_TITLE_HEIGHT
		context.beginPath()
		context.strokeStyle = Colour.TEXT
		context.lineWidth = OUTLINE_THICKNESS
		context.rect -width / 2, -MAIN_TITLE_HEIGHT / 2, width, MAIN_TITLE_HEIGHT
		context.stroke()
		context.fillStyle = Colour.TEXT
		context.fillText "Buzzy Bee!", 0, 0
		context.rotate -MAIN_TITLE_ANGLE
		context.translate -MAIN_TITLE_X, -MAIN_TITLE_Y


		context.fillStyle = Colour.TEXT_BACKGROUND
		context.fillRect MAIN_PLAY_BOX_X, MAIN_PLAY_BOX_Y, MAIN_PLAY_BOX_WIDTH, MAIN_PLAY_BOX_HEIGHT

		context.beginPath()
		context.strokeStyle = Colour.TEXT
		context.lineWidth = OUTLINE_THICKNESS
		context.rect MAIN_PLAY_BOX_X, MAIN_PLAY_BOX_Y, MAIN_PLAY_BOX_WIDTH, MAIN_PLAY_BOX_HEIGHT
		context.stroke()


		@playButton.render context
		@helpButton.render context
		@highscoresButton.render context