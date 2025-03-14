class Admin::TeamsController < ApplicationController
  def index
    @teams = Team.all
  end

  def show
    @team = Team.find(params[:id])
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      redirect_to admin_team_path(@team), notice: 'Team created successfully'
    else
      render :new
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    if @team.update(team_params)
      redirect_to admin_team_path(@team), notice: 'Team updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    redirect_to admin_teams_path, notice: 'Team deleted successfully'
  end

  private

  def team_params
    params.require(:team).permit(:name, :abbreviation)
  end
end
