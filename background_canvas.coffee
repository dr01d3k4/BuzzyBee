window.backgroundCanvas = null 



window.createBackgroundCanvas = (daytime = yes) ->
	window.backgroundCanvas = createCanvas BACKGROUND_WIDTH, CANVAS_HEIGHT
	context = backgroundCanvas.getContext "2d"

	context.fillStyle = if daytime then Colour.DAY_SKY else Colour.NIGHT_SKY
	context.fillRect 0, 0, BACKGROUND_WIDTH, SCREEN_HEIGHT
	context.fillStyle = Colour.GROUND
	context.fillRect 0, SCREEN_HEIGHT, BACKGROUND_WIDTH, GROUND_GRASS_HEIGHT
	context.fillStyle = Colour.PIPE
	context.fillRect 0, SCREEN_HEIGHT + GROUND_GRASS_HEIGHT, BACKGROUND_WIDTH, GROUND_HEIGHT - GROUND_GRASS_HEIGHT



	unless daytime
		context.fillStyle = Colour.STAR
		for i in [0...STAR_COUNT]
			x = randomNumberExclusive 0, BACKGROUND_WIDTH
			y = randomNumberExclusive MIN_STAR_HEIGHT, MAX_STAR_HEIGHT
			size = randomNumberInclusive 1, STAR_MAX_SIZE

			context.beginPath()
			context.arc x, y, size, 0, 2 * Math.PI
			context.fill()



	buildingPosition = 0
	light_chance = if daytime then BUILDING_LIGHT_ON_DAY_CHANCE else BUILDING_LIGHT_ON_NIGHT_CHANCE
	while buildingPosition < BACKGROUND_WIDTH
		if Math.random() < BUILDING_HERE_CHANCE
			storeys = randomNumberInclusive(BUILDING_MIN_STOREYS, BUILDING_MAX_STOREYS)
			height = storeys * BUILDING_STOREY_HEIGHT

			context.fillStyle = Colour.BUILDING
			context.fillRect buildingPosition, SCREEN_HEIGHT - height, BUILDING_WIDTH, height


			for storey in [1...storeys + 1]
				for x in [0...BUILDING_WINDOWS_WIDE]
					for y in [0...BUILDING_WINDOWS_HIGH]
						if Math.random() < light_chance
							context.fillStyle = Colour.BUILDING_LIGHT_ON
						else
							context.fillStyle = Colour.BUILDING_LIGHT_OFF

						context.fillRect buildingPosition + (BUILDING_WINDOW_WIDTH / 2) + (x * BUILDING_WINDOW_WIDTH * 2), SCREEN_HEIGHT - (storey * BUILDING_STOREY_HEIGHT) + (BUILDING_WINDOW_HEIGHT / 2) + (y * BUILDING_WINDOW_HEIGHT * 2), BUILDING_WINDOW_WIDTH, BUILDING_WINDOW_HEIGHT



		buildingPosition += BUILDING_WIDTH