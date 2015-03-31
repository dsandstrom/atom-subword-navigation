SubwordNavigation = require './subword-navigation'

module.exports =
  activate: (state) ->
    subwordNavigation = new SubwordNavigation()

    atom.commands.add 'atom-workspace',
      "subword-navigation:move-right": ->
        subwordNavigation.moveToNextSubwordBoundary()
      "subword-navigation:move-left": ->
        subwordNavigation.moveToPreviousSubwordBoundary()
      "subword-navigation:select-right": ->
        subwordNavigation.selectToNextSubwordBoundary()
      "subword-navigation:select-left": ->
        subwordNavigation.selectToPreviousSubwordBoundary()
      "subword-navigation:delete-right": ->
        subwordNavigation.deleteToNextSubwordBoundary()
      "subword-navigation:delete-left": ->
        subwordNavigation.deleteToPreviousSubwordBoundary()

  deactivate: ->
