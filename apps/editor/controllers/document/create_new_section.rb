module Editor::Controllers::Document
  class CreateNewSection
    include Editor::Action

    expose :active_item

    def call(params)
      @active_item = 'editor'
      puts 'controller: CreateNewSection'.red
      puts "(2) query: #{request.query_string}".cyan

      document_packet = params['document']
      title = document_packet['title']
      content = document_packet['content']
      parent_id = document_packet['parent_id']
      create_mode = document_packet['create_mode']

      user = current_user(session)

      puts "user: #{user.screen_name}".magenta
      puts "parent_id: #{parent_id}".magenta
      puts "create_mode: #{create_mode  }".magenta

      author = UserRepository.find user.id
      current_document = DocumentRepository.find session[:current_document_id]
      # current_root_document = current_document.root_document
      new_document = NSDocument.create(title: title, content: content, author_credentials: author.credentials)

      new_document.add_to(current_document)



      redirect_to "/editor/document/#{new_document.id}"

    end
  end
end
