module NSDocument::Asciidoc

  def prepare_content(document, new_content)

    if document
      prefix = "="*(document.level + 2)
    else
      prefix = "== "
    end

    if document
      new_title = document.title
    else
      new_title = 'TITLE'
    end

    header = "#{prefix} #{new_title}"

    if new_content
      prepared_content = "#{header}\n\n#{new_content}"
    else
      prepared_content = header
    end

    prepared_content
  end

  # Extract title from content. Thus, if
  # the content is
  #
  # Ho ho ho!
  # === Mr. Klaus and his laugh
  # blah, blah,
  #
  # Then #title_from_content returns
  # the string 'Mr. Klaus and his lauggh'
  def title_from_content
    m = self.content.match /^=* .*$/
    if m
     m[0].gsub(/=*=/, '').strip
    end
  end

  # Make document.title agree with what
  # is said in the text.
  def synchronize_title
    old_title = self.title
    new_title = title_from_content
    if new_title and old_title != new_title
      self.title = new_title
      DocumentRepository.update self
    end
  end


end