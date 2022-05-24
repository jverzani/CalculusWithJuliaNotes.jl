<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-eOJMYsd53ii+scO/bJGFsiCZc+5NDVN2yr8+0RDqr0Ql0h+rP48ckxlpbzKgwra6" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.1/dist/umd/popper.min.js" integrity="sha384-SR1sx49pcuLnqZUnnPwx6FCym0wLsk5JZuNx2bPPENzswTNFaQU1RDvt3wT4gWFG" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta3/dist/js/bootstrap.min.js" integrity="sha384-j0CNLUeiqtyaRmlzUHCPZ+Gy5fQu0dQ6eZ/xAww941Ai1SxSY+0EQqNXNE6DZiVc" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css">


<style>
.julia {display: block; font-family: "Source Code Pro";
        color:#0033CC;
        }
.hljl {font-family: "Source Code Pro";
        color:#0033CC;
      }
.output, .julia-error {
    border-left: thick solid #ff0000;
    padding: 5px;
    padding-left: 10px;
    margin-bottom: 15px;
    background-color: #f5f5f5;
}
body { padding-top: 60px;
}
.output {color:#0033CC;}
h5:before {content:"\2746\ ";}
h6:before {content:"\2742\ ";}
pre {display: block;}
th, td {
  padding: 5px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}
tr:hover {background-color: #f5f5f5;}

.admonition-title:before {content:"\2746\ ";}
.admonition-title { color:#0033CC}

main > .container {
  padding: 60px 15px 0;
}

blockquote {
  background: #f9f9f9;
  border-left: 10px solid #ccc;
  margin: 1.5em 10px;
  padding: 0.5em 10px;
  quotes: "\201C""\201D""\2018""\2019";
}
</style>

<!--   padding: 0.5em 10px; .julia:before {content: "julia> "} -->

<style>{{{:style}}}</style>

<script src="https://code.jquery.com/jquery.js"></script>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.13.3/dist/katex.min.css" integrity="sha384-ThssJ7YtjywV52Gj4JE/1SQEDoMEckXyhkFVwaf4nDSm5OBlXeedVYjuuUd0Yua+" crossorigin="anonymous">

    <!-- The loading of KaTeX is deferred to speed up page rendering -->
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.13.3/dist/katex.min.js" integrity="sha384-Bi8OWqMXO1ta+a4EPkZv7bYGIes7C3krGSZoTGNTAnAn5eYQc7IIXrJ/7ck1drAi" crossorigin="anonymous"></script>

    <!-- To automatically render math in text elements, include the auto-render extension: -->
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.13.3/dist/contrib/auto-render.min.js" integrity="sha384-vZTG03m+2yp6N6BNi5iM4rW4oIwk5DfcNdFfxkk9ZWpDriOkXX8voJBFrAO7MpVl" crossorigin="anonymous"
        onload="renderMathInElement(document.body);"></script>
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.13.3/dist/contrib/auto-render.min.js" integrity="sha384-vZTG03m+2yp6N6BNi5iM4rW4oIwk5DfcNdFfxkk9ZWpDriOkXX8voJBFrAO7MpVl" crossorigin="anonymous"
	onload="renderMathInElement(document.body);"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        renderMathInElement(document.body, {
          // customised options
          // • auto-render specific keys, e.g.:
          delimiters: [
              {left: '$$', right: '$$', display: true},
              {left: '$', right: '$', display: false},
              {left: '\\(', right: '\\)', display: false},
              {left: '\\[', right: '\\]', display: true},
	      {left: "\\begin{equation}", right: "\\end{equation}", display: true},
              {left: "\\begin{align}", right: "\\end{align}", display: true},
	      {left: "\\begin{alignat}", right: "\\end{alignat}", display: true},
	      {left: "\\begin{gather}", right: "\\end{gather}", display: true}
          ],
          // • rendering keys, e.g.:
          throwOnError : false
        });
    });
</script>
<script>
window.PlotlyConfig = {MathJaxConfig: 'local'}
</script>
<script src="https://cdn.plot.ly/plotly-latest.min.js"></script>

<!-- highlight Julia Code -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/10.7.1/styles/default.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/10.7.1/highlight.min.js"></script>
<!-- and it's easy to individually load additional languages -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/10.7.1/languages/julia.min.js"></script>

<script type="text/javascript">
$( document ).ready(function() {
  $("h1").each(function(index) {
       var title = $( this ).text()
       $("#page_title").html("<strong>" + title + "</strong>");
       document.title = title
  });
  $( "h2" ).each(function( index ) {
    var nm =  $( this ).text();
    var id = $.trim(nm).replace(/ /g,'');
    this.id = id
    $("#page_dropdown").append("<li><a class='dropdown-item' href='#" + id + "'>" + nm + "</a></li>");
  });
    $('[data-toggle="popover"]').popover();
});
</script>

<link rel="shortcut icon" href="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" type="image/x-icon" />

</head>


<body data-spy="scroll" >

  <header class="navbar navbar-expand-md navbar-dark bd-navbar">
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top navbar-nav">
    <div class="container-fluid">
      <a class="navbar-brand" href="https://juliahub.com/docs/CalculusWithJulia/">
      <img src="data:image/gif;base64,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"/>
      Calculus with Julia</a>

    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <ul class="nav navbar-nav navbar-right">
      <li class="nav-item dropdown dropstart">
	<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown"
	   role="button" data-bs-toggle="dropdown" aria-expanded="false">
            Jump to...
          </a>

        <ul class="dropdown-menu" aria-labelledby="navbarDropdown" role="menu" id="page_dropdown"></ul>
      </li>
    </ul>

    </div>
  </div>
</nav>

</header>
          <div class="title">
            {{#:title}}<h1 class="title">{{:title}}</h1>{{/:title}}
            {{#:author}}<h5>{{{:author}}}</h5>{{/:author}}
            {{#:date}}<h5>{{{:date}}}</h5>{{/:date}}
          </div>



<div class="container-fluid">
  <div class="span10 offset1">
    {{{:body}}}
  </div>
</div>

<script>
  document.querySelectorAll('pre.hljl').forEach(el => {   // first, find all the div.code blocks
  hljs.highlightElement(el);                              // then highlight each
  });

  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
  return new bootstrap.Tooltip(tooltipTriggerEl)
})
  var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'))
  var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
    return new bootstrap.Popover(popoverTriggerEl)
  });
</script>


</body>
</html>
