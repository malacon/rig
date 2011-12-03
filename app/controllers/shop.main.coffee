Spine   = require('spine')
Manager = require('spine/lib/manager')
List    = require('lib/list')
$       = Spine.$

Item  = require('models/item')

$.fn.serializeForm = ->
  result = {}
  for item in $(@).serializeArray()
    result[item.name] = item.value
  result

class ShowItem extends Spine.Controller
  className: 'showItem'

  events:
    'click .edit': 'edit'
    'click .showCart': 'showCart'
  
  constructor: ->
    super
    @active @change
  
  render: ->
    @html require('views/showItem')(@item)
    
  change: (params) =>
    @item = Item.find(params.id)
    @render()
    
  edit: ->
    Spine.trigger 'item:edit', @item

  showCart: ->
    Spine.trigger 'cart:show'

class EditItem extends Spine.Controller
  className: 'editItem'

  events:
    'submit .save': 'submit'
    'click .save': 'submit'
    'click .cancel': 'cancel'
    'click .delete': 'delete'
    
  elements: 
    'form': 'form'
    
  constructor: ->
    super
    @active @change
  
  render: ->
    @html require('views/editItem')(@item)
    
  change: (params) =>
    @item = Item.find(params.id)
    @render()
    
  submit: (e) ->
    e.preventDefault()
    params = @form.serializeForm()
    @item.updateAttributes(params)
    Spine.trigger 'cart:show'

  cancel: (e) ->
    e.preventDefault()
    Spine.trigger 'cart:show'   
    
  delete: ->
    @item.removeFromCart() if confirm('Are you sure?')
    @item.save()
    Spine.trigger 'cart:show'

class Cart extends Spine.Controller
  className: 'cart'

  elements:
    '.purchasedList': 'content'
    '.total': 'total'

  events:
    'click .checkout': 'checkout'
    'click .remove': 'removeItem'
    'click .edit': 'change'
    'click .empty': 'empty'
    'mouseenter .item': 'showImage'
    'mouseleave .item': 'hideImage'

  constructor: ->
    super
    @active
    @html require('views/cart')

    @list = new List
      el: @content, 
      template: require('views/cartItem'), 
      selectFirst: false

    #@list.bind 'change', @change
    @list.bind 'destroy', @destroy

    Item.bind('refresh change', @render)
    @active -> 
      @render()
    
    $('img').hide()

  render: =>
    items = Item.purchased()
    @list.render(items)
    $('img').hide()
    totalCost = Item.calculateTotal()
    @total.html(require('views/total')(totalCost))


  # Pulls the item from the ID stored in the button and 
  #   Loads the edit item screen
  change: (e) =>
    @item = Item.find($(e.target).attr('id'))
    if @item
      Spine.trigger 'item:edit', @item

  # Should change the height of the li when hovered over and then return back when finished
  showImage: (e) =>
    imgId = '#img_' + $(e.target).attr('id')
    $(imgId).slideDown("slow")

  hideImage: (e) =>
    imgId = '#img_' + $(e.target).attr('id')
    $(imgId).slideUp("slow")

  checkout: =>
    if (Item.countInBasket() <= 0)
      alert "There is nothing in your basket to check out."
    else 
      Spine.trigger 'cart:checkout'

  removeItem: (e) =>
    @item = Item.find($(e.target).attr('id'))
    @item.removeFromCart() if confirm('Are you sure?')
    @item.save()
    Spine.trigger 'cart:show'

  empty: ->
    if confirm('Are you sure you want to empty the cart?')
      Item.emptyCart()
      Spine.trigger 'cart:show'

class Checkout extends Spine.Controller
  className: 'checkoutWindow'

  elements:
    '.purchasedList': 'content'
    '.total': 'total'
    'form#checkout': 'form'

  events:
    'click .cancel': 'cancel'
    'click .yes': 'submit'

  url: 'http://www.kylehbaker.com/form/email.php'

  constructor: ->
    super
    @active
    @html require('views/checkout')
    $('#checkout').html5form()

    @list = new List
      el: @content, 
      template: require('views/cartItem'), 
      selectFirst: false

    @list.bind 'change', @change

    Item.bind('refresh change', @render)

    @active -> 
      @render()

  render: =>
    items = Item.purchased()
    @list.render(items)
    totalCost = Item.calculateTotal()
    @total.html(require('views/total')(totalCost))

  submit: (e) ->
    e.preventDefault()
    params = @form.serializeForm()
    params.items = JSON.stringify(Item.purchased())
    #@log(params)
    # Check to see if params meet requirements, else throw error

    # Otherwise send form via ajax
    $.post @url, params, (data) -> alert(data)

  cancel: (e) ->
    e.preventDefault()
    Spine.trigger 'cart:show' 

class Main extends Spine.Controller
  className: 'main'

  constructor: ->
    super
    @showItem     = new ShowItem
    @editItem     = new EditItem
    @cart         = new Cart
    @checkout     = new Checkout

    #@cart.render()
    
    @manager = new Manager(@showItem, @editItem, @cart, @checkout)
    
    @append @cart, @showItem, @editItem, @checkout
    
module.exports = Main