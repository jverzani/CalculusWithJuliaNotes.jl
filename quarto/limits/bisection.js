var l = -1.5;
var r = 1.75;
var N = 8;

const b = JXG.JSXGraph.initBoard('jsxgraph', {
    boundingbox: [l, 6.0, r,-2.0], axis:true
});

var f = function(x) {return Math.pow(x,5) - x - 1};

var graph = b.create('functiongraph', [f, l, r]);

slider = b.create('slider', [[0.25, 1], [1.0, 1], [0,0,N-1]],
		  {snapWidth:1,
		   suffixLabel:"n = "});

var intervals = [[0,1.5]];

for (i = 1; i < N; i++) {
    var old = intervals[i-1];
    var ai = old[0];
    var bi = old[1];
    var ci = (ai + bi)/2;
    var fa = f(ai);
    var fb = f(bi);
    var fc = f(ci);
    if (fc == 0) {
     	var newint = [ci, ci];
    } else if (fa * fc < 0) {
     	var newint = [ai, ci];
    } else {
     	var newint = [ci, bi];
    }
    intervals.push(newint);
};

b.create('functiongraph', [f,
			   function() {
			       var n = slider.Value();
			       return intervals[n][0];
			   },
			   function() {
			       var n = slider.Value();
			       return intervals[n][1];
			   }
			  ], {strokeWidth:5});

var seg = b.create("segment", [function() {
    var n = slider.Value();
    var ai = intervals[n][0];
    return [ai, 0];
},
			       function() {
    var n = slider.Value();
    var bi = intervals[n][1];
    return [bi, 0];
			       }], {strokeWidth: 5});

b.create("point", [function() {
    var n = slider.Value();
    var ai = intervals[n][0]
    return ai;
}, 0], {name:"a_n"});

b.create("point", [function() {
    var n = slider.Value();
    var bi = intervals[n][1]
    return bi;
}, 0], {name: "b_n"});
