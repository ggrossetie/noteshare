module SessionManager::Controllers::User
  class Login
    include SessionManager::Action

    def call(params)
      puts "controler SessionManager, Login".magenta

    end
  end
end
