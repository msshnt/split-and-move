{CompositeDisposable} = require 'atom'
SAMIndicatorManager = require './split-and-move-indicator-manager'
{SAMPanel} = require './split-and-move-panel'

module.exports = SAM =
  subscriptions: null
  config: require './split-and-move-config'
  manager: null
  panel: null

  targetItem: null
  targetPane: null

  activate: ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace',
      'split-and-move:split-right': => @splitPane 'right'
      'split-and-move:split-left' : => @splitPane 'left'
      'split-and-move:split-up'   : => @splitPane 'up'
      'split-and-move:split-down' : => @splitPane 'down'
      'split-and-move:start-move' : => @startMove()

    @indicatorManager = new SAMIndicatorManager()

    @panel = new SAMPanel
    @panel.onDidKeyPress @didKeyPress.bind( this )
    @panel.onDidKeyUp @didKeyUp.bind( this )
    @panel.onDidBlur @didBlur.bind( this )

  deactivate: ->
    @subscriptions.dispose()
    @indicatorManager.destroy()
    @indicatorManager = null

  notify: ( message ) ->
    atom.notifications.addInfo message

  splitPane: ( direction ) ->
    currentPane = atom.workspace.getActivePane()
    currentItem = currentPane.getActiveItem()
    pendingItem = currentPane.getPendingItem()
    isPending = currentItem == pendingItem
    params =
      'copyActiveItem': true

    if isPending and atom.config.get( 'split-and-move.forcePendingItemToBeMoved' )
      currentPane.clearPendingItem()
      isPending = false


    switch direction
      when 'right' then currentPane.splitRight( params )
      when 'left'  then currentPane.splitLeft( params )
      when 'up'    then currentPane.splitUp( params )
      when 'down'  then currentPane.splitDown( params )

    if currentPane.getItems().length > 1
      if isPending
        return
      currentPane.destroyItem( currentItem )

  startMove: ->
    if atom.workspace.getPanes().length < 2
      return
    else
      @targetItem = atom.workspace.getActivePaneItem()
      @panel.show()
      if atom.config.get( 'split-and-move.showIndicatorsOnlyWhenMoving' )
        @indicatorManager.toggleVisible true

  didKeyPress: ( event ) ->
    idx = parseInt event.key
    if Number.isNaN( idx )
      @panel.showError null, "Please input a number key."
      return
    panes = atom.workspace.getPanes()

    if !panes[idx]
      @panel.showError idx, "The selected pane doesn't exist in workspace."
    else if idx == panes.indexOf( atom.workspace.getActivePane() )
      @panel.showError idx, "The active tab already exists in the selected pane."
    else
      @moveTab panes[idx]

  didKeyUp: ( event ) ->
    if event.key == 'Escape'
      @quitMove false

  didBlur: ( event ) ->
    @quitMove false

  moveTab: ( pane ) ->
    @targetPane = pane
    currentPane = atom.workspace.getActivePane()
    if atom.config.get( 'split-and-move.alwaysMoveItemIntoEndOfPane' )
      idx = @targetPane.getItems().length
      currentPane.moveItemToPane @targetItem, @targetPane, idx
    else
      currentPane.moveItemToPane @targetItem, @targetPane
    @quitMove true

  quitMove: ( @moved ) ->
    @panel.hide()

    if atom.config.get( 'split-and-move.showIndicatorsOnlyWhenMoving' )
      @indicatorManager.toggleVisible false

    if @moved
      @targetPane.activateItem @targetItem
      @targetPane.activate()
      @targetItem = null
      @targetPane = null
      @moved = false
    else
      atom.workspace.getActivePane().activate()
