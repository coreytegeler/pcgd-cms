class AccessController < ApplicationController

  layout 'access'
  before_action :confirm_logged_in, :except => [:index, :login, :attempt_login, :logout, :admin]

  def attempt_login
  	if params[:email].present? && params[:password].present?
  		found_user = Admin.where(:email => params[:email]).first
  		if found_user
  			authorized_user = found_user.authenticate(params[:password])
  		end
  	end
  	if authorized_user
  		session[:admin_id] = authorized_user.id
      session[:email] = authorized_user.email
  		flash[:notice] = "You're in!"
  		flash[:type] = "good"
  		redirect_to(:action => 'login')
  	else
  		flash[:notice] = "Nope, that's not gonna work."
  		flash[:type] = "bad"
  		redirect_to(:action => 'login')
  	end
  end

  def index
    @admin = Admin.where(:id => session[:admin_id]).first
  end

  def login
    @admin = Admin.where(:id => session[:admin_id]).first
  end

  def logout
    admin = Admin.where(:id => session[:admin_id]).first
    session[:admin_id] = nil
    session[:email] = nil
  	flash[:notice] = "Bye bye."
  	flash[:type] = "bad"
  	go_back
  end

  def admin?
    session[:admin_id]
  end


end
