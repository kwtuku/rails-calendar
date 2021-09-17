module ApplicationHelper
  def start_time_or_end_time(day, start_time, end_time)
    if day == start_time.day
      "#{l start_time}~"
    elsif day == end_time.day
      "~#{l end_time}"
    else
      '終日'
    end
  end

  def show_time(start_time, end_time)
    if start_time.day == end_time.day
      "#{l start_time, format: :long}~#{l end_time}"
    else
      "#{l start_time, format: :long}~#{l end_time, format: :long}"
    end
  end

  def form_modal_title
    if controller.action_name == 'edit'
      '予定を編集'
    else
      '予定を複製'
    end
  end

  def submit_button_text
    if controller.action_name == 'edit'
      '更新'
    else
      '保存'
    end
  end
end
