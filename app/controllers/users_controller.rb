class UsersController < ApplicationController
	before_action :authenticate_user!

  def show
  	@user = User.find(params[:id])
  	@books = @user.books
		@book = Book.new #new bookの新規投稿で必要（保存処理はbookコントローラー側で実施）
		@current_user_room = UserRoom.where(user_id: current_user.id)
		@user_user_room = UserRoom.where(user_id: @user.id)
		if @user.id == current_user.id
    else
      @current_user_room.each do |cu|
        @user_user_room.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @user_room = UserRoom.new
      end
    end
  end

	def index
		@user = current_user
  	@users = User.all #一覧表示するためにUserモデルのデータを全て変数に入れて取り出す。
  	@book = Book.new #new bookの新規投稿で必要（保存処理はbookコントローラー側で実施）
	end

  def edit
		@user = User.find(params[:id])
		# @book = @user.books
		@book = @user.books
		if @user == current_user
			render :edit
		else
			redirect_to user_path(current_user.id)
		end
  end

  def update
  	@user = User.find(params[:id])
  	if @user.update(user_params)
  		redirect_to user_path(@user), notice: "successfully updated user!"
		else
  		render :edit
  	end
	end
	
	def following
		@user = User.find(params[:id])
		@users = @user.followings
		@book = Book.new
		@books = Book.all
	end

	def followers
		@user = User.find(params[:id])
		@users = @user.followers
		@book = Book.new
		@books = Book.all
	end


  private
  def user_params
  	params.require(:user).permit(:name, :introduction, :profile_image)
  end

  #url直接防止　メソッドを自己定義してbefore_actionで発動。
   def baria_user
  	unless params[:id].to_i == current_user.id
  		redirect_to user_path(current_user)
  	end
   end

end