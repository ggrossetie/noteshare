module Node::Controllers::Admin
  class Create
    include Node::Action

    def call(params)
      redirect_if_not_signed_in('editor, Admin,  Create')
      node_info = params['new_node']

      name = node_info['name']
      owner_id = node_info['owner_id']
      type = node_info['type']
      tags = node_info['tags']

      puts "name: #{name}".red
      puts "owner_id: #{owner_id}".red
      puts "type: #{type}".red
      puts "tags: #{tags}".red

      NSNode.create(name, owner_id, type, tags)

      redirect_to  '/node/admin/'
    end

  end
end
