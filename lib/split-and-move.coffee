{CompositeDisposable} = require 'atom'

module.exports =
  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'split-and-move:split-right': => @splitPane 'right'
      'split-and-move:split-left' : => @splitPane 'left'
      'split-and-move:split-up'   : => @splitPane 'up'
      'split-and-move:split-down' : => @splitPane 'down'

  deactivate: ->
    @subscriptions.dispose

  notify: ( message ) ->
    atom.notifications.addInfo message

  splitPane: ( direction ) ->
    currentPane = atom.workspace.getActivePane()
    currentItem = currentPane.getActiveItem()
    params =
      'copyActiveItem': true

    switch direction
      when 'right' then currentPane.splitRight( params )
      when 'left'  then currentPane.splitLeft( params )
      when 'up'    then currentPane.splitUp( params )
      when 'down'  then currentPane.splitDown( params )

    if currentPane.getItems().length > 1
      currentPane.destroyItem( currentItem )
