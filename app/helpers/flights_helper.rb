module FlightsHelper
  def pretty_flight_time(time)
    return "" unless time
    hour = time.hour
    icon = if hour >= 0 && hour < 12
      "☀️"
    else
      "🌙"
    end
    "#{time.strftime('%d %b %-l %M %P')} #{icon}"
  end

  def luggage_icon(luggage)
    if luggage == "23-KG"
      "🧳"
    elsif luggage == "46-KG" || luggage == "43-KG"
      "🧳🧳"
    end
  end
end
