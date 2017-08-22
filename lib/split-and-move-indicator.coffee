{CompositeDisposable, Emitter} = require 'atom'


class SAMIndicatorElement extends HTMLElement
  initialize: ( @model ) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add @model.on 'did-append', @onDidAppend.bind( this )
    @subscriptions.add @model.on 'did-remove', @onDidRemove.bind( this )
    @subscriptions.add @model.on 'did-update', @onDidUpdate.bind( this )
    this

  attachedCallback: ->

  detachedCallback: ->

  createdCallback: ->
    @textContent = '[split-and-move] Pane Number : '
    @number = document.createElement 'span'
    @appendChild @number

  onDidAppend: ->
    view = atom.views.getView @model.pane
    view.appendChild this

  onDidRemove: ->
    view = atom.views.getView @model.pane
    view.removeChild this
    @subscriptions.dispose()

  onDidUpdate: ->
    idx = atom.workspace.getPanes().indexOf @model.pane
    @number.textContent = idx

  show: ->
    @classList.remove 'invisible'

  hide: ->
    @classList.add 'invisible'

SAMIndicatorElement = document.registerElement 'sam-indicator', prototype: SAMIndicatorElement.prototype


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
