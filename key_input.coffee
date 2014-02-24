keys = [ ]
previousKeys = [ ]

for i in [0...255]
	keys[i] = no
	previousKeys[i] = no



respondToKeyDownFunction = null



window.onKeyDown = (event = window.event) ->
	keys[event.keyCode] = yes
	respondToKeyDownFunction event.keyCode if respondToKeyDownFunction?



window.onKeyUp = (event = window.event) -> keys[event.keyCode] = no



window.updateKeys = ->
	for i in [0...keys.length]
		previousKeys[i] = keys[i]
	null


window.cleanKeys = ->
	for i in [0...keys.length]
		keys[i] = no
		previousKeys[i] = no
	null



window.Key =
	JUMP: [38, 87, 32, 13]
	PAUSE: [27, 80]


window.isKeyDownIn = (key, array) ->
	for i in [0...key.length]
		return yes if array[key[i]]
	no



window.isKeyDown = (key) -> isKeyDownIn key, keys

window.isKeyUp = (key) -> not isKeyDown key

window.wasKeyDown = (key) -> isKeyDownIn key, previousKeys

window.wasKeyUp = (key) -> not wasKeyDown key

window.isKeyPressed = (key) -> isKeyDown(key) and not wasKeyDown(key)

window.setRespondToKeyDownFunction = (func) -> respondToKeyDownFunction = func