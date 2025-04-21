class Admin::CommentsController < AdminController
  def index
    authorize policy_class
    @collection = ordered_and_paginated(controller_class.all)
  end

  def show
    @instance = controller_class.find(params[:id])
    authorize policy_class
  end

  def new
    @instance = controller_class.new
    authorize policy_class
  end

  def edit
    @instance = controller_class.find(params[:id])
    authorize policy_class
  end

  def create
    @instance = controller_class.new(instance_params)
    authorize policy_class

    if @instance.save
      @instance.log(user: current_user, operation: action_name)
      flash[:success] = 'Comment successfully created'
      redirect_to polymorphic_path([:admin, @instance])
    else
      flash.now[:danger] = @instance.errors.full_messages.join(', ')
      render :new
    end
  end

  def update
    @instance = controller_class.find(params[:id])
    authorize policy_class

    if @instance.update(instance_params)
      @instance.log(user: current_user, operation: action_name)
      flash[:success] = 'Comment successfully updated'
      redirect_to polymorphic_path([:admin, @instance])
    else
      flash.now[:danger] = @instance.errors.full_messages.join(', ')
      render :edit
    end
  end

  def archive
    @instance = controller_class.find(params[:id])
    authorize policy_class
    @instance.archive

    @instance.log(user: current_user, operation: action_name)
    flash[:danger] = 'Comment successfully archived'
    redirect_to polymorphic_path([:admin, controller_class])
  end

  def unarchive
    @instance = controller_class.find(params[:id])
    authorize policy_class
    @instance.unarchive

    @instance.log(user: current_user, operation: action_name)
    flash[:success] = 'Comment successfully unarchived'
    redirect_to polymorphic_path([:admin, @instance])
  end

  def create_for_player
    player = Player.find(params[:player_id])
    @comment = Comment.new(
      body: params[:body],
      user: current_user,
      commentable: player
    )

    if @comment.save
      @comment.log(user: current_user, operation: 'create')
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to admin_player_profile_path(player) }
      end
    else
      flash[:danger] = @comment.errors.full_messages.join(', ')
      redirect_to admin_player_profile_path(player)
    end
  end

  def update_comment
    @comment = Comment.find(params[:id])
    authorize policy_class

    if @comment.update(body: params[:body])
      @comment.log(user: current_user, operation: 'update')
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back(fallback_location: admin_player_profile_path(@comment.commentable)) }
      end
    else
      flash[:danger] = @comment.errors.full_messages.join(', ')
      redirect_back(fallback_location: admin_player_profile_path(@comment.commentable))
    end
  end

  private

  def controller_class
    Comment
  end

  def policy_class
    Admin::CommentPolicy
  end

  def instance_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type)
  end
end
