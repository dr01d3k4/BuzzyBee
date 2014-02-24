mouse =
	down: no
	x: -1
	y: -1

previousMouse =
	down: no
	x: -1
	y: -1

mouseLetGo = no



window.updateMouse = ->
	previousMouse.down = mouse.down
	previousMouse.x = mouse.x
	previousMouse.y = mouse.y

	if mouseLetGo
		mouse.down = no
		mouseLetGo = no



getMousePosition = (event) ->
	x = -1
	y = -1

	if not event.x? or not event.y?
		x = event.clientX + document.body.scrollLeft + document.documentElement.scrollLeft
		y = event.clientY + document.body.scrollTop + document.documentElement.scrollTop

	else
		x = event.x
		y = event.y

	x -= canvas.offsetLeft + CANVAS_BORDER_THICKNESS
	y -= canvas.offsetTop + CANVAS_BORDER_THICKNESS

	return [x, y]



setMousePosition = (event = window.event) ->
	[mouse.x, mouse.y] = getMousePosition event



window.onMouseDown = (event = window.event) ->
	mouse.down = yes
	setMousePosition event



window.onMouseMove = (event = window.event) ->
	setMousePosition event



window.onMouseUp = (event = window.event) ->
	mouseLetGo = yes
	setMousePosition event



window.isMouseDown = -> mouse.down

window.isMouseUp = -> not mouse.down

window.isMousePressed = -> mouse.down and not previousMouse.down

window.getMouseX = -> mouse.x

window.getMouseY = -> mouse.y

window.wasMouseDown = -> previousMouse.down

window.wasMouseUp = -> not previousMouse.down

window.setMouseDown = (down = no) ->
	mouse.down = down