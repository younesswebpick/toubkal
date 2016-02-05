/*  data.js

    The MIT License (MIT)
    
    Copyright (c) 2013-2016, Reactive Sets
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.    
*/
module.exports = function processor( database, clients, options ) {
  'use strict';
  
  var rs = database.namespace()
    , scope = {} // a local scope, automatically discarded when processor is removed
  ;
  
  database
    .flow( 'teaser/sales' )
    
    .set_output( 'from_database', scope ) // keep track of connection to database for removal
    
    .alter( function( sale ) {
      sale.year = parseInt( sale.date.substr( 0, 4 ), 10 );
    }, { name: 'alter teaser/sales_year' } )
    
    //.trace( 'teaser/sales_year' )
    
    .set_flow( 'teaser/sales_year' )
    
    .set_output( 'to_clients', scope ) // keep track of connection to clients for removal
    
    .through( clients, options )
  ;
  
  processor.remove = function( options ) {
    rs
      .output( 'from_database', scope )
      ._remove_source( database, options, function() { // will remove data to clients
        // Disconnected from database, clients updated with removed data
        
        rs.output( 'to_clients', scope )
          ._remove_destination( clients, options ); // fetching will return nothing because we are disconnected from database
        ;
      } )
    ;
  };
}; // processor()
