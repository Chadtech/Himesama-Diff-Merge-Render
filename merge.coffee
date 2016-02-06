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


setAttribute = (el, k, v) ->
  switch k
    when 'style'
      v = styleString v
      el.setAttribute k, v
    when 'event' then (->)()
    when 'value'
      el.value = v
      el.setAttribute k, v
    when 'className'
      if el.className isnt v
        el.setAttribute 'class', v
    else
      el.setAttribute k, v


fixAttributes = (el, vo) ->
  elsAttr = _.reduce el.attributes, 
    (sum, attr) ->
      { name, value } = attr 
      sum[name] = value
      sum
    {}
  vosAttr = vo.attributes
  vosAttr = {} if vosAttr is null

  attrs = _.extend {}, elsAttr, vosAttr
  attrs = _.keys attrs
  _.forEach attrs, (k) ->
    vv = vosAttr[k]
    ev = elsAttr[k]

    # If the element has the attribute
    # but the virtual element doesnt
    if (not vv?) and ev?
      el.removeAttribute k
    else
      # If they both have the 
      # attribute, but the attributes
      # values arent the same between
      # the element and the virtual
      # object
      if vv isnt ev
        setAttribute el, k, vv


replaceElement = (el, vo) ->
  parent   = el.parentNode
  children = _.toArray el.children
  newEl    = _.reduce children, 
    (nEl, child) ->
      if _.isString child
        newEl.textContent = child
      else
        newEl.appendChild child 
    HTML.single vo

  parent.replaceChild newEl, el
  newEl



module.exports = Merge = 

  entireTree: (el, vo) ->
    el = @outer el, vo 
    @inner el, vo   


  outer: (el, vo) ->

    if vo.type is 'custom'
      vo = vo.children[0]

    # If the element and the
    # virtual object are not
    # identical
    unless Diff.outerHTML el, vo
      # If they at least are of
      # the same type (html tag, 
      # like p or div)
      if Diff.type el, vo
        fixAttributes el, vo
      else
        if _.isString vo
          parent = el.parentNode
          parent.removeChild el
          parent.textContent = vo
          el = vo
        else          
          el = replaceElement el, vo
    el


  inner: (el, vo) ->
    { outer, inner } = Merge
    if vo.type is 'custom'
      vo = vo.children[0]

    elsChildren = _.toArray el.children

    #
    #   el   vo
    #    A    A   -       -
    #    B    B   | f=3   | s=5
    #    C    C   -       |
    #    D                |
    #    E                _
    #
    #   Iterate through the shorter
    #   list of children first,
    #   then iterate through the 
    #   remainder of the longer
    #   children list
    #

    f = min elsChildren, vo.children
    _.times f, (fi) =>
      elChild = elsChildren[fi]
      voChild = vo.children[fi]

      elChild = outer elChild, voChild
      inner elChild, voChild

    le = elsChildren.length
    lv = vo.children.length
    s  = max elsChildren, vo.children
    if le > lv
      _.times (s - f), (si) =>
        elsChildren[ si + f ].remove()

    else
      _.times (s - f), (si) =>
        elChild = elsChildren[ si + f ]
        voChild = vo.children[ si + f ]

        if _.isString voChild
          el.textContent = voChild
        else
          h = HTML.entireTree voChild
          el.appendChild h



