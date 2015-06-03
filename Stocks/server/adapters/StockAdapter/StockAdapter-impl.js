/*
 *  Licensed Materials - Property of IBM
 *  5725-I43 (C) Copyright IBM Corp. 2011, 2013. All Rights Reserved.
 *  US Government Users Restricted Rights - Use, duplication or
 *  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

 var data = [{symbol:"IBM",name:"International Business Machines",price:151.75,change:0,percentChange:0,open:151.16,low:0,high:0,low52:170.49,high52:172.39,eps:15.75,shares:"984.73M"},
			 {symbol:"AAPL",name:"Apple Inc",price:131.82,change:0,percentChange:0,open:130.36,low:0,high:0,low52:87.95,high52:134.54,eps:8.09,shares:"5.76B"}, 
			 {symbol:"MSFT",name:"Microsoft Corporation",price:47.29,change:0,percentChange:0,open:46.82,low:0,high:0,low52:39.81,high52:50.04,eps:2.41,shares:"8.09B"}, 
			 {symbol:"GOOG",name:"Google Inc",price:536.28,change:0,percentChange:0,open:532.8,low:0,high:0,low52:487.56,high52:599.65,eps:20.15,shares:"342.63M"}, 
			 {symbol:"AMZN",name:"Amazon.com, Inc",price:429.34,change:0,percentChange:0,open:427.45,low:0,high:0,low52:284.0,high52:452.65,eps:-0.88,shares:"465.68M"} ];
 

 
function getList() {
	
	simulateData();
	
	var items = [];
	var trimmedProperties = ["symbol","price","change"];
	
	for (var i=0; i<data.length; i++) {
		var item = {};
		for (var j in trimmedProperties) {
			var prop = trimmedProperties[j];
			item[prop] = data[i][prop];
		}
		items.push(item);
	}
	
	return {
		"stocks":items
	};
}

function getDetail(symbol) {
	
	for (var i=0; i<data.length; i++) {
		if (data[i].symbol == symbol) {
			return data[i];
		}
	}
	return null;
}




 
function simulateData() {
	
	var MAX_PRICE_CHANGE = 2.5; 
	 
	for (var i=0; i<data.length; i++) {
		var stock = data[i];
		
		var posNeg = (Math.round(Math.random() * 1000)) % 2;
		var change = MAX_PRICE_CHANGE * Math.random();
		
		if (posNeg > 0) {
			change = -change;
		}
		
		stock.price += change;
		stock.change = stock.price - stock.open;
		
		if (stock.low == 0) {
			stock.low = stock.price - (MAX_PRICE_CHANGE * Math.random());
			stock.high = stock.price + (MAX_PRICE_CHANGE * Math.random());
		}
		
		if( stock.price <= stock.low ) {
			stock.low = stock.price;
		}
		if( stock.price >= stock.high ) {
			stock.high = stock.price;
		}
		
		
		if( stock.price <= stock.low52 ) {
			stock.low52 = stock.price;
		}
		if( stock.price >= stock.high52 ) {
			stock.high52 = stock.price;
		}
	}  
}
