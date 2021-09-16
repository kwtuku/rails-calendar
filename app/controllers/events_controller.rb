class EventsController < ApplicationController
  def index
    @events = current_user.events.all
    @event = Event.new
  end

  def show
    @event = Event.find(params[:id])
    redirect_to root_path, status: 401, alert: '権限がありません。' if current_user.id != @event.user_id
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
