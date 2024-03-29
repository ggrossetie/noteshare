module Node::Controllers::Admin
  class List
    include Node::Action

    expose :nodes, :active_item, :documents

    def call(paramm)
      redirect_if_not_signed_in('image, admin,  List')
      @active_item = 'admin'
      puts "call: controller Node, Admin, List".red
      @nodes = NSNodeRepository.public
      @documents = DocumentRepository.root_documents.sort_by{|document| document.title}
      puts "exit controller node, admin, list".red
    end

  end
end
