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

Spine   = require('spine')
Manager = require('spine/lib/manager')
List    = require('lib/list')
$       = Spine.$

Item  = require('models/item')

class Shelf extends Spine.Controller
  elements:
    '.itemsList': 'items'

  constructor: ->
    super

    @html require('views/shelf')

    @list = {}

    for type in @types
      @list[type] = new List
        el: '.' + type,
        template: require('views/item'),
        selectFirst: false

      list = @list[type]
      list.bind 'change', @change

      @active (params) -> 
        #@log(params)
        list.change(Item.find(params.id))

    Item.bind('refresh change', @render)

  render: =>
    for type in @types
      list = @list[type]
      items = Item.filter(type)
      #list.removeActive()
      list.render(items)

#    # Create List .... WILL NEED to make multiple for each type
#    @list = new List
#      el: @items, 
#      template: require('views/item'), 
#      selectFirst: false
#
#    @list.bind 'change', @change
#
#    @active (params) -> 
#      @list.change(Item.find(params.id))
#    
#    Item.bind('refresh change', @render)
#
#  render: =>
#    items = Item.all()
#    @list.render(items)

  change: (item) =>      
    Spine.trigger 'item:show', item
    
module.exports = Shelf