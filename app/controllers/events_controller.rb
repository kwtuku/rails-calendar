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
      respond_to do |format|
        format.html do
          @events = current_user.events.all
          render :index
        end
        format.js { render 'error' }
      end
    end
  end

  def edit
    @event = Event.find(params[:id])
    redirect_to root_path, status: 401, alert: '権限がありません。' if current_user.id != @event.user_id
  end

  def update
    @event = Event.find(params[:id])
    if current_user.id != @event.user_id
      redirect_to root_path, status: 401, alert: '権限がありません。'
    elsif @event.update(event_params)
      redirect_to events_path, notice: '予定を更新しました。'
    else
      render 'error'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if current_user.id != @event.user_id
      redirect_to root_path, status: 401, alert: '権限がありません。'
    else
      @event.destroy
      redirect_to events_url, notice: '予定を削除しました。'
    end
  end

  def duplicate
    @original_event = Event.find(params[:id])
    redirect_to root_path, status: 401, alert: '権限がありません。' if current_user.id != @original_event.user_id
    @event = Event.new
  end

  private
    def event_params
      params.require(:event).permit(:name, :description, :start_time, :end_time)
    end
end
