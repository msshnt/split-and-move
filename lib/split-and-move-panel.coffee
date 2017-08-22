{CompositeDisposable, Emitter} = require 'atom'


class SAMPanelElement extends HTMLElement
  model: null
  message: null

  initialize: ( @model ) ->
    @model.on 'did-change-visible', @visibleChanged.bind( this )
    @model.on 'did-fail-to-move', @showError.bind( this )
    @model.on 'did-quit', @resetError.bind( this )
    this

  attachedCallback: ->

  detachedCallback: ->

  createdCallback: ->
    @setAttribute 'tabindex', 0

    title = document.createElement 'div'
    title.classList.add 'title'
    title.textContent = '[split-and-move] Move tabs'
    @appendChild title

    desc = document.createElement 'p'
    desc.innerHTML = """
                     - Press a number key of the pane which you want to move your active tab into.<br />
                     - To exit, press <kbd>Esc</kbd> or focus on elements other than this panel
                     """
    @appendChild desc

    @console = document.createElement 'p'
    @console.classList.add 'console', 'inline-block', 'highlight-error'
    @appendChild @console

  visibleChanged: ( visible ) ->
    if visible
      @addEventListener 'keypress', @onDidKeyPress
      @addEventListener 'keyup', @onDidKeyUp
      @addEventListener 'blur', @onDidBlur
    else
      @removeEventListener 'keypress', @onDidKeyPress
      @removeEventListener 'keyup', @onDidKeyUp
      @resetError()

  onDidKeyPress: ( event ) ->
    @model.emit 'did-key-press', event

  onDidKeyUp: ( event ) ->
    @model.emit 'did-key-up', event

  onDidBlur: ( event ) ->
    @model.emit 'did-blur', event

  showError: ( value ) ->
    if value.paneNum != null
      @console.textContent = "Pane Number #{value.paneNum} : #{value.message}"
    else
      @console.textContent = "#{value.message}"

  resetError: ->
    @console.textContent = ''

SAMPanelElement = document.registerElement 'sam-panel', prototype: SAMPanelElement.prototype


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
