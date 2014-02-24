window.playerCanvas = null



window.createPlayerCanvas = ->
	window.playerCanvas = createCanvas PLAYER_WIDTH, PLAYER_HEIGHT
	context = playerCanvas.getContext "2d"

	context.fillStyle = Colour.PLAYER
	context.fillRect 0, 0, PLAYER_WIDTH, PLAYER_HEIGHT

	context.fillStyle = Colour.PLAYER_STRIPE
	for i in [0...PLAYER_STRIPE_COUNT]
		context.fillRect i * 2 * PLAYER_STRIPE_WIDTH, 0, PLAYER_STRIPE_WIDTH, PLAYER_HEIGHT

	context.fillRect PLAYER_WIDTH - PLAYER_EYE_BORDER - PLAYER_EYE_SIZE,PLAYER_EYE_BORDER, PLAYER_EYE_SIZE, PLAYER_EYE_SIZE
	context.fillRect PLAYER_WIDTH - PLAYER_EYE_BORDER - PLAYER_EYE_SIZE,PLAYER_HEIGHT - PLAYER_EYE_BORDER - PLAYER_EYE_SIZE, PLAYER_EYE_SIZE + PLAYER_EYE_BORDER, PLAYER_EYE_SIZE