# Dependencies
_ = require 'lodash'

{ deCamelCase, delimit } = require './utilities'

module.exports = StyleString = (style) ->
  _.reduce (_.keys style), 
    (styleAttr, key) ->
      styling = style[key]
      key     = deCamelCase key
      styleAttr + (delimit key, styling)
    ''