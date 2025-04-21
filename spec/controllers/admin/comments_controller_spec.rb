require 'rails_helper'

describe Admin::CommentsController, type: :controller do
  let(:resource) { :comment }
  let(:controller_class) { Comment }
  let(:klass) { Comment }
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe '#create_for_player' do
    let(:player) { create(:player) }
    let(:valid_params) { { player_id: player.id, body: 'This is a test comment' } }

    it 'creates a new comment for a player' do
      expect do
        post :create_for_player, params: valid_params, format: :turbo_stream
      end.to change(Comment, :count).by(1)

      expect(Comment.last.commentable).to eq(player)
      expect(Comment.last.body).to eq('This is a test comment')
      expect(Comment.last.user).to eq(user)
    end

    it 'responds with a turbo stream' do
      post :create_for_player, params: valid_params, format: :turbo_stream
      expect(response.media_type).to eq('text/vnd.turbo-stream.html')
    end

    it 'redirects to the player profile page when format is html' do
      post :create_for_player, params: valid_params
      expect(response).to redirect_to(admin_player_profile_path(player))
    end

    it 'shows an error message when comment is invalid' do
      post :create_for_player, params: { player_id: player.id, body: '' }
      expect(flash[:danger]).to include("Body can't be blank")
    end
  end

  describe '#update_comment' do
    let(:comment) { create(:comment, user: user) }
    let(:valid_params) { { id: comment.id, body: 'Updated comment' } }

    it 'updates the comment' do
      patch :update_comment, params: valid_params, format: :turbo_stream
      expect(comment.reload.body).to eq('Updated comment')
    end

    it 'responds with a turbo stream' do
      patch :update_comment, params: valid_params, format: :turbo_stream
      expect(response.media_type).to eq('text/vnd.turbo-stream.html')
    end

    it 'redirects back when format is html' do
      request.env['HTTP_REFERER'] = admin_player_profile_path(comment.commentable)
      patch :update_comment, params: valid_params
      expect(response).to redirect_to(admin_player_profile_path(comment.commentable))
    end

    it 'shows an error message when update is invalid' do
      patch :update_comment, params: { id: comment.id, body: '' }
      expect(flash[:danger]).to include("Body can't be blank")
    end
  end

  describe '#archive' do
    let(:instance) { create(resource) }

    it 'archives a comment' do
      expect do
        patch :archive, params: { id: instance.id }
      end.to change { instance.reload.archived_at }.from(nil).to(be_present)
    end

    it 'logs the archive action' do
      expect do
        patch :archive, params: { id: instance.id }
      end.to change(DataLog, :count).by(1)
    end

    it 'redirects to the comments index page' do
      patch :archive, params: { id: instance.id }
      expect(response).to redirect_to(admin_comments_path)
    end
  end
end
