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


module.exports = SAMPanelElement = document.registerElement 'sam-panel', prototype: SAMPanelElement.prototype
