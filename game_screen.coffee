class window.GameScreen extends Screen
	constructor: (@playerControlled = yes) ->
		@player =
			x: PLAYER_START_X
			y: PLAYER_START_Y
			width: PLAYER_WIDTH
			height: PLAYER_HEIGHT
			velocity: 0
			acceleration: GRAVITY
			rotation: 0


		@firstPipeX = START_PIPE_X
		@pipes = [ ]
		for i in [0...PIPE_COUNT]
			@pipes.push @newPipe()

		@score = 0

		createPlayerCanvas()

		createBackgroundCanvas(Math.random() < DAYTIME_CHANCE)
		@backgroundScroll = 0

		createPlaneCanvas()
		@randomPlane = @generateRandomPlane()

		@trail = [ ]
		@trail.push [@player.x, @player.y + (@player.height / 2)]

		@time = 0

		@paused = no
		@pauseButton = new Button
			x: GAME_PAUSE_BUTTON_X + (GAME_SCORE_EXTRA_WIDTH / 2)
			y: GAME_SCORE_Y - (GAME_SCORE_EXTRA_WIDTH / 2)
			width: GAME_PAUSE_BUTTON_WIDTH
			height: GAME_PAUSE_BUTTON_HEIGHT
			text: "||"
			hoveredText: "||"

		@unpauseButton = new Button
			x: GAME_OVERLAY_X + GAME_OVERLAY_BUTTON_MARGIN
			y: GAME_OVERLAY_Y + GAME_OVERLAY_HEIGHT - GAME_OVERLAY_BUTTON_MARGIN - GAME_OVERLAY_BUTTON_HEIGHT
			width: GAME_OVERLAY_BUTTON_WIDTH
			height: GAME_OVERLAY_BUTTON_HEIGHT
			text: "Unpause"
			hoveredText: "> Unpause <"



	randomPipeHeight: -> randomNumberInclusive PIPE_MIN_HEIGHT, SCREEN_HEIGHT - PIPE_MIN_HEIGHT - PIPE_GAP_HEIGHT



	newPipe: -> baseHeight: @randomPipeHeight(), gapHeight: PIPE_GAP_HEIGHT, width: PIPE_WIDTH, scored: no



	playerJump: ->
		@player.velocity = JUMP_VELOCITY
		@player.rotation = PLAYER_JUMP_ROTATION



	update: (deltaTime) ->
		@time += deltaTime

		if @playerControlled
			if isKeyPressed Key.PAUSE
				@paused = not @paused
				return

			if @paused
				@unpauseButton.update deltaTime
				if @unpauseButton.clicked
					@paused = no
				return

			else
				@pauseButton.update deltaTime
				if @pauseButton.clicked
					@paused = yes
					return

			

		@player.rotation += PLAYER_ROTATION_SPEED * deltaTime

		@playerJump() if @playerControlled and (isKeyPressed(Key.JUMP) or isMousePressed())

		unless @playerControlled
			nextPipe = null

			x = @firstPipeX
			for pipe in @pipes
				if x + pipe.width >= @player.x
					nextPipe = pipe
					break

				x += pipe.width + PIPE_GAP_HORIZONTAL


			if nextPipe?
				pipeCenter = SCREEN_HEIGHT - nextPipe.baseHeight - (nextPipe.gapHeight / 2)
				yDifference = pipeCenter - @player.y

				if yDifference < PLAYER_AI_MIN_Y_DIFFERENCE
					@playerJump()


		@player.velocity += @player.acceleration * deltaTime
		@player.y += @player.velocity * deltaTime


		if @player.y + @player.height > SCREEN_HEIGHT
			@player.y = SCREEN_HEIGHT - @player.height
			@player.velocity = 0
			@gameOver() if @playerControlled

		if @player.y < 0
			@player.y = 0
			@player.velocity = 0
			@gameOver() if @playerControlled


		@firstPipeX -= MOVE_SPEED * deltaTime

		if @firstPipeX < -PIPE_WIDTH * 2
			for i in [1...@pipes.length]
				@pipes[i - 1] = @pipes[i]

			@pipes[PIPE_COUNT - 1] = @newPipe()

			@firstPipeX += PIPE_WIDTH + PIPE_GAP_HORIZONTAL


		@backgroundScroll -= MOVE_SPEED * BACKGROUND_PARALLAX * deltaTime
		if @backgroundScroll < -BACKGROUND_WIDTH
			@backgroundScroll += BACKGROUND_WIDTH


		for trail in @trail
			trail[0] -= MOVE_SPEED * deltaTime

		deleteFrom = -1
		for i in [@trail.length - 1..0] by -1
			if @trail[i][0] < 0
				deleteFrom = i - 1
				break

		if deleteFrom >= 0
			@trail.splice 0, deleteFrom + 1

		@trail.push [@player.x, @player.y + (@player.height / 2)]
		
		@player.rotation = -PLAYER_MAX_ROTATION if @player.rotation < -PLAYER_MAX_ROTATION
		@player.rotation = PLAYER_MAX_ROTATION if @player.rotation > PLAYER_MAX_ROTATION

		x = @firstPipeX
		collision = no
		for pipe in @pipes
			if x < @player.x + @player.width
				if x + pipe.width > @player.x and (@player.y + @player.height > SCREEN_HEIGHT - pipe.baseHeight or @player.y < SCREEN_HEIGHT - pipe.baseHeight - pipe.gapHeight)
					collision = yes
					break

				if x + pipe.width <= @player.x
					@score += 1 unless pipe.scored
					pipe.scored = yes

			x += pipe.width + PIPE_GAP_HORIZONTAL

		return @gameOver() if collision and @playerControlled



		@randomPlane.x -= RANDOM_PLANE_SPEED * deltaTime
		if @randomPlane.x + @randomPlane.width + RANDOM_PLANE_TRAIL_LENGTH < 0
			@randomPlane = @generateRandomPlane()



	generateRandomPlane: ->
		x: randomNumberInclusive RANDOM_PLANE_MIN_X, RANDOM_PLANE_MAX_X
		y: randomNumberInclusive RANDOM_PLANE_MIN_Y, RANDOM_PLANE_MAX_Y
		width: RANDOM_PLANE_WIDTH
		height: RANDOM_PLANE_HEIGHT

			


	gameOver: ->
		changeScreen new GameOverScreen @score, @backgroundScroll



	render: (context) ->
		context.fillStyle = "#ffffff"
		context.fillRect 0, 0, CANVAS_WIDTH, CANVAS_HEIGHT

		context.drawImage backgroundCanvas, Math.floor(@backgroundScroll), 0
		context.drawImage backgroundCanvas, Math.floor(@backgroundScroll + BACKGROUND_WIDTH), 0



		if @randomPlane.x < CANVAS_WIDTH
			context.drawImage planeCanvas, @randomPlane.x, @randomPlane.y
			context.fillStyle = "#ffffff"
			context.fillRect @randomPlane.x, @randomPlane.y + (@randomPlane.height * 0.75), RANDOM_PLANE_TRAIL_LENGTH, RANDOM_PLANE_TRAIL_THICKNESS



		context.fillStyle = Colour.PIPE
		x = @firstPipeX
		for pipe in @pipes
			break if x > CANVAS_WIDTH

			context.fillRect x, SCREEN_HEIGHT - pipe.baseHeight, PIPE_WIDTH, pipe.baseHeight
			context.fillRect x, 0, PIPE_WIDTH, SCREEN_HEIGHT - (pipe.baseHeight + pipe.gapHeight)

			x += pipe.width + PIPE_GAP_HORIZONTAL


		if @trail.length >= 1
			context.strokeStyle = Colour.PLAYER
			context.fillStyle = Colour.PLAYER
			context.lineWidth = PLAYER_TRAIL_THICKNESS
			context.beginPath()
			context.moveTo @trail[0][0], @trail[0][1]

			if @trail.length >= 2
				for i in [1...@trail.length]
					context.lineTo @trail[i][0], @trail[i][1]

			context.lineTo @player.x, @player.y + (@player.height / 2)

			context.lineTo @player.x + 8, @player.y + (@player.height / 2)

			context.stroke()


		context.translate @player.x, @player.y + (@player.height / 2)
		context.rotate @player.rotation * Math.PI / 180
		context.drawImage playerCanvas, 0, -@player.height / 2
		context.rotate -@player.rotation * Math.PI / 180
		context.translate -@player.x, -(@player.y + (@player.height / 2))



		if @playerControlled
			context.font = BODY_FONT
			context.textAlign = "left"
			context.textBaseline = "top"

			scoreText = "Score: #{@score}"

			context.fillStyle = Colour.TEXT_BACKGROUND
			context.fillRect GAME_SCORE_X - (GAME_SCORE_EXTRA_WIDTH / 2), GAME_SCORE_Y - (GAME_SCORE_EXTRA_WIDTH / 2), context.measureText(scoreText).width + GAME_SCORE_EXTRA_WIDTH, GAME_SCORE_HEIGHT

			context.beginPath()
			context.strokeStyle = Colour.TEXT
			context.lineWidth = OUTLINE_THICKNESS
			context.rect GAME_SCORE_X - (GAME_SCORE_EXTRA_WIDTH / 2), GAME_SCORE_Y - (GAME_SCORE_EXTRA_WIDTH / 2), context.measureText(scoreText).width + GAME_SCORE_EXTRA_WIDTH, GAME_SCORE_HEIGHT
			context.stroke()

			context.fillStyle = Colour.TEXT
			context.fillText scoreText, GAME_SCORE_X, GAME_SCORE_Y


			if @paused
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

				context.fillText "Paused", GAME_OVERLAY_TITLE_TEXT_X, GAME_OVERLAY_TITLE_TEXT_Y

				context.font = BODY_FONT
				context.fillText "Press P or Esc to unpause", GAME_OVERLAY_BODY_TEXT_X, GAME_OVERLAY_BODY_TEXT_Y

				@unpauseButton.render context

			else
				@pauseButton.render context