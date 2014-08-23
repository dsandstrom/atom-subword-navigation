{WorkspaceView} = require 'atom'
SubwordNavigation = require '../lib/subword-navigation'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "SubwordNavigation", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('subword-navigation')

  describe "when the subword-navigation:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.subword-navigation')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'subword-navigation:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.subword-navigation')).toExist()
        atom.workspaceView.trigger 'subword-navigation:toggle'
        expect(atom.workspaceView.find('.subword-navigation')).not.toExist()
