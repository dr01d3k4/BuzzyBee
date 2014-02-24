unless typeof String::startsWith is "function"
	String::startsWith = (prefix) -> @indexOf(prefix) is 0



unless typeof String::endsWith is "function"
	String::endsWith = (suffix) -> @indexOf(suffix, @length - suffix.length) isnt -1



window.canvas = null
context = null



screen = null


window.changeScreen = (newScreen) ->
	screen.close() if screen?
	screen = newScreen
	cleanKeys()
	updateKeys()
	updateMouse()


lastTime = Date.now()
now = Date.now()
deltaTime = 0



main = ->
	window.requestAnimFrame main
	
	now = Date.now()
	deltaTime = (now - lastTime) / 1000.0

	screen.update deltaTime
	screen.render context

	updateKeys()
	updateMouse()

	lastTime = now



window.onload = ->
	window.canvas = createCanvas CANVAS_WIDTH, CANVAS_HEIGHT
	document.body.appendChild canvas

	canvas.setAttribute "tabindex", "1"
	canvas.focus()

	canvas.onkeydown = onKeyDown
	canvas.onkeyup = onKeyUp
	canvas.onmousedown = onMouseDown
	canvas.onmousemove = onMouseMove
	canvas.onmouseup = onMouseUp

	context = canvas.getContext "2d"

	createPlayerCanvas()
	createBackgroundCanvas(Math.random() < DAYTIME_CHANCE)
	createPlaneCanvas()

	changeScreen new MainMenuScreen()

	lastTime = Date.now()
	main()