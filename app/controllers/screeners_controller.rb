class ScreenersController < ApplicationController
  before_action :set_screener, only: %i[ show edit update destroy ]

  # GET /screeners or /screeners.json
  def index
    @screeners = Screener.all
  end

  # GET /screeners/1 or /screeners/1.json
  def show
  end

  # GET /screeners/new
  def new
    @screener = Screener.new
  end

  # GET /screeners/1/edit
  def edit
  end

  # POST /screeners or /screeners.json
  def create
    @screener = Screener.new(screener_params)

    respond_to do |format|
      if @screener.save
        format.html { redirect_to @screener, notice: "Screener was successfully created." }
        format.json { render :show, status: :created, location: @screener }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @screener.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /screeners/1 or /screeners/1.json
  def update
    respond_to do |format|
      if @screener.update(screener_params)
        format.html { redirect_to @screener, notice: "Screener was successfully updated." }
        format.json { render :show, status: :ok, location: @screener }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @screener.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /screeners/1 or /screeners/1.json
  def destroy
    @screener.destroy!

    respond_to do |format|
      format.html { redirect_to screeners_path, status: :see_other, notice: "Screener was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_screener
      @screener = Screener.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def screener_params
      params.expect(screener: [ :name, :description, :amount ])
    end
end
