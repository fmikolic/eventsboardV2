class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  #before_action :authorize_owner!, only: [:edit, :update, :destroy]

  # GET /events or /events.json
  def index
    if params[:query].present?
      @events = Event.search(params[:query])
    else
      @events = Event.order(created_at: :desc).paginate(page: params[:page], per_page: 4)
    end
    
    @categories = Category.order(:name)
    authorize @events, :index?
  end

  # GET /events/1 or /events/1.json
  def show
    authorize @event, :show?
    @comment = Comment.new
    @comment.event_id = @event.id
  end

  # GET /events/new
  def new
    @event = Event.new

    authorize @event, :new?
  end

  # GET /events/1/edit
  def edit
    authorize @event, :edit?
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)
    @event.organizer = current_user

    authorize @event, :create?

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_url(@event), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update

    authorize @event, :update?

    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    authorize @event, :destroy?
    @event.destroy
    
    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.friendly.find(params[:id])

    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "User does not exist!"
      redirect_to events_path
    end

    # def authorize_owner!
    #   authenticate_user!

    #   unless @event.organizer == current_user
    #     flash[:alert] = "You do not have enough permission to '#{action_name}' the '#{@event.title.upcase}' event!"
    #     redirect_to events_path
    #   end
    # end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:title, :description, :start_date, :end_date, :venue, :location, :image, :category_id, :seats, :tag_list)
    end
end
