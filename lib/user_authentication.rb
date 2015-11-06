
class UserAuthentication

  def initialize(email, password)
    @email = email
    @password = password
    @user = UserRepository.find_one_by_email(@email)
  end

  def authenticate
    BCrypt::Password.new(@user.password) == @password if @user
  end

  def login(session)
    if authenticate
      puts "in login, authenticate  is successful".magenta
      session[:user_id] = @user.id
      return @user
    end
  end

end


module SessionTools

  def logout(user, session)
    session[user.id] = nil
  end

  def current_user(session)
    UserRepository.find session[:user_id]
  end

end