module.exports =
  alwaysMoveItemIntoEndOfPane:
    type: 'boolean'
    default: false
  forcePendingItemToBeMoved:
    type: 'boolean'
    default: false
    description: 'When attempting to split the current item and it\'s in a pending state, this option forces it to be *moved* into a new pane.'
  showIndicatorsOnlyWhenMoving:
    type: 'boolean'
    default: false
