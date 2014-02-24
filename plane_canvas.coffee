window.planeCanvas = null



window.createPlaneCanvas = ->
	window.planeCanvas = createCanvas RANDOM_PLANE_WIDTH, RANDOM_PLANE_HEIGHT
	context = planeCanvas.getContext "2d"

	context.strokeStyle = "#ffffff"
	context.fillStyle = "#ffffff"


	fuselageHeight = RANDOM_PLANE_HEIGHT / 2
	fuselageLength = RANDOM_PLANE_WIDTH * 0.7

	context.arc(fuselageHeight / 2, RANDOM_PLANE_HEIGHT - (fuselageHeight / 2), fuselageHeight / 2, 0.5 * Math.PI, 1.5 * Math.PI)
	context.fill()
	context.fillRect(fuselageHeight / 2, RANDOM_PLANE_HEIGHT - fuselageHeight, fuselageLength - (fuselageHeight / 2), fuselageHeight)

	context.beginPath()
	context.moveTo(fuselageLength, RANDOM_PLANE_HEIGHT - fuselageHeight)
	context.lineTo(fuselageLength + ((RANDOM_PLANE_WIDTH - fuselageLength) * 0.1), RANDOM_PLANE_HEIGHT - fuselageHeight)
	context.lineTo(fuselageLength + ((RANDOM_PLANE_WIDTH - fuselageLength) * 0.6), 0)
	context.lineTo(RANDOM_PLANE_WIDTH, 0)
	context.lineTo(fuselageLength + ((RANDOM_PLANE_WIDTH - fuselageLength) * 0.7), RANDOM_PLANE_HEIGHT - fuselageHeight)
	context.lineTo(RANDOM_PLANE_WIDTH, RANDOM_PLANE_HEIGHT - (fuselageHeight * 0.9))
	context.lineTo(fuselageLength, RANDOM_PLANE_HEIGHT)
	context.closePath()
	context.fill()