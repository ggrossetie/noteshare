
# DocumentRespository provides services for
# persisence and search to NSDocument
class DocumentRepository
  include Lotus::Repository

  # Find all objects with a gvien title
  def self.find_by_title(title)
    query do
      where(title: title)
    end
  end

  # Return one ob4ect (or none0 whidh
  # have a given title
  # Fixme: this could be problmatic because
  # of the possibiility of multiple objects with the same title
  def self.find_one_by_title(title)
    self.find_by_title(title).first
  end

end