-- Map Buffer variables
local srcOffset = { c = 0, r = 18}
local destOffset = { c = 21, r = 1}

local nextColumn = destOffset.c
local currentColumn = destOffset.c - 1

local currentTemplate = 1
local templateSize = {w = 20, h = 13}

local templateStartIDs = {}
local templateEndIDs = {}
local columnCounter = 0

-- Copies tiles over to the visible part of the map
function CopyTileData(columnOffset)

  for i = 0, templateSize.h do

    -- Get a reference to the template's tile.
    local srcTile = Tile(srcOffset.c, srcOffset.r + i)
    
    -- Copy over the template tile values to the view area
    ProcessTile(columnOffset, destOffset.r + i, srcTile.spriteID, srcTile.colorOffset, srcTile.flag, mapTemplates[currentTemplate].entities)

    -- print("Copy", srcOffset.c, srcOffset.r + i, "to", columnOffset, destOffset.r + i)
  end

  -- Increment the offset for the next call
  srcOffset.c = srcOffset.c + 1

  columnCounter = columnCounter + 1

  if(columnCounter >= templateSize.w) then

    columnCounter = 0
    currentTemplate = FindNextTemplate(currentTemplate)

    -- Find the start position of the new template
    srcOffset.c = mapTemplates[currentTemplate].c
    srcOffset.r = mapTemplates[currentTemplate].r

  end

end

function FindNextTemplate(id)

  -- Get the list of valid next mapTemplates
  local nextTemplates = templateStartIDs[mapTemplates[id].endID]--mapTemplates[id].next

  -- By default we will always default to template 1 if a template isn't found
  local nextTemplateID = 1

  if(nextTemplates ~= nil) then
    nextTemplateID = nextTemplates[math.random(1, #nextTemplates)]
  end

  return nextTemplateID

end

function UpdateMapBuffer(timeDelta, scrollPos)

  -- Calculate the next column to render based on the new position
  nextColumn = math.ceil((scrollPos.x / 8) + destOffset.c)

  -- Calculate the number of tiles in between the new column and the previous column
  local total = nextColumn - currentColumn

  if(total > 0) then
    -- Loop through the total tiles and draw them to the display
    for i = 1, total do

      -- Copy over the column from the current template
      CopyTileData(currentColumn)

      -- Increase the column number for the next loop
      currentColumn = currentColumn + 1

    end
  end
end


function StitchTemplatesTogether()

  local total = #mapTemplates

  for i = 1, total do

    local template = mapTemplates[i]
    template.startID = ""
    template.endID = ""

    for j = 0, templateSize.h do

      -- Get the start tile
      local tileA = Tile(template.c, template.r + j).flag == 0 and 1 or 0

      local tileB = Tile(template.c + templateSize.w - 1, template.r + j).flag == 0 and 1 or 0

      template.startID = template.startID .. tileA
      template.endID = template.endID .. tileB

    end

    -- Save template's start ID
    if(templateStartIDs[template.startID] == nil) then

      templateStartIDs[template.startID] = {}

    end

    table.insert(templateStartIDs[template.startID], i)

    -- Save template's end ID
    if(templateEndIDs[template.endID] == nil) then

      templateEndIDs[template.endID] = {}

    end

    table.insert(templateEndIDs[template.endID], i)

  end

end
