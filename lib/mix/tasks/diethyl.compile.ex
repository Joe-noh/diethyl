defmodule Mix.Tasks.Diethyl.Compile do
  @shortdoc "convert the presentation script into an html"

  use Mix.Task

  def run(_) do
    prepare_static_files
    compile_presentation_exs
  end

  defp prepare_static_files do
    Enum.each ["pub", "pub/js", "pub/css"], fn dir ->
      unless File.exists?(dir), do: File.mkdir!(dir)
    end

    generate_base_js
    generate_base_css
    generate_reset_css
    generate_theme_css
  end

  defp compile_presentation_exs do
    # generate pub/index.html
    File.touch("pub/index.html") # TODO
  end

  defp generate_base_js do
    path = "pub/js/base.js"
    unless File.exists?(path), do: File.write!(path, base_js_content)
  end

  defp generate_base_css do
    path = "pub/css/base.css"
    unless File.exists?(path), do: File.write!(path, base_css_content)
  end

  defp generate_reset_css do
    path = "pub/css/reset.css"
    unless File.exists?(path), do: File.write!(path, reset_css_content)
  end

  defp generate_theme_css do
    theme = Application.get_env(:diethyl, :theme, Diethyl.Theme.Plain)

    # TODO
    File.touch("pub/css/theme.css")
    # File.write!("pub/css/theme.css", theme.css_content)
  end

  defp outline_layout do
    """
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="UTF-8">
        <link type="text/css" rel="stylesheet" href="css/reset.css">
        <link type="text/css" rel="stylesheet" href="css/base.css">
        <link rel="stylesheet" href="#{highlight_css_path}">
      </head>
      <body>
        <%= body %>

        <script type="text/javascript" src="#{jquery_path}"></script>
        <script type="text/javascript" src="js/base.js"></script>

        <script type="text/javascript" src="#{highlight_js_path}"></script>
        <script type="text/javascript">hljs.initHighlightingOnLoad();</script>
      </body>
    </html>
    """
  end

  defp highlight_css_path do
    "http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.2/styles/hybrid.min.css"
  end

  defp highlight_js_path do
    Application.get_env(
      :diethyl,
      :highlight_js_path,
      "http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.2/highlight.min.js"
    )
  end

  defp jquery_path do
    "https://code.jquery.com/jquery-2.1.1.min.js"
  end

  def base_js_content do
    """
    $(function () {
      var currentIndex = 0, nextIndex = 0, slides = $("div.slide");

      slides.each(function (i, e) {
        $(e).addClass(i === 0 ? "active" : "inactive");
      });

      $(document).on("keydown", function (event) {
        switch (event.keyCode) {
          case 37: goToPreviousSlide();   break;
          case 39: goToSucceedingSlide(); break;
          default: return;
        }
        event.preventDefault();
      });

      function goToPreviousSlide() {
        nextIndex = currentIndex ? currentIndex-1 : currentIndex;
        switchSlide();
      }

      function goToSucceedingSlide() {
        nextIndex = currentIndex + (currentIndex < slides.length-1 ? 1 : 0);
        switchSlide();
      }

      function switchSlide() {
        deactivate(currentIndex);
        activate(nextIndex);

        currentIndex = nextIndex;
      }

      function activate(index) {
        $(slides[index]).removeClass("inactive").addClass("active");
      }

      function deactivate(index) {
        $(slides[index]).removeClass("active").addClass("inactive");
      }

      $(window).on("load resize", function() {
        var h = parseInt($(window).height());
        $("html").css("font-size", parseInt(h*0.018)+"px");
      });
    });
    """
  end

  def base_css_content do
    """
    body, html, .slide { font-size: 14px; height: 100%; width:  100%; }

    .slide { overflow: hidden; }

    @media screen {
      .slide.active   { visibility: visible; }
      .slide.inactive { visibility: hidden; display: none; }
    }

    @media print { .slide.active, .slide.inactive { visibility: visible; } }
    """
  end

  def reset_css_content do
    """
    html,body,div,span,object,iframe,h1,h2,h3,h4,h5,h6,p,blockquote,pre,abbr,address,cite,
    code,del,dfn,em,img,ins,kbd,q,samp,small,strong,sub,sup,var,b,i,dl,dt,dd,ol,ul,li,
    fieldset,form,label,legend,table,caption,tbody,tfoot,thead,tr,th,td,article,aside,canvas,
    details,figcaption,figure,footer,header,hgroup,menu,nav,section,summary,time,mark,audio,
    video{margin:0;padding:0;border:0;outline:0;font-size:100%;vertical-align:baseline;
    background:transparent}body{line-height:1}article,aside,details,figcaption,figure,footer,
    header,hgroup,menu,nav,section{display:block}nav ul{list-style:none}blockquote,
    q{quotes:none}blockquote:before,blockquote:after,q:before,q:after{content:none}
    a{margin:0;padding:0;font-size:100%;vertical-align:baseline;background:transparent}
    ins{background-color:#ff9;color:#000;text-decoration:none}
    mark{background-color:#ff9;color:#000;font-style:italic;font-weight:bold}
    del{text-decoration:line-through}table{border-collapse:collapse;border-spacing:0}
    abbr[title],dfn[title]{border-bottom:1px dotted;cursor:help}
    hr{display:block;height:1px;border:0;border-top:1px solid #ccc;margin:1em 0;padding:0}
    input,select{vertical-align:middle}
    """
  end
end
