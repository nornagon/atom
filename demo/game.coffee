class Game extends atom.Game
  constructor: ->
    super
    atom.input.bind atom.key.LEFT_ARROW, 'left'
    atom.input.bind atom.key.RIGHT_ARROW, 'right'
    atom.input.bind atom.key.SPACE, 'jump'

    @speed = 200
    @gravity = 9.8
    @player =
      width: 100
      height: 100
      x: atom.width/2
      y: atom.height
      vy: 0
      color: 'white'

  update: (dt) ->
    if atom.input.pressed 'right'
      @player.color = 'red'

    if atom.input.pressed 'left'
      @player.color = 'blue'

    if atom.input.down 'right'
      @player.x += dt * @speed

    if atom.input.down 'left'
      @player.x -= dt * @speed

    if atom.input.pressed 'jump'
      @player.color = 'white'
      @player.vy = -8
    
    @player.y = Math.min atom.height, @player.y + @player.vy
    @player.vy += dt * @gravity

  draw: ->
    atom.context.fillStyle = 'black'
    atom.context.fillRect 0, 0, atom.width, atom.height

    atom.context.fillStyle = @player.color
    atom.context.fillRect @player.x-@player.width/2, @player.y-@player.height, @player.width, @player.height 

game = new Game

window.onblur = -> game.stop()
window.onfocus = -> game.run()

game.run()
