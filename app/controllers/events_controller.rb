class EventsController < ApplicationController
  def index
    @events = current_user.events.all
  end
end
