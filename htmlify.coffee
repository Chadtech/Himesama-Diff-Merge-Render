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
      if child.type is 'custom'
        child = child.children[0]
      el.appendChild (@entireTree child)
    el

  single: (vo) ->
    if vo.type is 'custom'
      vo = vo.children[0]

    if _.isString vo then createTextNode vo
    else
      keys = _.keys vo.attributes

      _.reduce keys, 
        (el, k) ->
          v = vo.attributes[k]
          k = deCamelCase k
          switch k
            when 'style'
              v = styleString v
              el.setAttribute k, v
            when 'class-name'
              el.setAttribute 'class', v
            when 'event'
              _.forEach (_.keys v), (e) =>
                el.addEventListener e, v[e]
            else
              el.setAttribute k, v
          el

        createElement vo.type
