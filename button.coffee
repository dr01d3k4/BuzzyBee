class window.Button
	constructor: (options) ->
		@x = options.x or 0
		@y = options.y or 0
		@width = options.width or 0
		@height = options.height or 0
		@text = options.text or 0
		@hoveredText = options.hoveredText or 0
		@hovered = no
		@clicked = no



	update: (deltaTime) ->
		mouseX = getMouseX()
		mouseY = getMouseY()

		@hovered = mouseX >= @x and mouseX <= @x + @width and mouseY >= @y and mouseY <= @y + @height
		@clicked = @hovered and isMousePressed()



	render: (context) ->
		context.fillStyle = if @hovered then Colour.BUTTON_HOVER_BACKGROUND else Colour.TEXT_BACKGROUND
		context.fillRect @x, @y, @width, @height


		context.beginPath()
		context.strokeStyle = Colour.TEXT
		context.lineWidth = OUTLINE_THICKNESS
		context.rect @x, @y, @width, @height
		context.stroke()


		context.fillStyle = Colour.TEXT
		context.font = BODY_FONT
		context.textAlign = "center"
		context.textBaseline = "middle"

		text = if @hovered then @hoveredText else @text
		context.fillText text, @x + (@width / 2), @y + (@height / 2)