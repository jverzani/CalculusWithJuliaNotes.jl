// newton's method

const b = JXG.JSXGraph.initBoard('jsxgraph', {
    boundingbox: [-3,5,3,-5], axis:true
});


var f = function(x) {return x*x*x*x*x - x - 1};
var fp = function(x) { return 4*x*x*x*x - 1};
var x0 = 0.85;

var nm = function(x) { return x - f(x)/fp(x);};

var l = b.create('point', [-1.5,0], {name:'', size:0});
var r = b.create('point', [1.5,0], {name:'', size:0});
var xaxis = b.create('line', [l,r])


var P0 = b.create('glider', [x0,0,xaxis], {name:'x0'});
var P0a = b.create('point', [function() {return P0.X();},
			     function() {return f(P0.X());}], {name:''});

var P1 = b.create('point', [function() {return nm(P0.X());},
			    0], {name:''});
var P1a = b.create('point', [function() {return P1.X();},
			     function() {return f(P1.X());}], {name:''});

var P2 = b.create('point', [function() {return nm(P1.X());},
			    0], {name:''});
var P2a = b.create('point', [function() {return P2.X();},
			     function() {return f(P2.X());}], {name:''});

var P3 = b.create('point', [function() {return nm(P2.X());},
			    0], {name:''});
var P3a = b.create('point', [function() {return P3.X();},
			     function() {return f(P3.X());}], {name:''});

var P4 = b.create('point', [function() {return nm(P3.X());},
			    0], {name:''});
var P4a = b.create('point', [function() {return P4.X();},
			     function() {return f(P4.X());}], {name:''});
var P5 = b.create('point', [function() {return nm(P4.X());},
			    0], {name:'x5', strokeColor:'black'});





P0a.setAttribute({fixed:true});
P1.setAttribute({fixed:true});
P1a.setAttribute({fixed:true});
P2.setAttribute({fixed:true});
P2a.setAttribute({fixed:true});
P3.setAttribute({fixed:true});
P3a.setAttribute({fixed:true});
P4.setAttribute({fixed:true});
P4a.setAttribute({fixed:true});
P5.setAttribute({fixed:true});

var sc = '#000000';
b.create('segment', [P0,P0a], {strokeColor:sc, strokeWidth:1});
b.create('segment', [P0a, P1], {strokeColor:sc, strokeWidth:1});
b.create('segment', [P1,P1a], {strokeColor:sc, strokeWidth:1});
b.create('segment', [P1a, P2], {strokeColor:sc, strokeWidth:1});
b.create('segment', [P2,P2a], {strokeColor:sc, strokeWidth:1});
b.create('segment', [P2a, P3], {strokeColor:sc, strokeWidth:1});
b.create('segment', [P3,P3a], {strokeColor:sc, strokeWidth:1});
b.create('segment', [P3a, P4], {strokeColor:sc, strokeWidth:1});
b.create('segment', [P4,P4a], {strokeColor:sc, strokeWidth:1});
b.create('segment', [P4a, P5], {strokeColor:sc, strokeWidth:1});

b.create('functiongraph', [f, -1.5, 1.5])
