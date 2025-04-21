# app/controllers/admin/comments_controller.rb

module Admin
  class CommentsController < ApplicationController
    before_action :set_comment, only: %i[show edit update archive]
    before_action :set_commentable, only: %i[index new create]

    def index
      @comments = @commentable.comments.active
    end

    def show; end

    def new
      @comment = @commentable.comments.new
    end

    def create
      @comment = @commentable.comments.new(comment_params)
      @comment.user = current_user

      if @comment.save
        redirect_to [:admin, @commentable], notice: 'Comment was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @comment.update(comment_params)
        redirect_to [:admin, @commentable], notice: 'Comment was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def archive
      @comment.update(archived_at: Time.current)
      redirect_to [:admin, @commentable], notice: 'Comment was successfully archived.'
    end

    private

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_commentable
      @commentable = Player.find(params[:player_id]) if params[:player_id]
      @commentable ||= ScoutingReport.find(params[:scouting_report_id]) if params[:scouting_report_id]
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
  end
end
