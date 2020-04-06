LoadScript("code-score")
LoadScript("code-message-bar")

local player = nil
local scrollOffsetX = 36
local spawnTime = 0
local spawnDelay = 10
local deathTime = 2.5
local deathDelay = 3
local gameOver = true

function InitGame()

  PlayPatterns({6}, true)

end

function NewGame()

  DisplayMessage(" PRESS 'X' TO SHOOT AND 'C' TO JUMP", 2)

  gameOver = false

  -- Create player
  player = SpawnEntity("Player", scrollPos.x + scrollOffsetX, 0, false)

  ResetScore()

  PlayPatterns({2, 4, 4, 3, 1}, true)

  PlaySound(10, 4)

end

function GameOver()

  ClearMessage()

  deathTime = 0

  local hiscore = tonumber(ReadSaveData("Hiscore", "1000"))
  local score = GetScore()

  if(score > hiscore) then
    WriteSaveData("Hiscore", tostring(score))
    hiscore = score
  end

  local text = {
    "  GAME OVER",
    "HISCORE " .. string.format("%06d", hiscore),
    "SCORE   " .. string.format("%06d", score)
  }

  local startX = scrollPos.x + 24
  local startY = 40 + scrollPos.y

  DrawRect(scrollPos.x, startY - 8, 160, (#text + 2) * 8, 0, DrawMode.TilemapCache)

  for i = 1, #text do
    DrawText(text[i], startX, startY, DrawMode.TilemapCache, "default", 4)

    startY = startY + 9
  end

  gameOver = true

  PlayPatterns({5}, true)

end

function UpdateGame(timeDelta)

  if(gameOver == false) then
    -- Update the scroll position
    scrollPos = ScrollPosition(player.pos.x - scrollOffsetX)

    -- Update Map buffer
    UpdateMapBuffer(timeDelta, scrollPos)

  else

    deathTime = deathTime + timeDelta

    if(deathTime > deathDelay) then

      DisplayMessage("        PRESS 'A' TO START", 0)

      if( Button(Buttons.Start, InputState.Released) ) then
        NewGame()
      end

    end

  end

  UpdateMessageBar(timeDelta)

end

function DrawGame()

  Clear()

  hudHeight = messageBarVisible and 8 or 0

  -- Draw the message bar
  DrawMessageBar()

  -- Draw message bar
  DrawTilemap(0, 0, 20, 1, 0, 0)

  -- Draw game window
  DrawTilemap(0, hudHeight, 20, 15 - (hudHeight / 8), scrollPos.x, scrollPos.y + hudHeight)

  if(gameOver == false) then
    UpdateMeterBar(0, 120, player, "health")

    UpdateMeterBar(48, 120, player, "energy")
  else
    -- Draw meter background
    DrawMeterBar(0, 120, "health")
    DrawMeterBar(48, 120, "energy")
  end

  DrawScore()

  -- Draw bottom hud
  DrawTilemap(0, 120, 20, 2, 0, 120)
end

function ProcessTile(column, row, spriteID, colorOffset, flag, entities)

  -- Check to see if we can spawn and on a spawn tile
  if(flag == 3) then

    -- Increase spawn time by the column
    spawnTime = spawnTime + 1

    if(spawnTime > spawnDelay) then

      SpawnRandomEntity(entities, column * 8, row * 8 - 8, true)

      spawnTime = math.random(0, 5)

    end

  end

  Tile(column, row, spriteID, colorOffset, flag)

end
