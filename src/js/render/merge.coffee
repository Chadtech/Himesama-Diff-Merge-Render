# Dependencies
_            = require 'lodash'
Diff         = require './diff'
HTMLify      = require './htmlify'
{ min, max } = Math
{ getElementById
  createTextNode
  createElement
  querySelectorAll
  querySelector } = require './doc'


module.exports = Merge = 


  entireTree: (el, vo) ->
    el = @outer el, vo 
    @inner el, vo, @inner   


  outer: (el, vo) ->

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
        keys  = _.keys attrs
        _.forEach keys, (k) ->
          if (not vosAttr[k]?) and elsAttr[k]?
            el.removeAttribute k
          else
            if vosAttr[k] isnt elsAttr[k]
              el.setAttribute k, vosAttr[k]         

      else
        parent   = el.parentNode
        children = _.toArray el.children
        newEl    = HTMLify.single vo

        _.forEach children, (child) ->
          if _.isString child
            # child = createTextNode child
            newEl.textContent = child
          else
            newEl.appendChild child

        parent.replaceChild newEl, el
        
        el = newEl

    el


  inner: (el, vo, next) ->
    elsChildren = _.toArray el.children

    f = min elsChildren.length, vo.children.length
    _.times f, (fi) =>
      elChild = elsChildren[fi]
      voChild = vo.children[fi]

      elChild = Merge.outer elChild, voChild
      if next? then next elChild, voChild, next

    s = max elsChildren.length, vo.children.length
    _.times (s - f), (si) =>
      elChild = elsChildren[ si + f ]
      voChild = vo.children[ si + f ]

      if _.isString voChild
        # voChild = createTextNode voChild
        el.textContent = voChild
      else
        if elChild? then elChild.remove()
        else
          el.appendChild (HTMLify.entireTree voChild)



