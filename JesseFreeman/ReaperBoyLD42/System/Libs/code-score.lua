local score = 0
local scoreDisplay = 0
local pos = NewPoint()

function SetScorePos(x, y)
  pos.x = x
  pos.y = y
end

function DrawScore()
  -- Update score
  if(scoreDisplay ~= score) then

    local diff = ScoreDif()--math.floor((score - scoreDisplay) / 4)

    if(diff < 1) then
      scoreDisplay = score
    else
      scoreDisplay = scoreDisplay + diff
    end

    if(scoreDisplay < 0) then
      scoreDisplay = 0
    end
  end

  CopyScoreToBackground()

end

function CopyScoreToBackground()

  -- DrawRect(pos.x + ScrollPosition().x, pos.y + ScrollPosition().y, 48, 8, BackgroundColor(), DrawMode.TilemapCache)

  DrawText("SCORE " ..string.format("%06d", scoreDisplay), pos.x, pos.y, DrawMode.Sprite, "large-green", 0, 0)

  if(enemyMultiplier > 1) then
    DrawText("BONUS X" .. string.format("%02d", enemyMultiplier), pos.x + 24, pos.y + 9, DrawMode.Sprite, "large-orange", 0, 0)
  end

end


function ScoreDif()
  return math.floor((score - scoreDisplay) / 4)
end

function ScoreAnimating()
  return scoreDisplay < score
end

function AddScore(value)
  score = score + (value * enemyMultiplier)
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
