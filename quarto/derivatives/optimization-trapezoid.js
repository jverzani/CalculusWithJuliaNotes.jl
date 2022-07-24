// inscribe trapezoid
var R = 5;
var Delta = 0.5
const b = JXG.JSXGraph.initBoard('jsxgraph', {
    boundingbox: [-R-Delta,R+Delta,R+Delta,-1], axis:true
});

var xax = b.create("segment", [[0,0],[R,0]]);

var P4 = b.create("glider", [R/2,0, xax], {name: "P_4=(r,0)"});



var CL = b.create('point', [function() {return -P4.X()},0], {name:''});
var CR = b.create('point', [function() {return  P4.X()},0], {name:''});
var C = b.create('semicircle', [CL,CR]);

var Crestricted = b.create("functiongraph",
			   [function(x) {
			       r = P4.X();
			       y = Math.sqrt(r*r - x*x);
			       return y;
			   }, 0, function() {return P4.X()}]);

var P3 = b.create("glider", [
    P4.X()/2,
    Math.sqrt(P4.X()*P4.X()*(1 - 1/4)),
    Crestricted], {name:"P_3=(x,y)"});

var P1 = b.create('point', [function() {return -Math.abs(P4.X());},
			    function() {return P4.Y();}], {name:'P_1'});
var P2 = b.create('point', [function() {return -P3.X();},
			    function() {return P3.Y();}], {name:'P_2'});

var poly = b.create('polygon',[P1, P2, P3, P4], { borders:{strokeColor:'black'} });
b.create('text',[-1.5,.25, function(){ return 'Area='+ poly.Area().toFixed(1); }]);
