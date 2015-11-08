module Editor::Controllers::Document
  class JsonUpdate
    include Editor::Action

    def call(params)
      puts "JSON update firing".red
      id = params['id'].to_i
      @document = DocumentRepository.find(id)
      @document.content_dirty = true
      @document.update_content params['source']
      @document.synchronize_title
      self.body = @document.rendered_content
    end



    private
    def verify_csrf_token?
      false
    end


  end
end
