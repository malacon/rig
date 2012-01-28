###
This file is part of Shopping Cart.

    Foobar is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Foobar is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Shopping Cart.  If not, see <http://www.gnu.org/licenses/>.
###

Spine = require('spine')

class Item extends Spine.Model
  @configure 'Item', 'name', 'type', 'costMatrix', 'quantity', 'details', 'isOriginal', 'qrCost'

  @endpoint: 'http://shawmoodle.org:9294/data.json'

  @fetch: ->
    $.getJSON(@endpoint, (res) => @refresh(res, clear: true))
  
  save: ->
    super

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
  
  @allToString: ->
    result = []
    @select (item) ->
      result.push("#{item.name} #{item.quantity}")
    result

  @getItemsByTypeArr: (types) ->
    items = {}
    for type in types
      items[type] = @filter(type)
    items

module.exports = Item
