module MediaItemHelper
  def consumption_difficulty_classes(difficulty)
    case difficulty
    when 'easy'   then 'bg-green-600'
    when 'medium' then 'bg-yellow-500'
    when 'hard'   then 'bg-red-600'
    else ''
    end
  end
end
