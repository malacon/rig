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