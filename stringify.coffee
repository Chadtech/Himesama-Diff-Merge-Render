# Dependencies
_           = require 'lodash'
styleString = require './style-string.coffee'

module.exports = Stringify = 

  HTML: (el) ->
    attributes = _.map el.attributes, 
      (attr) ->
        { name, value } = attr 
        name + '=' + value + ' '

    _.reduce attributes, 
      (sum, attr) -> sum + attr
      (el.nodeName + ' ').toLowerCase()

  VDOM: (vo) ->
    keys = _.keys vo.attributes
    attributes = _.map keys,
      (k) ->
        v = vo.attributes[k]
        v = styleString v if k is 'style'
        k = 'class' if k is 'className'

        if k is 'event' then ''
        else k + '=' + v + ' '

    _.reduce attributes, 
      (sum, attr) -> sum + attr
      vo.type + ' '