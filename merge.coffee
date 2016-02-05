# Dependencies
_           = require 'lodash'
Diff        = require './diff'
HTML        = require './htmlify'
styleString = require './style-string.coffee'


min = (a, b) -> 
  Math.min a?.length, b?.length

max = (a, b) ->
  Math.max a?.length, b?.length

{ getElementById
  createTextNode
  createElement
  querySelectorAll
  querySelector } = require './doc'


module.exports = Merge = 


  entireTree: (el, vo) ->

    el = @outer el, vo 
    @inner el, vo   


  outer: (el, vo) ->

    if vo.type is 'custom'
      vo = vo.children[0]

    unless Diff.outerHTML el, vo
      if Diff.type el, vo
        elsAttr = _.reduce el.attributes, 
          (sum, attr) ->
            { name, value } = attr 
            sum[name] = value
            sum
          {}
        vosAttr = vo.attributes

        attrs = _.extend {}, elsAttr, vosAttr
        _.forEach (_.keys attrs), (k) ->

          # If the virtual element has the
          # attribute, but not the element, 
          # then remove the attribute
          if (not vosAttr?[k]?) and elsAttr?[k]?
            el.removeAttribute k
          # Otherwise, if the virtual element
          # does have it, but the html element
          # doesnt ..
          else
            # .. and also that their values 
            # arent equal 
            if vosAttr[k] isnt elsAttr[k]
              v = vosAttr[k]
              switch k
                when 'style'
                  v = styleString v
                  el.setAttribute k, v
                when 'event' then (->)()
                when 'value'
                  if k is 'value'
                    el.value = vosAttr[k]
                  el.setAttribute k, vosAttr[k]
                when 'className'
                  el.setAttribute 'class', v
                else
                  el.setAttribute k, vosAttr[k]         

      else
        
        parent = el.parentNode

        if _.isString vo
          parent.removeChild el
          parent.textContent = vo
          el = vo
        else
          children = _.toArray el.children
          newEl    = HTML.single vo

          _.forEach children, (child) ->
            if _.isString child
              newEl.textContent = child
            else
              newEl.appendChild child

          parent.replaceChild newEl, el
          
          el = newEl

    el


  inner: (el, vo) ->
    if vo.type is 'custom'
      vo = vo.children[0]

    elsChildren = _.toArray el.children

    # console.log vo.children

    f = min elsChildren, vo.children
    _.times f, (fi) =>
      elChild = elsChildren[fi]
      voChild = vo.children[fi]

      elChild = Merge.outer elChild, voChild
      Merge.inner elChild, voChild

    s = max elsChildren, vo.children
    _.times (s - f), (si) =>
      elChild = elsChildren[ si + f ]
      voChild = vo.children[ si + f ]

      if elChild? then elChild.remove()
      else
        if _.isString voChild
          el.textContent = voChild
        else
          h = HTML.entireTree voChild
          el.appendChild h



