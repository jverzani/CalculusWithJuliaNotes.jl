const b = JXG.JSXGraph.initBoard('jsxgraph', {
    boundingbox: [-0.5,0.3,1.5,-1/4], axis:true
});

var g = function(x) { return x*x*x*x +  10*x*x - 60* x + 100}
var f = function(x) {return 1/Math.sqrt(g(x))};

var type = "right";
var l = 0;
var r = 1;
var rsum = function() {
    return JXG.Math.Numerics.riemannsum(f,n.Value(), type, l, r);
};
var n =   b.create('slider', [[0.1, -0.05],[0.75,-0.05], [2,1,50]],{name:'n',snapWidth:1});




var graph = b.create('functiongraph', [f, l, r]);
var os = b.create('riemannsum',
                  [f,
                   function(){ return n.Value();},
                   type, l, r
                  ],
                  {fillColor:'#ffff00', fillOpacity:0.3});



b.create('text', [0.1,0.25, function(){
    return 'Riemann sum='+(rsum().toFixed(4));
}]);
