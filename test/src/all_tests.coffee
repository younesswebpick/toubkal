###
    all_tests.coffee
    
    Copyright (C) 2013, 2015, Reactive Sets
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.
    
    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
###

# -------------------------------------------------------------------------------
# require modules tests
# ---------------------

# utils
require './clone.js'
require './value_equals.js'
require './lazy_logger.js'
require './query.js'
require './event_emitter.js'
require './transactions.js'
require './extend.js'
require './subclass.js'
require './code.js'

# core
require './RS.js'
require './pipelet.js'
require './set.js'
require './filter.js'
require './order.js'
require './aggregate.js'
require './join.js'

require './json.js'
require './transforms.js'
require './file.js'
require './html_parse.js'
require './html_serialize.js'

require './server.js'

try
  require.resolve 'zombie'
  require './ui.js'
