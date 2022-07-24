const b = JXG.JSXGraph.initBoard('jsxgraph', {
    boundingbox: [-6, 1.2, 6,-1.2], axis:true
});

var f = function(x) {return Math.sin(x) / x;};
var graph = b.create("functiongraph", [f, -6, 6])
var seg = b.create("line", [[-6,0], [6,0]], {fixed:true});

var X = b.create("glider", [2, 0, seg], {name:"x", size:4});
var P = b.create("point", [function() {return X.X()}, function() {return f(X.X())}], {name:""});
var Q = b.create("point", [0, function() {return P.Y();}], {name:"f(x)"});

var segup = b.create("segment", [P,X], {dash:2});
var segover = b.create("segment", [P, [0, function() {return P.Y()}]], {dash:2});


txt = b.create('text', [2, 1, function() {
    return "x = " + X.X().toFixed(4) + ", f(x) = " + P.Y().toFixed(4);
}]);
