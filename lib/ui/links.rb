module UI
  module Links

    def home_link
      link_to 'Home', '/'
    end

    def documents_link
      link_to 'Documents', '/documents'
    end

    def reader_link(doc)
      #'READER_LINK'
      if doc
        link_to 'Reader', "/document/#{doc.id}"
      else
        ''
      end
    end

    def admin_link
      link_to 'Admin', '/admin'
    end

    def settings_link(document)
      link_to "Settings", "/editor/document/options/#{document.id}"
    end

    def export_link(document)
      link_to 'Export', "/editor/export/#{document.id}"
    end

  end

  module Forms

    def search_form

      form_for :search, '/search' do
        label 'Search for:'
        text_field :search, {style: 'inline-display;'}
      end

    end

  end
end