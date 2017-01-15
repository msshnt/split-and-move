{CompositeDisposable} = require 'atom'
SAMIndicator = require './split-and-move-indicator'

module.exports =
  class SAMIndicatorManager
    subscriptions: null
    showIndicatorsOnlyWhenMoving: atom.config.get( 'split-and-move.showIndicatorsOnlyWhenMoving' )
    indicators: {}

    constructor: ->
      @subscriptions = new CompositeDisposable
      @subscriptions.add atom.config.onDidChange 'split-and-move.showIndicatorsOnlyWhenMoving', @onConfigChanged.bind( this )
      @subscriptions.add atom.workspace.observePanes @insert.bind( this )
      @subscriptions.add atom.workspace.onWillDestroyPane @onWillDestroyPane.bind( this )
      @subscriptions.add atom.workspace.onDidAddPane @onDidAddPane.bind( this )
      @subscriptions.add atom.workspace.onDidDestroyPane @onDidDestroyPane.bind( this )

    destroy: ->
      @subscriptions.dispose()
      for id, indicator of @indicators
        indicator.remove()
      @indicators = null

    onConfigChanged: ( event ) ->
      @showIndicatorsOnlyWhenMoving = event.newValue
      @toggleVisible !@showIndicatorsOnlyWhenMoving

    onWillDestroyPane: ( event ) ->
      @removeIndicator event.pane

    onDidAddPane: ( event ) ->
      @update()

    onDidDestroyPane: ( event ) ->
      @update()

    insert: ( pane )  ->
      indicator = @createIndicator pane
      indicator.update()

    update: ->
      for id, indicator of @indicators
        indicator.update()

    createIndicator: ( pane ) ->
      indicator = new SAMIndicator pane
      if @showIndicatorsOnlyWhenMoving
        indicator.hide()

      indicator.append()
      @indicators[pane.id] = indicator
      indicator

    removeIndicator: ( pane ) ->
      id = pane.id
      indicator = @indicators[id]
      indicator.remove()
      delete @indicators[id]

    toggleVisible: ( visible ) ->
      for id, indicator of @indicators
        if visible == true
          indicator.show()
        else
          indicator.hide()
