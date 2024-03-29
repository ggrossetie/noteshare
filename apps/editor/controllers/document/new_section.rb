module Editor::Controllers::Document
  class NewSection
    include Editor::Action

    expose :document, :active_item, :create_mode

    def call(params)
      redirect_if_not_signed_in('editor, document, NewSection')
      @active_item = 'editor'
      @create_mode = request.query_string
      @document = DocumentRepository.find params['id']
    end

  end
end
