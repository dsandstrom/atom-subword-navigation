SubwordNavigation = require './subword-navigation'

module.exports =
  activate: (state) ->
    atom.workspaceView.eachEditorView (editorView) ->
      subwordNavigation = new SubwordNavigation(editorView.editor)

      editorView.command "subword-navigation:move-right", ->
        subwordNavigation.moveToNextSubwordBoundary()
      editorView.command "subword-navigation:move-left", ->
        subwordNavigation.moveToPreviousSubwordBoundary()
      editorView.command "subword-navigation:select-right", ->
        subwordNavigation.selectToNextSubwordBoundary()
      editorView.command "subword-navigation:select-left", ->
        subwordNavigation.selectToPreviousSubwordBoundary()
      editorView.command "subword-navigation:delete-right", ->
        subwordNavigation.deleteToNextSubwordBoundary()
      editorView.command "subword-navigation:delete-left", ->
        subwordNavigation.deleteToPreviousSubwordBoundary()

  deactivate: ->
