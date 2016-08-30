## Audio

# TODO: streaming music

atom = window.atom or {}
window.atom = atom
window.AudioContext = window.AudioContext or window.webkitAudioContext

atom.audioContext = new window.AudioContext?()

# https://developer.mozilla.org/en-US/docs/Web_Audio_API/Porting_webkitAudioContext_code_to_standards_based_AudioContext
atom._mixer = atom.audioContext?.createGainNode?() or atom.audioContext?.createGain?()
atom._mixer?.connect atom.audioContext.destination

atom.loadSound = (url, callback) ->
  return callback? 'No audio support' unless atom.audioContext

  request = new XMLHttpRequest()
  request.open 'GET', url, true
  request.responseType = 'arraybuffer'

  request.onload = ->
    atom.audioContext.decodeAudioData request.response, (buffer) ->
      callback? null, buffer
    , (error) ->
      callback? error

  try
    request.send()
  catch e
    callback? e.message

atom.sfx = {}
atom.preloadSounds = (sfx, cb) ->
  return cb? 'No audio support' unless atom.audioContext
  # sfx is { name: 'url' }
  toLoad = 0
  for name, url of sfx
    toLoad++
    do (name, url) ->
      atom.loadSound "sounds/#{url}", (error, buffer) ->
        console.error error if error
        atom.sfx[name] = buffer if buffer
        cb?() unless --toLoad

atom.playSound = (name, time = 0) ->
  return unless atom.sfx[name] and atom.audioContext
  source = atom.audioContext.createBufferSource()
  source.buffer = atom.sfx[name]
  source.connect atom._mixer
  (source.noteOn or source.start) time
  source

atom.setVolume = (v) ->
  atom._mixer?.gain.value = v
