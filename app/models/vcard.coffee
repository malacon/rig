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

class Vcard extends Spine.Model
  @configure 'Vcard', 'fname', 'lname', 'title', 'email', 'address', 'city', 'state', 'zip', 'country', 'telDirect', 'telCompany', 'telCell', 'telFax', 'website', 'company'

  getCard: ->
    card  = "BEGIN:VCARD\n" # BEGIN:VCARD
    card += "VERSION:2.1\n"  # VERSION:2.1
    card += "N:" + @.lname + ";" + @.fname + ";;;\n" # N:Baker;Craig;;;
    card += "ADR;INTL;PARCEL;WORK:;;" + @.address + ";" + @.city + ";" + @.state + ";" + @.zip + ";" + @.country + "\n" # ADR;INTL;PARCEL;WORK;;;1 S St.;Baton Rouge;LA;70909;USA
    card += "EMAIL;INTERNET:" + @.email + "\n" # EMAIL;INTERNET:craig@mail.com
    card += "ORG;" + @.company + "\n" # ORG:RigNet
    card += "TEL;WORK:" + @.telCompany + "\n" # TEL;WORK:5043332222
    card += "TEL;WORK;FAX:" + @.telFax + "\n" # TEL;WORK;FAX:5043332222
    card += "TEL;WORK;CELL:" + @.telCell + "\n" # TEL;WORK;CELL:5043332222
    card += "TEL;WORK;DIRECT:" + @.telDirect + "\n" # TEL;WORK;DIRECT:5043332222
    card += "TITLE:" + @.title + "\n" # TITLE:Programmer
    card += "URL;WORK:" + @.website + "\n" # URL;WORK:rig.net
    card += "END:VCARD\n" # END:VCARD

  
module.exports = Vcard