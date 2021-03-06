###
    store.coffee

    Copyright (c) 2013-2017, Reactive Sets

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

# ----------------------------------------------------------------------------------------------
# rs test utils
# -------------

utils               = require( './tests_utils.js' ) unless this.expect

expect              = this.expect              || utils.expect
check               = this.check               || utils.check
Expected_Operations = this.Expected_Operations || utils.Expected_Operations
rs                  = this.rs                  || utils.rs
RS                  = rs.RS
Store               = RS.Store

# ----------------------------------------------------------------------------------------------
# store test suite
# ----------------

describe 'store():', ->
  input    = null
  store    = null
  output   = null
  set      = null
  expected = Expected_Operations()
  
  it 'store should be a Store', ->
    input = rs.pass_through()
    store = rs.store()
    set   = store.set()
    
    output = store._output
    
    expect( store ).to.be.a Store
  
  it 'should fetch one undefined (add) operation with no values', ->
    output._fetch ( values, no_more, operation ) ->
      expect( [ values, no_more, operation ] ).to.be.eql [ [], true, undefined ]
  
  it 'should allow to connect an input', ->
    input = rs.pass_through()
    input.through( store )
  
  it 'should now fetch one add operation with no values', ->
    output._fetch ( values, no_more, operation ) ->
      expect( [ values, no_more, operation ] ).to.be.eql [ [], true, 0 ]
  
  it 'downstream set should have no values', ->
    set._fetch_all ( values ) ->
      expect( values ).to.be.eql []
  
  it 'should allow to add a value', ->
    input._add [ { id : 1 } ]
    expected.add 0, [ { id : 1 } ]
  
  it 'should allow to fetch one add operation with the correct values', ->
    output._fetch expected.receiver 1
  
  it 'downstream set should hold the same value', ->
    set._fetch_all ( values ) ->
      expect( values ).to.be.eql [ { id : 1 } ]
  
  it 'should allow to remove the same value', ->
    input._remove [ { id : 1 } ]
    expected.add 1, [ { id : 1 } ]
  
  it 'should allow to fetch two operations', ->
    output._fetch expected.receiver 2
  
  it 'downstream set should hold no values', ->
    set._fetch_all ( values ) ->
      expect( values ).to.be.eql []
  
  it 'should allow to add a value and update it', ->
    input._add [ { id : 1 } ]
    expected.add 0, [ { id : 1 } ]
    
    input._update [ [ { id : 1 }, { id: 2 } ] ]
    expected.add 2, [ [ { id : 1 }, { id: 2 } ] ]
  
  it 'should allow to fetch 4 operations', ->
    output._fetch expected.receiver 4
  
  it 'downstream set should hold one updated value', ->
    set._fetch_all ( values ) ->
      expect( values ).to.be.eql [ { id: 2 } ]
