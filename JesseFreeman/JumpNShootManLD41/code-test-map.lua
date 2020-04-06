local scrollOffsetX = 0
local scrollSpeed = 100

function InitGame()

end

function UpdateGame(timeDelta)

  scrollOffsetX = scrollOffsetX + (scrollSpeed * timeDelta)

  -- Update the scroll position
  scrollPos = ScrollPosition(scrollOffsetX)

  -- Update Map buffer
  UpdateMapBuffer(timeDelta, scrollPos)

end

function DrawGame()

  RedrawDisplay()

end

function ProcessTile(column, row, spriteID, colorOffset, flag, entities)

  Tile(column, row, spriteID, colorOffset, flag)

end
