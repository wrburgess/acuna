class Admin::RostersController < ApplicationController
  def index
    @rosters = Roster.all
  end

  def show
    @roster = Roster.find(params[:id])
  end

  def new
    @roster = Roster.new
  end

  def create
    @roster = Roster.new(roster_params)
    if @roster.save
      redirect_to admin_roster_path(@roster), notice: 'Roster created successfully'
    else
      render :new
    end
  end

  def edit
    @roster = Roster.find(params[:id])
  end

  def update
    @roster = Roster.find(params[:id])
    if @roster.update(roster_params)
      redirect_to admin_roster_path(@roster), notice: 'Roster updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @roster = Roster.find(params[:id])
    @roster.destroy
    redirect_to admin_rosters_path, notice: 'Roster deleted successfully'
  end

  private

  def roster_params
    params.require(:roster).permit(:name, :abbreviation)
  end
end
