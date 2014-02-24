class window.HelpScreen extends Screen
	constructor: ->
		@menuButton = new Button
			x: GAME_OVERLAY_X + GAME_OVERLAY_BUTTON_MARGIN
			y: GAME_OVERLAY_Y + GAME_OVERLAY_HEIGHT - GAME_OVERLAY_BUTTON_MARGIN - GAME_OVERLAY_BUTTON_HEIGHT
			width: GAME_OVERLAY_BUTTON_WIDTH
			height: GAME_OVERLAY_BUTTON_HEIGHT
			text: "Menu"
			hoveredText: "> Menu <"



	update: (deltaTime) ->
		@menuButton.update deltaTime
		if @menuButton.clicked
			changeScreen new MainMenuScreen()
			return



	render: (context) ->
		context.drawImage backgroundCanvas, 0, 0

		@menuButton.render context