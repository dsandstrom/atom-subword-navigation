{CompositeDisposable} = require 'atom'
SubwordNavigation = require './subword-navigation'

module.exports =
  subscriptions: null

  activate: (state) ->
    subwordNavigation = new SubwordNavigation()
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
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
    @subscriptions.dispose()
