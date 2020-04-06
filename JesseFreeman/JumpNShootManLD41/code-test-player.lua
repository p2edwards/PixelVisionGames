local scrollOffsetX = 36

function InitGame()

  -- Create player
  player = SpawnEntity("Player", scrollOffsetX, 24, false)

end

function UpdateGame(timeDelta)

  -- Update the scroll position
  scrollPos = ScrollPosition(player.pos.x - scrollOffsetX)

  -- Update Map buffer
  UpdateMapBuffer(timeDelta, scrollPos)

end

function DrawGame()

  RedrawDisplay()

end

function ProcessTile(column, row, spriteID, colorOffset, flag, entities)

  Tile(column, row, spriteID, colorOffset, flag)

end

function GameOver()
  player = SpawnEntity("Player", scrollPos.x + scrollOffsetX, 24, false)
end
