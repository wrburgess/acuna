class Admin::CommentsController < AdminController
  def index
    authorize(policy_class)
    search = controller_class.ransack(params[:q])
    search.sorts = controller_class.default_sort if search.sorts.empty?
    @pagy, @collection = pagy(search.result, items: 50)
  end

  def show
    @instance = controller_class.find(params[:id])
    authorize(policy_class)
  end

  def new
    @instance = controller_class.new
    authorize(policy_class)
  end

  def edit
    @instance = controller_class.find(params[:id])
    authorize(policy_class)
  end

  def create
    @instance = controller_class.new(permitted_attributes(policy_class))
    authorize(policy_class)

    if @instance.save
      @instance.log(user: current_user, operation: action_name)
      flash[:success] = "#{instance.class_name_title} successfully created"
      redirect_to polymorphic_path([:admin, @instance])
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @instance = controller_class.find(params[:id])
    authorize(policy_class)

    if @instance.update(permitted_attributes(policy_class))
      @instance.log(user: current_user, operation: action_name)
      flash[:success] = "#{instance.class_name_title} successfully updated"
      redirect_to polymorphic_path([:admin, @instance])
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def archive
    @instance = controller_class.find(params[:id])
    authorize(policy_class)
    @instance.archive

    @instance.log(user: current_user, operation: action_name)
    flash[:danger] = "#{instance.class_name_title} successfully archived"
    
    if @instance.commentable_type == "Player" && params[:redirect_to_profile].present?
      redirect_to profile_admin_player_path(@instance.commentable_id)
    else
      redirect_to polymorphic_path([:admin, controller_class])
    end
  end

  def unarchive
    authorize(policy_class)
    @instance = controller_class.find(params[:id])
    @instance.unarchive

    @instance.log(user: current_user, operation: action_name)
    flash[:success] = "#{instance.class_name_title} successfully unarchived"
    redirect_to polymorphic_path([:admin, @instance])
  end

  def player_comments
    authorize(policy_class)
    @player = Player.find(params[:player_id])
    @comments = @player.comments.actives.select_order
    @new_comment = @player.comments.new(user: current_user)
    
    respond_to do |format|
      format.turbo_stream
      format.html { render partial: 'admin/comments/player_comments', locals: { player: @player, comments: @comments, new_comment: @new_comment } }
    end
  end

  def create_player_comment
    authorize(policy_class)
    @player = Player.find(params[:player_id])
    @comment = @player.comments.new(permitted_attributes(policy_class).merge(user: current_user))
    
    if @comment.save
      @comment.log(user: current_user, operation: action_name)
      @comments = @player.comments.actives.select_order
      @new_comment = @player.comments.new(user: current_user)
      
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to profile_admin_player_path(@player) }
      end
    else
      @comments = @player.comments.actives.select_order
      
      respond_to do |format|
        format.turbo_stream
        format.html { render partial: 'admin/comments/player_comments', locals: { player: @player, comments: @comments, new_comment: @comment }, status: :unprocessable_entity }
      end
    end
  end

  private

  def controller_class
    Comment
  end

  def instance
    @instance
  end
  helper_method :instance
end