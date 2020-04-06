-- Global table for all entities
entities = {}

local display = Display(false)
local border = 16
local bounds = NewRect(-border, 0, display.x + border, display.y)
local unspawnedEntities = {}

function SpawnEntity(type, x, y, flipH)

  -- See if there is a custom method to configure the enemy
  if(_G["ConfigureEntity"..type] ~= nil) then

    -- Set up the base entity's properties
    local entityData = {
      type = type, -- TODO this should be type (change type in collision to collisionFlag)
      uid = tostring(os.time()),
      pos = NewPoint(x, y),
      rect = NewRect(0, 0, 16, 16),
      colorOffset = 0,
      flipH = flipH or false
    }

    -- Add the entity to the list
    table.insert(unspawnedEntities, entityData)

    _G["ConfigureEntity"..type](entityData)

    -- Return the final entity data
    return entityData

  end

  -- Return nil when no entity was created
  return nil

end

function SpawnRandomEntity(types, x, y, flipH)

  local id = math.random(1, #types)

  SpawnEntity(types[id], x, y, flipH)

end

function RemoveEntity(id)

  local entity = entities[id]

  if(entity ~= nil) then

    -- print("Remove Entity", entity.type, entity.uid)

    if(entity["onRemove"] ~= nil) then

      entity["onRemove"]()

    end

  end

end

local tmpRect = NewRect()


function UpdateEntities(timeDelta, scrollPos)

  bounds.x = scrollPos.x
  bounds.y = scrollPos.y

  -- Look to see if there are entities we need to add
  if(#unspawnedEntities > 0)then
    for i = 1, #unspawnedEntities do
      table.insert(entities, unspawnedEntities[i])
    end

    -- Clear list
    unspawnedEntities = {}
  end

  -- Loop through and update all entities
  for i = 1, #entities do

    -- Get the next entity
    local entity = entities[i]

    -- Look to see if the entity has been flagged to be removed
    if(entity.remove ~= true) then

      tmpRect.x = entity.pos.x
      tmpRect.y = entity.pos.y
      tmpRect.width = entity.rect.width
      tmpRect.height = entity.rect.height

      -- Test to see if the entity is on the screen
      if(bounds.Contains(tmpRect)) then

        -- If entity has update callback, call it
        if(entity.onUpdate ~= nil) then
          entity.onUpdate(timeDelta)
        end

        AnimateEntity(entity, timeDelta)

      else

        -- Entity is offscreen, flag it to be removed
        entity.remove = true

      end

    end

  end

end

function DrawEntities()

  local activeEntities = {}

  -- Loop through and draw all entities
  for i = 1, #entities do

    local entity = entities[i]

    if(entity.remove ~= true) then

      -- Add entity to active list for next frame
      table.insert(activeEntities, entity)

      -- Only draw if the entity has a graphic
      if(entity.spriteData ~= nil) then
        DrawSprites(entity.spriteData.spriteIDs, entity.pos.x, entity.pos.y, entity.spriteData.width, entity.flipH, false, DrawMode.Sprite, entity.colorOffset, true, true)
      end

      if(debug) then
        DebugRect(entity)
      end

    else

      RemoveEntity(i)

    end

  end

  entities = activeEntities

end

function DebugRect(entity)

  local debugRect = CalculateRect(entity)

  local scrollPos = ScrollPosition()
  DrawRect(debugRect.x - scrollPos.x, debugRect.y - scrollPos.y, debugRect.width, debugRect.height, 10, DrawMode.SpriteBelow)

end

function ConfigureAnimation(entity, frames, delay)

  -- Set up frames
  entity.frames = frames

  entity.frame = 1
  entity.frameDelay = delay or .1
  entity.time = 0

end

function AnimateEntity(entity, timeDelta)

  -- Animate entity
  if(entity.frames ~= nil) then

    -- Update the animation frame time
    entity.time = entity.time + timeDelta

    -- Look to see if the time is greater than the frame delay then update the current frame
    if(entity.time > entity.frameDelay) then

      -- Reset time
      entity.time = 0

      -- Update the current frame
      entity.frame = entity.frame + 1

      if(entity.frame > #entity.frames) then
        entity.frame = 1
      end

      -- push the current frame into the entity's spriteData property
      entity.spriteData = entity.frames[entity.frame]

    end

  end

end

function MoveEntity(entity, timeDelta)

  local dirX = entity.flipH and - 1 or 1
  local dirY = entity.flipV and 1 or - 1

  local delay = math.floor(timeDelta * 100)

  entity.pos.x = entity.pos.x + (math.abs(entity.speed.x) * delay * dirX)
  entity.pos.y = entity.pos.y + (math.abs(entity.speed.y) * delay * dirY)

end
