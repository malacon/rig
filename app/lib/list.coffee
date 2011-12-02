Spine ?= require("spine")
$      = Spine.$

class Spine.List extends Spine.Controller
  events:
    "click .item": "click"
    
  selectFirst: false
    
  constructor: ->
    super
    @bind("change", @change)
    
  template: -> arguments[0]
  
  change: (item) =>
    return unless item
    @current = item
    $(".itemsList").children().removeClass("active")
    #take out accordion people
    
    #$(".itemsList").children().forItem(@current).addClass("active")
  
  removeActive: =>
    @children().removeClass("active")
    
  render: (items) ->
    @items = items if items
    @html @template(@items)
    @change @current
    if @selectFirst
      unless @children(".active").length
        @children(":first").click()
        
  children: (sel) ->
    @el.children(sel)
    
  click: (e) ->
    item = $(e.target).item()
    @trigger("change", item)
    
module?.exports = Spine.List