local score = 0
local scoreDisplay = -1
local pos = NewPoint(101, 123)
function DrawScore()
  -- Update score
  if(scoreDisplay ~= score) then

    local diff = math.floor((score - scoreDisplay) / 4)

    if(diff < 1) then
      scoreDisplay = score
    else
      scoreDisplay = scoreDisplay + diff
    end

    if(scoreDisplay < 0) then
      scoreDisplay = 0
    end

    DrawRect(pos.x, pos.y, 48, 8, BackgroundColor(), DrawMode.TilemapCache)

    DrawText(string.format("%06d", scoreDisplay), pos.x, pos.y, DrawMode.TilemapCache, "default", 0, 0)

  end

end

function AddScore(value)
  score = score + value
end

function ResetScore()
  score = 0
  scoreDisplay = -1
end

function ScoreAsString()
  return string.format("%06d", score)
end

function GetScore()
  return score
end
