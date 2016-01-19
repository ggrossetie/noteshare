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
      current_document_id = document_packet['current_document_id']

      user = current_user(session)

      puts "user: #{user.screen_name}".magenta
      puts "parent_id: #{parent_id}".magenta
      puts "create_mode: #{create_mode  }".magenta

      current_document = DocumentRepository.find current_document_id
      author = UserRepository.find current_document.author_id
      puts "In create_new_section, current_document: #{current_document_id} (#{current_document.title})".red
      puts "--- Author is #{author.screen_name}".red
      # current_root_document = current_document.root_document
      new_document = NSDocument.create(title: title, content: content, author_credentials: author.credentials)
      new_document.acl = current_document.root_document.acl
      # new_document.acl_set_permissions!('rw', '-', '-')
      DocumentRepository.update new_document

      case create_mode
        when 'child'
          new_document.add_to(current_document)
        when 'sibling_before'
          new_document.add_as_sibling_of current_document, :before
        when 'sibling_after'
          new_document.add_as_sibling_of current_document, :after
        else
          puts 'do ntoting'
      end
      redirect_to "/editor/document/#{new_document.id}"


    end
  end
end
