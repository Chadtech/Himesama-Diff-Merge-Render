# Dependencies
_           = require 'lodash'
styleString = require './style-string.coffee'

# Utilities
{ deCamelCase } = require './utilities'
{ getElementById
  createTextNode
  createElement
  querySelectorAll
  querySelector } = require './doc'

module.exports = HTMLify =

  entireTree: (vo) ->
    el = @single vo
    _.forEach vo.children, (child) =>
      el.appendChild (@entireTree child)
    el

  single: (vo) ->
    if typeof vo is 'string'
      createTextNode vo

    else
      keys = _.keys vo.attributes

      _.reduce keys, 
        (el, k) ->
          v = vo.attributes[k]
          v = deCamelCase v
          switch k
            when 'style'
              v = styleString v
              el.setAttribute k, v
            when 'className'
              el.setAttribute 'class', v
            when 'event'
              _.forEach (_.keys v), (e) =>
                el.addEventListener e, v[e]
            else
              el.setAttribute k, v
          el

        createElement vo.type