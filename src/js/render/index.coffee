Merge = require './merge'

module.exports = Update = (root, VDOM) ->
  Merge.entireTree root, VDOM