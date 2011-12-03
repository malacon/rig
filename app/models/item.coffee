Spine = require('spine')

class Item extends Spine.Model
  @configure 'Item', 'name', 'type', 'costMatrix', 'quantity', 'details'

  @endpoint: 'http://localhost:9294/data.json'

  @fetch: ->
    $.getJSON(@endpoint, (res) => @refresh(res, clear: true))
  
  getCost: ->
    @costMatrix[@quantity]

  removeFromCart: ->
    @quantity = 0

  @typeSort: (a, b) ->
    a.type < b.type

  #@extend Spine.Model.Local
  
  @filter: (query) ->
    return @all() unless query
    query = query.toLowerCase()
    @select (item) ->
      item.type?.toLowerCase().indexOf(query) isnt -1

  @calculateTotal: ->
    total = 0
    for key, value of @records
      if value.costMatrix[value.quantity]
        total = total + value.costMatrix[value.quantity]
    if total <= 0
      total = "0"
    total

  @countInBasket: ->
    @purchased().length
  
  @purchased: ->
    @select (item) ->
      item.quantity > 0

  @emptyCart: ->
    @select (item) ->
      item.quantity = 0
      item.save()
  

  @getItemsByTypeArr: (types) ->
    items = {}
    for type in types
      items[type] = @filter(type)
    items

module.exports = Item
