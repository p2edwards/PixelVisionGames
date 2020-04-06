LoadScript("code-entity-manager")
LoadScript("code-collision")
LoadScript("code-physics")
LoadScript("code-meter")

function ConfigureEntitySnake(entity)

  entity.speed = NewPoint(1, 0)

  -- Setup animation
  ConfigureAnimation(entity, {snake1, snake2})

  -- Set up collision
  ConfigureCollision(entity, "Enemy", 11, 14, 2, 2)

  ConfigureMeterValue(entity, "health", 1)

  entity.onUpdate = function(timeDelta)

    MoveEntity(entity, timeDelta)

  end

  entity.onMeterValueChange = function(type, value)

    if(type == "health" and value <= 0) then

      SpawnEntity("Explosion", entity.pos.x, entity.pos.y)

      AddScore(50)

      SpawnRandomEntity({"None", "None", "Health", "Energy", "Energy"}, entity.pos.x, entity.pos.y)

      entity.remove = true
    end

  end

end

function ConfigureEntityHardHead(entity)

  entity.speed = NewPoint(1, 0)

  local states = {
    walk = {
      hardheadwalk2,
      hardheadwalk1,
      hardheadwalk3,
      hardheadwalk1,
    },
    jump = {
      hardheadfall,
    },
    fall = {
      hardheadjump,
    }
  }

  -- Setup animation
  ConfigureAnimation( entity, states.walk )

  -- Set up collision
  ConfigureCollision(entity, "Enemy", 11, 15, 2, 2)

  ConfigurePhysicsEntity(entity)

  -- Add health
  ConfigureMeterValue(entity, "health", 2)

  entity.jumpTime = math.random(0, 1)
  entity.jumpDelay = 1

  entity.onUpdate = function(timeDelta)

    entity.jumpTime = entity.jumpTime + timeDelta

    if(entity.jumpTime > entity.jumpDelay) then

      if(entity .standing) then

        entity.vel.y = -5
        entity.jumpTime = 0
        PlaySound(7, 3)
      end

    end

    entity.vel.x = -1

    -- Apply physics
    UpdateEntityPhysics(entity, timeDelta, false)

  end

  entity.onMeterValueChange = function(type, value)

    if(type == "health" and value <= 0) then

      SpawnEntity("Explosion", entity.pos.x, entity.pos.y)

      AddScore(100)

      SpawnRandomEntity({"None", "Health", "Energy", "Energy", "Energy"}, entity.pos.x, entity.pos.y)

      entity.remove = true
    end

  end

  entity.onPhysicsUpdate = function(nextPos, gridPos, result, collisionPoints)

    if(result.y == 0 or result.y == 1) then

      -- Test to see if there was a solid collision
      PhysicsSolidCollision(entity, nextPos, gridPos, collisionPoints, result.y)

    end
    -- end

    -- Apply new position to the entity
    entity.pos.x = nextPos.x
    entity.pos.y = nextPos.y

    -- Update animation
    local newState = "walk"

    if(entity.vel.y > 0) then
      newState = "fall"
    elseif(entity.vel.y < 0) then
      newState = "jump"
    end

    entity.frames = states[newState]

  end

end

function ConfigureEntityTurret(entity)

  entity.shootFlag = false

  -- Build base animation
  local frames = { }

  -- Add hidden frames
  for i = 1, 10 do
    table.insert(frames, 1, turret1)
  end

  -- Add visible frames
  for i = 1, 5 do
    table.insert(frames, turret2)
  end

  -- Setup animation
  ConfigureAnimation( entity, frames )

  -- Pick a random frame to start on
  entity.frame = math.random(0, 2) * 5

  -- Set up collision
  ConfigureCollision(entity, "Enemy", 12, 6, 2, 10)

  entity.onUpdate = function(timeDelta)

    if(entity.frame == 11 and entity.shootFlag == false) then

      entity.shootFlag = true

      local bullet1 = SpawnEntity("PelletShot", entity.pos.x - 4, entity.pos.y + 4, true)
      if(bullet1 ~= nil) then
        bullet1.speed.x = 1
        bullet1.speed.y = 1
      end

      local bullet2 = SpawnEntity("PelletShot", entity.pos.x + 4, entity.pos.y, false)
      if(bullet2 ~= nil) then
        bullet2.speed.x = 0
        bullet2.speed.y = 1
      end

      local bullet3 = SpawnEntity("PelletShot", entity.pos.x + 12, entity.pos.y + 4, false)
      if(bullet3 ~= nil) then
        bullet3.speed.x = 1
        bullet3.speed.y = 1
      end

    elseif(entity.frame == 1) then

      entity.shootFlag = false

    end

  end

end

function ConfigureEntityHiddenTurret(entity)

  entity.shootFlag = false

  -- Build base animation
  local frames = {
    hiddenturret2,
    hiddenturret3
  }

  -- Add hidden frames
  for i = 1, 15 do
    table.insert(frames, 1, hiddenturret1)
  end

  -- Add visible frames
  for i = 1, 6 do
    table.insert(frames, hiddenturret3)
  end

  -- Add frame to hide
  table.insert(frames, hiddenturret2)

  -- Setup animation
  ConfigureAnimation( entity, frames )

  -- Setup health
  ConfigureMeterValue(entity, "health", 5)

  -- Pick a random frame to start on
  entity.frame = math.random(0, 2) * 8

  -- Set up collision
  ConfigureCollision(entity, "Enemy", 14, 14, 1, 3)

  -- Force the rect to be hidden
  entity.rect.height = 0

  entity.onUpdate = function(timeDelta)

    if(entity.frame == 17 and entity.shootFlag == false) then

      entity.shootFlag = true

      SpawnEntity("SmallSpikeBall", entity.pos.x, entity.pos.y, entity.flipH)

      entity.rect.height = 14

    elseif(entity.frame == #entity.frames) then

      entity.shootFlag = false

      entity.rect.height = 0

    end

    -- DebugCollision(entity)

  end

  entity.onMeterValueChange = function(type, value)

    if(type == "health" and value <= 0) then

      SpawnEntity("Explosion", entity.pos.x, entity.pos.y)

      AddScore(500)

      SpawnRandomEntity({"None", "Health", "Energy", "Energy", "Energy"}, entity.pos.x, entity.pos.y)

      entity.remove = true
    end

  end


end
