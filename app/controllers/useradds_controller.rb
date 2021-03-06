class UseraddsController < ApplicationController
  before_filter :authorize, only: [:new], :except => :new_session_path
  def show
    @useradd = Useradd.find(params[:id])
  end

  def new
    @useradd = Useradd.new
  end

  def create
    @useradd = Useradd.new(user_params)
    if @useradd.save
      # Handle a successful save.
      flash[:notice] = "Successfully create #{@useradd.name}"  
      redirect_to @useradd
    else
      flash[:notice] = "The format input is not corrent"  
      render 'new'
      
    end
  end

  private

    def user_params
      params.require(:useradd).permit(:name, :email, :password,
                                   :password_confirmation)
    end
=begin 
 def create
    @user = Useradd.new(user_params)
    if @user.save
	redirct_to @user
      # Handle a successful save.
    else
      render 'new'
    end
	
  end
  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
=end

end
