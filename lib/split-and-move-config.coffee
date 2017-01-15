module.exports =
  alwaysMoveItemIntoEndOfPane:
    type: 'boolean'
    default: false
  forcePendingItemToBeMoved:
    type: 'boolean'
    default: false
    description: 'When splitting, this option forces the current item to be moved into a new pane if it is in a pending state.'
  showIndicatorsOnlyWhenMoving:
    type: 'boolean'
    default: false
