class Admin::TrackingListPlayersController < AdminController
  before_action :set_tracking_list_player, only: [:destroy]

  def create
    @tracking_list_player = TrackingListPlayer.new(tracking_list_player_params)

    respond_to do |format|
      if @tracking_list_player.save
        format.json { render json: { tracked: true, message: 'Player added to tracking list' }, status: :created }
      else
        format.json { render json: { errors: @tracking_list_player.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # Finds by tracking_list_id and player_id in the URL
    respond_to do |format|
      if @tracking_list_player&.destroy
        format.json { render json: { tracked: false, message: 'Player removed from tracking list' }, status: :ok }
      else
        format.json { render json: { errors: ['Failed to remove player from tracking list'] }, status: :unprocessable_entity }
      end
    end
  end

  private

  def tracking_list_player_params
    params.require(:tracking_list_player).permit(:player_id, :tracking_list_id)
  end

  def set_tracking_list_player
    @tracking_list_player = TrackingListPlayer.find_by(
      tracking_list_id: params[:tracking_list_id],
      player_id: params[:id]
    )
  end
end
