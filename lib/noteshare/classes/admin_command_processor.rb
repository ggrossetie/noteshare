
# An AdminCommandProcessor parse
# and executes comands of the form
#    command a:b c:d etc
#    e.g., create-command token:foo123 verb:add_group_and_document group:linearstudent doc:1701
class AdminCommandProcessor


  def initialize(hash)
    @input = hash[:input]
    @user = hash[:user]
    @tokens = @input.split(' ').map{ |token| token.strip }
    @command = @tokens.shift
    @tokens = @tokens.map { |token| token.split(':') }
    @response = 'ok'
  end

  def execute
    parse_command
    self.send(@command_signature) if command_valid?
    @response = @error if @error
    @response
  end

  def command_valid?
    signatures = ['test']
    signatures << 'use_token'
    signatures << 'add_doc_to_group_token_days'
    signatures << 'add_doc_to_group'
    signatures << 'add_group_token_days'
    signatures << 'add_doc_token_days'
    signatures << 'add_doc_and_group_token_days'
    if signatures.include? @command_signature
      true
    else
      @error = 'command not recognized'
      false
    end
  end


  def process_token
    if @acp_token.count == 2
      name, value = @acp_token
      instance_variable_set("@#{name}", value)
    elsif @acp_token.count == 3
      name, value, modifier = @acp_token
      instance_variable_set("@#{name}", value)
      instance_variable_set("@#{name}_modifier", modifier)
    else
      @error = 'incorrect number of modifierss'
    end
    @command_signature = "#{@command_signature}_#{name}"
    @error
  end

  def parse_command
    @command_signature = @command
    @acp_token = 'null'
    while @acp_token do
      @acp_token = @tokens.shift
      process_token if @acp_token
    end
  end

  def authorize_user_for_level(level)
    if @user.level == nil or @user.level < level
      @error = 'insufficient privileges'
      return false
    else
      return true
    end
  end


  # Example: add_group token:yum111 group:yuuk days_alive:30
  def test
    return if authorize_user_for_level(1) == false
    @response = "TEST"
  end

  # Example: use token:abcd1234
  def use_token
    return if authorize_user_for_level(1) == false
    @response = "ok: using token #{@token}"
    cp = CommandProcessor.new(user: @user, token: @token)
    @response = cp.execute
  end

  # Example: test
  def test
    return if authorize_user_for_level(1) == false
    @response = "TEST"
  end


  # Example: add group:yuuk token:yum111 days:30
  # Execution of the token adds the use to the group.
  def add_group_token_days
    return if authorize_user_for_level(2) == false
    token = "#{@user.screen_name}_#{@token}"
    group = "#{@user.screen_name}_#{@group}"
    cp = CommandProcessor.new(token: token, user: @user)
    @error = cp.put(command: @command, args: [group], days_alive: @days.to_i)
  end

  # Example: add doc:414 token:yum111 days:30
  # Execution of the tokenadds the document to the user's node
  def add_doc_token_days
    return if authorize_user_for_level(2) == false
    token = "#{@user.screen_name}_#{@token}"
    cp = CommandProcessor.new(token: token, user: @user)
    @error = cp.put(command: @command, args: [@doc], days_alive: @days.to_i)
  end


  # Example: add doc:123 and_group:foo token:11 days:30
  # Execution of the token adds the document to the user's node ad adds the group to the user.
  def add_doc_and_group_token_days
    return if authorize_user_for_level(2) == false
    group = "#{@user.screen_name}_#{@and_group}"
    token = "#{@user.screen_name}_#{@token}"
    cp = CommandProcessor.new(token: token, user: @user)
    @error = cp.put(command: @command, args: [group, @doc], days_alive: @days.to_i)
  end

  # Example: add_document_to_group document:414 group:red
  def add_doc_to_group
    return if authorize_user_for_level(2) == false
    @document = DocumentRepository.find @doc
    return if @document == nil
    return if @document.author_credentials2['id'].to_i != @user.id
    group = "#{@user.screen_name}_#{@to_group}"
    if @doc_modifier == 'read_only'
      @document.acl_set(:group, group, 'r')
    else
      @document.acl_set(:group, group, 'rw')
    end
    DocumentRepository.update @document
    @response = 'set_acl'
  end


end