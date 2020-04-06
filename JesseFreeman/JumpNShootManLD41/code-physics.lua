local gravity = 20
local solidFlag = 0
local mapSize = TilemapSize()
local nextPos = {x = 0, y = 0}
local gridPos = NewPoint()
local result = NewPoint()

Color(8, "#00FF00")
Color(9, "#0000FF")

function DebugPhysics(testPos, testGrid)

  local scrollPos = ScrollPosition()

  -- Draw current grid
  DrawRect((testGrid.x * 8) - scrollPos.x, (testGrid.y * 8) - scrollPos.y, 8, 8, 9, DrawMode.SpriteAbove)

  -- Draw test position
  DrawRect(testPos.x - scrollPos.x, testPos.y - scrollPos.y, 1, 1, 8, DrawMode.SpriteAbove)

end

function ConfigurePhysicsEntity(entity, jumpVel)

  -- Add new fields
  entity.vel = {x = 0, y = 0}
  entity.standing = false
  entity.jumpVel = jumpVel or 3

  CalculatePhysicsPoint(entity)

end

function CalculatePhysicsPoint(entity)

  local collisionPoints = {}

  collisionPoints.tl = NewPoint(entity.rect.x, entity.rect.y)
  collisionPoints.ml = NewPoint(collisionPoints.tl.x, collisionPoints.tl.y + math.floor(entity.rect.height / 2) - 1)
  collisionPoints.bl = NewPoint(collisionPoints.tl.x, collisionPoints.tl.y + entity.rect.height - 3)

  collisionPoints.tr = NewPoint(entity.rect.x + entity.rect.width - 1, entity.rect.y)
  collisionPoints.mr = NewPoint(collisionPoints.tr.x, collisionPoints.tr.y + math.floor(entity.rect.height / 2) - 1)
  collisionPoints.br = NewPoint(collisionPoints.tr.x, collisionPoints.tr.y + entity.rect.height - 3)

  collisionPoints.tm = NewPoint(collisionPoints.tl.x + math.floor(entity.rect.width / 2), collisionPoints.tl.y - 2)
  collisionPoints.bm = NewPoint(collisionPoints.tm.x, collisionPoints.tm.y + entity.rect.height - 1)

  entity.collisionPoints = collisionPoints

end


function UpdateEntityPhysics(entity, timeDelta, debug)

  -- Reset all values
  result.x = -1
  result.y = -1
  gridPos.x = 0
  gridPos.y = 0

  -- Calculate the delay between frames as an int

  -- Calculate next x position
  nextPos.x = entity.pos.x + entity.vel.x

  -- Accumulate gravity between each update
  entity.vel.y = entity.vel.y + (gravity * timeDelta)

  -- Make sure we cap the velocity
  if(entity.vel.y > 5) then
    entity.vel.y = 5
  elseif(entity.vel.y < - 5) then
    entity.vel.y = -5
  end

  -- Calculate next y position
  nextPos.y = entity.pos.y + entity.vel.y

  -- Get a local ref to the entity's collision points
  local collisionPoints = entity.collisionPoints

  -- If the entity doesn't have collision points, exit the function
  if(collisionPoints == nil) then
    return
  end

  if(entity.vel.x ~= 0) then

    local dirLetter = entity.flipH and "l" or "r"
    local tests = {
      collisionPoints["b"..dirLetter],
      collisionPoints["m"..dirLetter],
      collisionPoints["t"..dirLetter]
    }

    local flagValue = -1

    for i = 1, #tests do
      if(flagValue < 0) then

        gridPos.x = math.floor((tests[i].x + nextPos.x) / 8)
        gridPos.y = math.floor((tests[i].y + nextPos.y) / 8)

        flagValue = Flag(Repeat(gridPos.x, mapSize.x), gridPos.y)

        if(debug) then
          DebugPhysics(tests[i], gridPos)
        end

      end
    end

    result.x = flagValue

  end

  if(entity.vel.y ~= 0) then

    entity.standing = false

    local dirLetter = entity.vel.y > 0 and "b" or "t"

    local tests = {
      collisionPoints[dirLetter.."l"],
      collisionPoints[dirLetter.."m"],
      collisionPoints[dirLetter.."r"]
    }

    local flagValue = -1

    for i = 1, #tests do
      if(flagValue < 0) then

        gridPos.x = math.floor((tests[i].x + nextPos.x) / 8)
        gridPos.y = math.floor((tests[i].y + nextPos.y + 1) / 8)

        flagValue = Flag(Repeat(gridPos.x, mapSize.x), gridPos.y)
        -- flagValue = Flag(gridPos.x, gridPos.y)

        if(debug) then
          DebugPhysics(tests[i], gridPos)
        end

      end
    end

    result.y = flagValue

  end

  if(entity.onPhysicsUpdate ~= nil) then
    entity.onPhysicsUpdate(nextPos, gridPos, result, collisionPoints)
  end

end

function PhysicsSolidCollision(entity, nextPos, gridPos, collisionPoints, flag)

  flag = flag or 0

  -- If the flag is not solid, save the new x position
  if(result.x == flag) then
    entity.vel.x = 0
    -- TODO calculate how far back to move the entity
    -- local dif = collisionPoints["mr"].x - (gridPos.x * 8)
    nextPos.x = entity.pos.x
    -- else
    --   entity.pos.x = nextPos.x
    -- TODO need to calculate the correct position to shift back to avoid sticking to walls
  end

  if(result.y == flag) then

    -- only set standing when falling down
    if(entity.vel.y > 0) then
      entity.standing = true
      local dif = (collisionPoints["bm"].y + nextPos.y) - (gridPos.y * 8)
      nextPos.y = nextPos.y - dif - 1
    end

    entity.vel.y = 0

  end

end
