Merge = require './merge'


module.exports = Render = 
  
  Render: (root, VDOM) ->
    Merge.entireTree root, VDOM

  HTMLify: require './HTMLify'
