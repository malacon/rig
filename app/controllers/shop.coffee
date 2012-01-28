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

Item = require('models/item')
Main = require('controllers/shop.main')
Shelf = require('controllers/shop.shelf')

class Shop extends Spine.Controller
  types: ['cards', 'profiles', 'slicks', 'misc']

  constructor: ->
    super

    # Instantiate the shelf and body
    @main = new Main (el: '.ui-layout-center', types: @types)
    @shelf = new Shelf (el: '.ui-layout-west', types: @types)

    # Triggers 
    Spine.bind 'item:show', (params) =>
      #for type, list of @shelf.list
      #  list.removeActive()
      @shelf.active(params)
      @main.showItem.active(params)

    Spine.bind 'item:edit', (params) =>
      @shelf.active(params)
      @main.editItem.active(params)

    Spine.bind 'cart:show', =>
      for type, list of @shelf.list
        list.removeActive()
      @main.cart.active()
      @main.cart.list.render()

    Spine.bind 'cart:checkout', =>
      @main.checkout.active()
      @main.checkout.list.render()

    # Set the main to the cart
    @main.cart.active()

    # Load items for different types
    Item.fetch()

    $( "#accordion" ).accordion({
      autoHeight: false
    })

    
module.exports = Shop