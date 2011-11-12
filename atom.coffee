window.atom = atom = {}
atom.input = {
  _bindings: {}
  _down: {}
  _pressed: {}
  _released: []

  bind: (key, action) ->
    @_bindings[key] = action

  onkeydown: (e) ->
    action = @_bindings[e.keyCode]
    return unless action

    @_pressed[action] = true unless @_down[action]
    @_down[action] = true

    e.stopPropagation()
    e.preventDefault()

  onkeyup: (e) ->
    action = @_bindings[e.keyCode]
    return unless action
    @_released.push action
    e.stopPropagation()
    e.preventDefault()

  clearPressed: ->
    for action in @_released
      @_down[action] = false
    @_released = []
    @_pressed = {}

  pressed: (action) -> @_pressed[action]
  down: (action) -> @_down[action]
}
document.onkeydown = atom.input.onkeydown.bind(atom.input)
document.onkeyup = atom.input.onkeyup.bind(atom.input)

atom.key =
  'TAB': 9
  'ENTER': 13
  'ESC': 27
  'SPACE': 32
  'LEFT_ARROW': 37
  'UP_ARROW': 38
  'RIGHT_ARROW': 39
  'DOWN_ARROW': 40

atom.canvas = document.getElementsByTagName('canvas')[0]
atom.context = atom.canvas.getContext '2d'

window.onresize = (e) ->
  atom.canvas.width = window.innerWidth
  atom.canvas.height = window.innerHeight
  atom.width = atom.canvas.width
  atom.height = atom.canvas.height
window.onresize()

class Game
  constructor: ->
    @fps = 30
  update: (dt) ->
  draw: ->
  run: ->
    @last_step = Date.now()
    @loop_interval = setInterval =>
      @step()
    , 1000/@fps
  stop: ->
    clearInterval @loop_interval if @loop_interval?
    @loop_interval = null
  step: ->
    now = Date.now()
    dt = now - @last_step
    @last_step = now
    @update(dt)
    @draw()
    atom.input.clearPressed()
atom.Game = Game
