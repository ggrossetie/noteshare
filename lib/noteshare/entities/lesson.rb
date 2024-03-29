

### INTERFACE ###
# to_document
class Lesson
  include Lotus::Entity
  attributes :id, :title, :content, :author_id, :course_id, :created_at, :updated_at,
             :tags, :area, :sequence, :summary, :aside, :image_path1, :image_path2, :content_type

  ### INTERFACE ###

  def to_document(screen_name)
    user = UserRepository.find_one_by_screen_name(screen_name)
    puts "  -- AA".magenta
    return if user == nil
    puts "  -- BB".magenta
    doc = NSDocument.create(title: self.title, author_credentials: user.credentials)
    puts "  -- CC".magenta
    doc.author_id = user.id
    puts "  -- aa".magenta
    doc.author = user.full_name
    puts "  -- bb".magenta
    doc.tags = self.tags
    doc.area = self.area
    doc.created_at = self.created_at
    doc.updated_at =  self.updated_at
    doc.content = self.content
    doc.acl_set_permissions!('rw', 'r', '-')

    puts "  -- DD".magenta
    handle_pdf(doc) if self.content_type == 'pdf'
    puts "  -- EE".magenta
    DocumentRepository.update(doc)
    puts "  -- FF".magenta
    return doc
  end

  ### BLACK BOX ###

  def handle_pdf(document)
    document.dict['pdf:image_id'] = self.image_path1
    image = ImageRepository.find self.image_path1
    return if image == nil
    document.dict['pdf:url'] = image.url2
    document.content = self.content || ''
    document.content << "\n\n#{image.url2}[PDF document]\n\n"
    document.content << "++++\n"
    document.content << "<iframe src='#{image.url2}' width=100% height=1200 ></iframe>\n"
    document.content << "++++\n"
  end

end

