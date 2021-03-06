class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  def creating_a_game_for_each_team
    @games = Game.where(create_team: params[:team_name])
    render 'games/index'
  end

  # GET /games/1
  # GET /games/1.json
  def show
    game_id =  params["id"].to_i
    @game_score = Game.find_by(id: game_id).game_scores.map(&:score).sort_by(&:score).reverse.first(3)
  end

  # GET /games/new
  def new
    admin? ? @game = Game.new : (redirect_to :root)
  end

  # GET /games/1/edit
  def edit
    admin? ? nil : (redirect_to :root )
  end

  # POST /games
  # POST /games.json
  def create
    if admin?
      @game = Game.new(game_params)

      respond_to do |format|
        if @game.save
          format.html { redirect_to @game, notice: 'Game was successfully created.' }
          format.json { render :show, status: :created, location: @game }
        else
          format.html { render :new }
          format.json { render json: @game.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    if admin?
      respond_to do |format|
        if @game.update(game_params)
          format.html { redirect_to @game, notice: 'Game was successfully updated.' }
          format.json { render :show, status: :ok, location: @game }
        else
          format.html { render :edit }
          format.json { render json: @game.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    if admin?
      @game.destroy
      respond_to do |format|
        format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  def ballot
    unless session[:ballot]
      game = Game.find_by(id: params["form_ballot"].to_i)
      game.update(like: game.like + 1)
      session[:ballot] = true
      personal = {'status' => 'Successfully'}; render :json => personal
    else
      personal = {'status' => 'Already'}; render :json => personal
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def game_params
    params.require(:game).permit(:banner_url, :title, :create_team, :bio, :like)
  end
end
