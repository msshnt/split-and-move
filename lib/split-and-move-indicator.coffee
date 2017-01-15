{CompositeDisposable, Emitter} = require 'atom'
SAMIndicatorElement = require './split-and-move-indicator-element'

class SAMIndicator
  constructor: ( @pane ) ->
    @emitter = new Emitter
    @view = atom.views.getView this

  on: ( eventName, callback ) ->
    @emitter.on eventName, callback

  append: ->
    @emitter.emit 'did-append'

  remove: ->
    @emitter.emit 'did-remove'

  update: ->
    @emitter.emit 'did-update'

  show: ->
    @view.show()

  hide: ->
    @view.hide()

atom.views.addViewProvider SAMIndicator, ( model ) ->
  new SAMIndicatorElement().initialize model

module.exports = SAMIndicator
