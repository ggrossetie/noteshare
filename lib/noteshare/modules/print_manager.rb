class PrintManager

  require_relative '../modules/css_data'
  include CSSData


  CSS_FOR_PRINTING = <<EOF
@media print{@page{margin:1.25cm 1.75cm}
body{ font-size: 0.9em; margin-left:0; margin-left:0;}
h1,h2,h3,#toctitle,.sidebarblock>.content>.title,h4,h5,h6{font-weight:300;font-style:normal;color:#000}
h1 small,h2 small,h3 small,#toctitle small,.sidebarblock>.content>.title small,h4 small,h5 small,h6 small{color:#000}
EOF

  MARGINS= <<EOF
  body {
    margin-left:6em;
    margin-right:6em;
}
EOF


  def initialize(document)

    @document = document
    @mathjax = CSSData.mathjax

  end

  def stylesheet(css)
    "\n<style>\n#{css}\n</style>\n"
  end

  def output_title
     @document.title.normalize
  end

  def object_name
    return output_title + '.html'
  end

  def head
    "<!doctype html>\n<html lang='en'>\n<head>\n<meta charset='utf-8'>"
  end

  def process_document(option)

    if option == 'section'
      ContentManager.new(@document).update_content_lazily
      html = @document.rendered_content
    else
      @document = @document.root_document
      ContentManager.new(@document).compile_with_render_lazily
      html = @document.compiled_and_rendered_content
    end

    css = ''
    css << stylesheet(asciidoctor_css)
    css << stylesheet(asciidoctor2_css)
    css << stylesheet("#_dummyoutersection { display: none; }")
    css << stylesheet(CSS_FOR_PRINTING)
    css << stylesheet(MARGINS)
    css << @mathjax
    html = "#{head}\n#{css}\n</head>\n<body>\n#{html}\n</body>\n\n"
    AWS.put_string(html, object_name, folder='print')

  end


  def get_print_string
    AWS.get_string(object_name, folder='print')
  end

  def document_url
    "http://s3.amazonaws.com/vschool/print/#{object_name}"
  end


  def asciidoctor_css
      CSSData.asciidoctor_css
  end

  def asciidoctor2_css
    CSSData.asciidoctor2_css
  end





end