class EventsController < ApplicationController
  def index
    @events = current_user.events.all
    @event = Event.new
  end

  def create
    @event = current_user.events.new(event_params)
    if @event.save
      redirect_to events_path, notice: '予定を保存しました。'
    else
      @events = current_user.events.all
      render :index
    end
  end

  private
    def event_params
      params.require(:event).permit(:name, :start_time)
    end
end
