<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">


<link
  href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css"
  rel="stylesheet">

    
<style>
.julia {display: block; font-family: "Source Code Pro";
        color:#0033CC;
        }
.hljl {font-family: "Source Code Pro";
        color:#0033CC;
        }
body { padding-top: 60px; }
h5:before {content:"\2746\ ";}
h6:before {content:"\2742\ ";}
pre {display: block;}
th, td {
  padding: 15px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}
tr:hover {background-color: #f5f5f5;}

.admonition-title:before {content:"\2746\ ";}
.admonition-title { color:#0033CC}

</style>


<!-- .julia:before {content: "julia> "} -->

<style>{{{:style}}}</style>


<script src="https://code.jquery.com/jquery.js"></script>


<script  type="text/x-mathjax-config">
MathJax.Hub.Config({
  tex2jax: {
    inlineMath: [ ["\$","\$"], ["\\(","\\)"]]
  },
  displayAlign: "left",
  displayIndent: "5%"
});
</script>
<!-- not TeX-AMS-MML_HTMLorMML-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML" async></script>
</script>


<script>
window.PlotlyConfig = {MathJaxConfig: 'local'}
</script>
<script src="https://cdn.plot.ly/plotly-latest.min.js"></script>

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
    $("#page_dropdown").append("<li><a href='#" + id + "'>" + nm + "</a></li>");
  });
    $('[data-toggle="popover"]').popover();
});
</script>

</head>


<body data-spy="scroll" >

<nav class="navbar navbar-default  navbar-fixed-top">
  <div class="container-fluid">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      {{#:BRAND_HREF}}<a class="navbar-brand" href="{{{:BRAND_HREF}}}">{{:BRAND_NAME}}</a>{{/:BRAND_HREF}}
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav">
        <li><a href="#" id="page_title"></a></li>
      </ul>
      <ul class="nav navbar-nav navbar-right">
         <li class="dropdown">
           <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">
           Jump to... <span class="caret"></span></a>
          <ul class="dropdown-menu" role="menu" id="page_dropdown"></ul>
        </li>
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>

<header>
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
</script>


</body>
</html>
