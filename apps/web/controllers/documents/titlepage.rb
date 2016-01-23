require_relative '../../../../lib/modules/analytics'

module Web::Controllers::Documents
  class Titlepage
    include Web::Action
    include Analytics

    expose :root_document, :document, :toc, :blurb, :image_url
    expose :active_item, :active_item2

    def call(params)
      puts "controller: Titlepage".red

      @active_item = 'reader'
      @active_item2 = 'titlepage'

      document = DocumentRepository.find(params['id'])
      handle_nil_document(document, params['id'])
      session[:current_document_id] = document.id

      @root_document = document.root_document
      @root_document.compile_with_render({numbered: true, format: 'adoc-latex'})
      @root_document.compiled_content = @root_document.compile

      Analytics.record_document_view(current_user(session), @root_document)

      @blurb = @root_document.dict['blurb'] || 'blurb'

      titlepage_image_id =  @root_document.dict['titlepage_image'] || 727
      titlepage_image = ImageRepository.find  titlepage_image_id
      @image_url = titlepage_image.url2


    end
  end
end
