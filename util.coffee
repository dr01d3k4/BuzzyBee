window.requestAnimFrame = (-> window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (callback) -> setTimout callback, 1000 / 60)()



window.randomNumberExclusive = (lower = 0, upper = 1) -> Math.floor(Math.random() * (upper - lower)) + lower



window.randomNumberInclusive = (lower = 0, upper = 1) -> Math.floor(Math.random() * (upper + 1 - lower)) + lower



window.setCanvasSize = (canvas, width = 0, height = 0) ->
	canvas.width = width
	canvas.height = height
	canvas

window.createCanvas = (width = 0, height = 0) -> setCanvasSize document.createElement("canvas"), width, height