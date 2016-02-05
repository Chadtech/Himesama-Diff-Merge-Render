# Dependencies
_              = require 'lodash'
styleString    = require './style-string'
{ HTML, VDOM } = require './stringify'


module.exports = Diff =

  outerHTML: (el, vo) ->
    el = HTML el
    vo = VDOM vo
    el is vo

  type: (el, vo) ->
    nn = el.nodeName
    nn = nn.toLowerCase()
    nn is vo.type
