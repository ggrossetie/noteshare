

module Editor::Controllers::Document
  class UpdateOptions
    include Editor::Action

    expose :document, :active_item


    def propagate(document, hash)
      puts "Propagating ...".red
      if hash['format']
        document.apply_to_tree(:set_format_of_render_option, [hash['format']])
      end
    end

    def update_dict(document, hash)
      hash.each do |key, value|
        puts "key = [#{key}], [#{value}]".red
        if value == ''
          puts "delete key #{value}".cyan
          document.dict.delete(key)
        else
          puts "set: #{key} = #{value}".cyan
          document.dict[key] = value
        end
      end
    end

    def process_hash(document, hash)

      update_dict(document, hash)
      propagate(document, hash) if @mode == 'root'
      if document.is_root_document? && hash['title']
        if hash['title'].length > 0
          document.title = hash['title']
        end
      end
      DocumentRepository.update document

    end


    def update_meta(document, document_packet)

      puts "update_meta says that document_packet: #{document_packet}".red

      options_hash = document_packet['options'].hash_value ":\r"
      puts "options_hash: #{options_hash}"

      new_tags = options_hash['tags'] || ''
      if new_tags != ''
        puts "document_packet['tags'] = #{new_tags}".magenta
        document.tags = new_tags
      end

      if document_packet['options'] != ''
        options = document_packet['options']
        return if options == nil
        hash = options.hash_value(":\n")
        process_hash(document, hash) if hash
      end

      DocumentRepository.update(document)

    end

    def call(params)
      puts "update_options".red
      redirect_if_not_signed_in('editor, document, UpdateOptions')
      @active_item = 'editor'
      #  @mode = if document_packet['mode'] == 'root'

      document_packet = params.env['rack.request.form_hash']['document']
      puts "document packet:\n#{document_packet}".cyan
      @mode = document_packet['mode']

      id =  document_packet['document_id']
      if id
        document = DocumentRepository.find id
        document = document.root_document if @mode == 'root'
        puts "In UpdateOptions, document = #{document.title}".red
        update_meta(document, document_packet)
      end

      redirect_to "/editor/document/#{id}"
    end

  end
end
