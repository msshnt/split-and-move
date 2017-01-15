{CompositeDisposable, Emitter} = require 'atom'
SAMPanelElement = require './split-and-move-panel-element'


class SAMPanelModel
  constructor: ->
    @emitter = new Emitter
    @view = atom.views.getView( this )

  on: ( eventName, callback ) ->
    @emitter.on eventName, callback

  emit: ( eventName, value ) ->
    @emitter.emit eventName, value

  focus: ->
    @view.focus()


atom.views.addViewProvider SAMPanelModel, ( model ) ->
  new SAMPanelElement().initialize model


class SAMPanel
  subscriptions: null
  model: null
  panel: null

  constructor: ->
    @subscriptions = new CompositeDisposable

    @model = new SAMPanelModel
    @panel = atom.workspace.addModalPanel
      item: @model
      visible: false

    @subscriptions.add @panel.onDidChangeVisible @visibleChanged.bind( this )

  destroy: ->
    @subscriptions.dispose()

  visibleChanged: ( visible ) ->
    if visible
      @model.emit 'did-change-visible', true
    else
      @model.emit 'did-change-visible', false

  onDidKeyPress: ( callback ) ->
    @model.on 'did-key-press', callback

  onDidKeyUp: ( callback ) ->
    @model.on 'did-key-up', callback

  onDidBlur: ( callback ) ->
    @model.on 'did-blur', callback

  show: ->
    @panel.show()
    @model.focus()

  hide: ->
    @panel.hide()

  showError: ( paneNum, message ) ->
    @model.emit 'did-fail-to-move',
      'paneNum': paneNum,
      'message': message

  resetError: ->
    @model.emit 'did-quit'


exports.SAMPanelModel = SAMPanelModel
exports.SAMPanel = SAMPanel
