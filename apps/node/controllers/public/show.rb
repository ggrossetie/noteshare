module Node::Controllers::Public
  class Show
    include Node::Action

    expose :node, :user,:active_item, :layout_option, :blurb_text, :rendered_text
    expose :sidebar_text, :rendered_sidebar_text, :presenter, :show_overlay

    def call(params)
      @active_item = 'documents'
      @node = NSNodeRepository.find params[:id]
      @user = current_user(session)
      if @user
        @show_overlay =  (@node.name == 'start') && (@user.dict2['show_overlay'] == 'yes')
        @show_overlay = @show_overlay &&  (@user.dict2['show_overlay_this_session'] == 'yes') # && (@user.id == 9)
        puts "controller Node, Public, Show, @user = #{@user.full_name}".red
      else
        @show_overlay = false
        puts "controller Node, Public, Show, @user = NIL".red
      end

      return if @node == nil
      # ^^ Fixme: better, go to error page
      cu = current_user(session)
      if cu
        cu.set_current_node(cu, @node)
      end

      NodeActivityManager.new(node: @node, user: @user).record
      @presenter = NodePresenter.new(@node, @user)

      puts "layout = #{@node.dict['layout']}"

      case @node.dict['layout']
        when 'simple_sidebar'
          @layout_option = :sidebar
        when 'titlepage'
          @layout_option = :titlepage
        when 'view_source'
          @layout_option = :view_source
        else
          @layout_option = :titlepage
      end

      @node.meta = {} if @node.meta == nil

      @blurb_text =  @node.meta['long_blurb'] || ''
      @rendered_blurb = @node.meta['rendered-blurb'] || ''

      @sidebar_text =  @node.meta['sidebar_text'] || ''
      @rendered_sidebar_text = @node.meta['rendered_sidebar_text'] || ''

      NSNodeRepository.update @node

    end

  end
end
