module MediaItemHelper
  def consumption_difficulty_classes(difficulty)
    case difficulty
    when 'easy'   then 'text-green-600'
    when 'medium' then 'text-yellow-600'
    when 'hard'   then 'text-red-600'
    else ''
    end
  end
end
