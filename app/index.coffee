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

require('lib/setup')

Spine = require('spine')
Shop = require('controllers/shop')

class App extends Spine.Controller
  events:
    'click .help': 'helpDialog'  
    
  constructor: ->
    super
    @html require('views/layout')
    myLayout = $('body').layout({
      north__size:    75,
      west__size:     300,
      west__onresize:   $.layout.callbacks.resizePaneAccordions
    })
        
    @shop = new Shop

  helpDialog: ->
    #alert 'You need help?'
    
    $("#dialog").dialog({ autoOpen: true, title: 'Cart Help' });
    #$( "#dialog" ).dialog();

module.exports = App
    