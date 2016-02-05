module Node::Controllers::Public
  class Show
    include Node::Action

    expose :node, :active_item, :layout_option, :blurb_text

    def call(params)
      @active_item = 'documents'
      @node = NSNodeRepository.find params[:id]
      return if @node == nil
      # ^^ Fixme: better, go to error page
      cu = current_user(session)
      if cu
        cu.set_current_node(cu, @node)
      end
      if @node.dict['layout'] == 'simple_sidebar'
        @layout_option = :sidebar
      else
        @layout_option = :titlepage
      end

      node.meta = {} if node.meta == nil
      @blurb_text =  @node.meta['long_blurb'] || ''

    end

  end
end
