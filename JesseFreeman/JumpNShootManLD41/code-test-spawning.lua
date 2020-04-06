local scrollOffsetX = 36
local scrollSpeed = 100
local spawnTime = 0
local spawnDelay = 10

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

  -- Check to see if we can spawn and on a spawn tile
  if(flag == 3) then

    -- Increase spawn time by the column
    spawnTime = spawnTime + 1

    if(spawnTime > spawnDelay) then

      SpawnRandomEntity(entities, column * 8, row * 8 - 8, true)

      spawnTime = math.random(0, 5)

    end

  end

end

-- Look into randomly generating the seed and saving it for reply
math.randomseed(1234)
