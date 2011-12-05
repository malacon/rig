Spine = require('spine')

class Card extends Spine.Model
  @configure 'Card', 'name', 'title', 'email', 'direct', 'cell'
  
module.exports = Card