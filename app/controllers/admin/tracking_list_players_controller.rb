class Admin::TrackingListPlayersController < AdminController
  before_action :authenticate_user!
  before_action :set_tracking_list

  def add_player
    authorize(@tracking_list, :update?)
    @player = Player.find(params[:player_id])

    @tracking_list.players << @player unless @tracking_list.players.include?(@player)

    respond_to do |format|
      format.json { render json: { success: true, player_id: @player.id, tracking_list_id: @tracking_list.id, action: 'added' } }
    end
  end

  def remove_player
    authorize(@tracking_list, :update?)
    @player = Player.find(params[:player_id])

    @tracking_list.players.delete(@player)

    respond_to do |format|
      format.json { render json: { success: true, player_id: @player.id, tracking_list_id: @tracking_list.id, action: 'removed' } }
    end
  end

  private

  def set_tracking_list
    @tracking_list = TrackingList.find(params[:tracking_list_id])
  end
end
