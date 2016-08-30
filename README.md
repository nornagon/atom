# atom
#### a &lt;canvas&gt; game framework that does as little as possible

Honestly, this thing does so little that you should just read the code.

Here's what a game using Atom looks like:

```coffeescript
class Game extends atom.Game
  constructor: ->
    super
    atom.input.bind atom.key.LEFT_ARROW, 'left'
    atom.input.bind atom.key.RIGHT_ARROW, 'right'

  update: (dt) ->
    if atom.input.pressed 'left'
      console.log "player started moving left"
    else if atom.input.down 'left'
      console.log "player still moving left"

  draw: ->
    atom.context.fillStyle = 'black'
    atom.context.fillRect 0, 0, atom.width, atom.height
    # Carry on.

game = new Game

window.onblur = -> game.stop()
window.onfocus = -> game.run()

game.run()
```
```html
<canvas></canvas>
<script src="atom.js"></script>
<script src="game.js"></script>
```

#### not a library
atom isn't intended to be used as a library, to be `npm install`ed and `require()`d. It's intended to be a starting point, a nucleus around which you build your game. Copy it into your source folder and tweak it when you need to.
