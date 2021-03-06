class EventsController < ApplicationController
   skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @events = policy_scope(Event).order(created_at: :desc)
    @services = Service.all
    start_date = params[:starts_at]
    end_date = params[:ends_at]
    max_price_filter = params[:max_price].to_i
    min_price_filter = params[:min_price].to_i

    filter_service = Service.find_by(name: params[:service])
    date_filtered_events = Event.all.where("date > ?", DateTime.now)
    filtered_events = date_filtered_events
      # Filtering By location
    location_search = params[:location]


    if !min_price_filter.zero? && !max_price_filter.zero?
      filtered_events = filtered_events.where('min_price > ? AND min_price < ?', min_price_filter, max_price_filter)
    end
    if location_search != ""
      filtered_events = Event.near(location_search, 50)
    end

    if start_date == true
      start_date = start_date.to_date
    end

    if end_date == true
      end_date = end_date.to_date
    end
    if filter_service
      filtered_events = filtered_events.where('service_id = ?', filter_service.id)
    end
      # Filtering By price
    if start_date.present? && end_date.present?
      filtered_events = filtered_events.where('date > ? AND date < ?', start_date, end_date)
      @events = policy_scope(filtered_events).order(date: :asc)
     # If filtered_events is empty will display every event
    elsif filtered_events.empty?
      @events = policy_scope(date_filtered_events).order(date: :asc)
      # Displays filtered_events filtered events
    else
      @events = policy_scope(filtered_events).order(date: :asc)
    end
  end

  def show
    @event = Event.find(params[:id])
    @user = current_user
    @event_user = @event.user
    @bid = Bid.new()
    authorize @event
  end

  def new
    @event = Event.new
    @services = Service.all
    authorize @event
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    @services = Service.all
    authorize @event
    if @event.save
      flash[:success] = "Event saved!"
      redirect_to event_path(@event)
    else
      render :new
    end
  end

  def edit
    @user = current_user
    @services = Service.all
    @event = Event.find(params[:id])
    render
    authorize @user
  end

  def update
    @user = current_user
    @services = Service.all
    @event = Event.find(params[:id])
    authorize @event
    if @event.update(event_params)
      flash[:success] = "Event updated!"
      redirect_to event_path(@event)
    else
      render :edit
    end
  end


  def destroy
    @event = Event.find(params[:id])
    authorize @event
    if event.destroy
      redirect_to event_path
    else
      render :destroy
    end
  end

  private

  def event_params
    params.require(:event).permit(:user_id, :service_id, :name, :date, :event_type, :location, :description, :party_size, :max_price, :min_price)
  end
end
