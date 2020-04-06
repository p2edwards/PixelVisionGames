LoadScript("code-entity-manager")
LoadScript("code-collision")
LoadScript("code-physics")
LoadScript("code-meter")

function ConfigureEntityExit(entity)
  entity.onScreen = false
  entity.useScrollPos = true
  entity.spriteData = locked
  entity.visible = true
  entity.drawMode = DrawMode.SpriteBelow
  entity.locked = true

  entity.onUpdate = function(timeDelta)

    if(enemyTotal <= 0) then

      entity.spriteData = exit

      if(entity.locked == true) then
        entity.locked = false
        SpawnEntity("Portal", entity.pos.x + 8, entity.pos.y + 16)
        SpawnEntity("ExitSign", entity.pos.x + 8, entity.pos.y - 16)
        for i = 1, 6 do
          SpawnEntity(math.random(0, 10) > 5 and "Explosion" or "Dust", entity.pos.x + math.random(8, 24), entity.pos.y + math.random(8, 24), math.random(0, 10) > 5)
        end

      end
    end

    -- MoveEntity(entity, timeDelta)

    entity.visible = entity.pos.y < (cloudLayerStartRow + 5) * 8

  end

end

function ConfigureEntityPortal(entity)
  entity.visible = true
  entity.onScreen = false
  entity.useScrollPos = true
  entity.drawMode = DrawMode.SpriteBelow

  ConfigureCollision(entity, "Enemy", 16, 16, 0, 0)

  -- Setup animation
  ConfigureAnimation(entity, {portal1, portal2, portal3, portal4})

  entity.onUpdate = function(timeDelta)

    entity.visible = entity.pos.y < (cloudLayerStartRow + 5) * 8

  end

end

function ConfigureEntityExitSign (entity)

  entity.visible = true
  entity.onScreen = false
  entity.useScrollPos = true
  entity.drawMode = DrawMode.SpriteBelow

  -- Setup animation
  ConfigureAnimation(entity, {in1, in2, in3, in4})

  entity.onUpdate = function(timeDelta)

    entity.visible = entity.pos.y < (cloudLayerStartRow + 5) * 8

  end

end

function ConfigureEntitySpike(entity)

  entity.visible = true
  entity.onScreen = false
  entity.useScrollPos = true
  entity.spriteData = spike1
  entity.hurtPlayer = true

  entity.drawMode = DrawMode.SpriteBelow

  ConfigureCollision(entity, "Enemy", 16, 10, 0, 8)

  -- TODO only animate after a longer delay
  -- Setup animation
  -- ConfigureAnimation(entity, {spike1, spike2, spike3, spike4})

  -- entity.time = math.random(0, 2)

  entity.onUpdate = function(timeDelta)

    entity.visible = entity.pos.y < (cloudLayerStartRow + 5) * 8

  end

end

function ConfigureEntityCloudA(entity)

  entity.speed = NewPoint(1, 0)
  entity.onScreen = false
  entity.useScrollPos = true
  entity.spriteData = clouda
  entity.visible = true
  entity.drawMode = DrawMode.SpriteBelow

  entity.onUpdate = function(timeDelta)

    MoveEntity(entity, timeDelta)

    entity.visible = entity.pos.y < (cloudLayerStartRow + 5) * 8

  end

end

function ConfigureEntityCloudB(entity)

  entity.speed = NewPoint(1, 0)
  entity.onScreen = false
  entity.useScrollPos = true
  entity.spriteData = cloudb
  entity.visible = true
  entity.drawMode = DrawMode.SpriteBelow

  entity.onUpdate = function(timeDelta)

    MoveEntity(entity, timeDelta)

    entity.visible = entity.pos.y < (cloudLayerStartRow + 5) * 8

  end

end

function ConfigureEntityTombstone(entity)
  entity.visible = true
  entity.onScreen = false
  entity.useScrollPos = true

  entity.spriteData = tombstoneb
  -- -- Setup animation
  -- ConfigureAnimation(entity, {penguinwalk1, penguinwalk2, penguinwalk3, penguinwalk4})

  -- Set up collision
  ConfigureCollision(entity, "Tombstone", 16, 16, 0, 2)

  ConfigurePhysicsEntity(entity)

  -- ConfigureMeterValue(entity, "health", 1)

  entity.onUpdate = function(timeDelta)

    UpdateEntityPhysics(entity, timeDelta, false)

  end


  entity.onPhysicsUpdate = function(nextPos, gridPos, results, collisionPoints)

    local result = { x = false, y = false}

    if(entity.vel.y > 0) then

      -- Falling
      result.x = (results["mr"] == 0 or results["ml"] == 0)

      if(result.x == false) then
        result.y = (results["bm"] == 0 and (results["bl"] == 0 or results["br"] == 0))
      end

    end

    PhysicsSolidCollision(entity, nextPos, gridPos, collisionPoints, result)

    -- Apply new position to the entity
    entity.pos.x = nextPos.x
    entity.pos.y = nextPos.y

    if(entity.pos.y > Display().y) then
      entity.remove = true
    end

    entity.visible = entity.pos.y < (cloudLayerStartRow + 5) * 8

    if(entity.standing == true) then
      entity.remove = true

      PlaySound(7, 3)

      if(entity.visible) then
        DrawSprites(tombstonea.spriteIDs, entity.pos.x + ScrollPosition().x, entity.pos.y + ScrollPosition().y, tombstonea.width, entity.flipH, false, DrawMode.TilemapCache, 0, false, false)
      end

    end


  end

end

function ConfigureEntityPenguin(entity)

  entity.speed = NewPoint(1, 0)
  entity.visible = true
  entity.onScreen = false
  entity.useScrollPos = true

  -- Setup animation
  ConfigureAnimation(entity, {penguinwalk1, penguinwalk2, penguinwalk3, penguinwalk4})

  -- Set up collision
  ConfigureCollision(entity, "Enemy", 16, 16, 0, 2)

  ConfigurePhysicsEntity(entity)

  ConfigureMeterValue(entity, "health", 1)

  entity.onUpdate = function(timeDelta)

    entity.vel.x = entity.flipH and - 1 or 1

    -- MoveEntity(entity, timeDelta)
    -- Apply physics
    UpdateEntityPhysics(entity, timeDelta, false)
    -- entity.pos.x = Repeat(entity.pos.x, Display().x)
    -- entity.pos.y = Repeat(entity.pos.y, Display().y)

  end

  entity.onMeterValueChange = function(type, value)

    if(type == "health" and value <= 0) then

      SpawnEntity("Explosion", entity.pos.x, entity.pos.y)

      AddScore(50)

      SpawnRandomEntity({"None", "None", "None", "None", "None", "FoodA", "FoodA", "FoodB"}, entity.pos.x, entity.pos.y)

      entity.remove = true

      PlaySound(6, 3)

      activeScene:RemoveEnemey()

    end

  end

  entity.onPhysicsUpdate = function(nextPos, gridPos, results, collisionPoints)


    local result = { x = false, y = false}

    if(entity.vel.y > 0) then

      -- Falling
      result.x = (results["mr"] == 0 or results["ml"] == 0)

      if(result.x == false) then
        result.y = (results["bm"] == 0 and (results["bl"] == 0 or results["br"] == 0))
      end

    end

    PhysicsSolidCollision(entity, nextPos, gridPos, collisionPoints, result)

    -- if(newState == "walk") then
    local dir = entity.flipH and "l" or "r"
    if(results["b"..dir] == -1) then
      entity.flipH = not entity.flipH
    end
    -- end
    --
    -- if(result.y == 0) then
    --
    --   -- Test to see if there was a solid collision
    --   PhysicsSolidCollision(entity, nextPos, gridPos, collisionPoints, result.y)
    -- elseif(result.y == -1) then
    --
    --   entity.flipH = not entity.flipH
    -- end
    -- end

    -- Apply new position to the entity
    entity.pos.x = Repeat(nextPos.x, Display().x)
    entity.pos.y = Repeat(nextPos.y, Display().y)

    -- Update animation
    -- local newState = "walk"

    -- if(entity.vel.y > 0) then
    --   newState = "fall"
    -- elseif(entity.vel.y < 0) then
    --   newState = "jump"
    -- end

    -- entity.frames = states[newState]

    entity.visible = entity.pos.y < (cloudLayerStartRow + 5) * 8



  end

end

function ConfigureEntityLadybug(entity)

  entity.speed = NewPoint(1, 0)
  entity.visible = true
  entity.onScreen = false
  entity.useScrollPos = true
  entity.hurtPlayer = false
  entity.jumpTime = math.random(0, 2)
  entity.jumpDelay = 2

  local states = {
    walk = {
      ladybugwalk1,
      ladybugwalk2,
      ladybugwalk3,
      ladybugwalk4,
    },
    fly = {
      ladybugfly1,
      ladybugfly2,
      ladybugfly3,
      ladybugfly4,
    }
  }

  -- Setup animation
  ConfigureAnimation(entity, states.walk)

  -- Set up collision
  ConfigureCollision(entity, "Enemy", 16, 16, 0, 2)

  ConfigurePhysicsEntity(entity)

  ConfigureMeterValue(entity, "health", 1)

  entity.onUpdate = function(timeDelta)

    entity.jumpTime = entity.jumpTime + timeDelta

    if(entity.jumpTime > entity.jumpDelay) then
      --   --
      entity.vel.x = 0
      entity.vel.y = -5
      entity.jumpTime = 0
      --   --   PlaySound(7, 3)
      --   --
    elseif(entity.standing) then
      --   -- else
      --   --
      entity.vel.x = entity.flipH and - 1 or 1
      --   --
      -- else
      --   entity.vel.x = 0
    end

    -- Apply physics
    UpdateEntityPhysics(entity, timeDelta, false)

  end


  entity.onMeterValueChange = function(type, value)

    if(type == "health" and value <= 0) then

      SpawnEntity("Explosion", entity.pos.x, entity.pos.y)

      AddScore(200)

      SpawnRandomEntity({"None", "None", "None", "None", "FoodB", "FoodB", "FoodC"}, entity.pos.x, entity.pos.y)

      entity.remove = true

      PlaySound(6, 3)

      activeScene:RemoveEnemey()

    end

  end

  entity.onPhysicsUpdate = function(nextPos, gridPos, result, collisionPoints)

    local result = { x = false, y = false}

    if(entity.vel.y > 0) then

      -- Falling
      result.x = (results["mr"] == 0 or results["ml"] == 0)

      if(result.x == false) then
        result.y = (results["bm"] == 0 and (results["bl"] == 0 or results["br"] == 0))
      end

      -- if(result.y == false) then
      --   entity.flipH = not entity.flipH
      -- end

    elseif(entity.vel.y < 0) then

      result.x = (results["mr"] == 0 or results["ml"] == 0)

      if(result.x == false) then
        -- Jumping
        result.y = (results["tm"] == 0 and (results["tl"] == 0 or results["tr"] == 0))
      end
    end

    PhysicsSolidCollision(entity, nextPos, gridPos, collisionPoints, result)



    -- end

    -- Apply new position to the entity
    entity.pos.x = Repeat(nextPos.x, Display().x)
    entity.pos.y = Repeat(nextPos.y, Display().y)

    entity.visible = entity.pos.y < (cloudLayerStartRow + 5) * 8

    -- Update animation
    local newState = "walk"
    entity.hurtPlayer = false

    if(entity.vel.y > 0) then
      newState = "fly"
      entity.gravity = 2
      entity.hurtPlayer = true
    elseif(entity.vel.y < 0) then
      entity.gravity = 20
      newState = "fly"
      entity.hurtPlayer = true
    end

    if(newState == "walk") then
      local dir = entity.flipH and "l" or "r"
      if(results["b"..dir] == -1) then
        entity.flipH = not entity.flipH
      end
    end
    --
    -- if(entity.vel.y > 0 or entity.vel.y < 0) then
    --   newState = "fly"
    -- end

    entity.frames = states[newState]

  end

end

function ConfigureEntityToad(entity)

  entity.speed = NewPoint(1, 0)
  entity.visible = true
  entity.onScreen = false
  entity.useScrollPos = true
  -- entity.hurtPlayer = false
  entity.jumpTime = math.random(0, 2)
  entity.jumpDelay = 2

  local states = {
    walk = {
      toadframe1,
    },
    jump = {
      toadframe2,
    },
    fall = {
      toadframe3,
    }
  }

  -- Setup animation
  ConfigureAnimation(entity, states.walk)

  -- Set up collision
  ConfigureCollision(entity, "Enemy", 16, 16, 0, 2)

  ConfigurePhysicsEntity(entity)

  ConfigureMeterValue(entity, "health", 1)

  entity.onUpdate = function(timeDelta)

    entity.jumpTime = entity.jumpTime + timeDelta

    if(entity.jumpTime > entity.jumpDelay and entity.standing) then
      --   --
      entity.vel.x = 1
      entity.vel.y = -5
      entity.jumpTime = 0
      --   --   PlaySound(7, 3)
      --   --
    elseif(entity.standing) then
      --   -- else
      --   --
      entity.vel.x = 0
      --   --
      -- else
      --   entity.vel.x = 0
    end

    -- Apply physics
    UpdateEntityPhysics(entity, timeDelta, false)

  end


  entity.onMeterValueChange = function(type, value)

    if(type == "health" and value <= 0) then

      SpawnEntity("Explosion", entity.pos.x, entity.pos.y)

      AddScore(100)

      SpawnRandomEntity({"None", "None", "None", "None", "FoodA", "FoodB", "FoodB"}, entity.pos.x, entity.pos.y)

      entity.remove = true

      PlaySound(6, 3)

      activeScene:RemoveEnemey()

    end

  end

  entity.onPhysicsUpdate = function(nextPos, gridPos, result, collisionPoints)

    local result = { x = false, y = false}

    if(entity.vel.y > 0) then

      -- Falling
      result.x = (results["mr"] == 0 or results["ml"] == 0)

      if(result.x == false) then
        result.y = (results["bm"] == 0 and (results["bl"] == 0 or results["br"] == 0))
      end

      -- if(result.y == false) then
      --   entity.flipH = not entity.flipH
      -- end

    elseif(entity.vel.y < 0) then

      result.x = (results["mr"] == 0 or results["ml"] == 0)

      if(result.x == false) then
        -- Jumping
        result.y = (results["tm"] == 0 and (results["tl"] == 0 or results["tr"] == 0))
      end
    end

    PhysicsSolidCollision(entity, nextPos, gridPos, collisionPoints, result)

    -- end

    -- Apply new position to the entity
    entity.pos.x = Repeat(nextPos.x, Display().x)
    entity.pos.y = Repeat(nextPos.y, Display().y)

    entity.visible = entity.pos.y < (cloudLayerStartRow + 5) * 8

    -- Update animation
    local newState = "walk"
    -- entity.hurtPlayer = false

    if(entity.vel.y > 0) then
      newState = "fall"
      entity.jumpTime = 0
      -- entity.gravity = 2
      -- entity.hurtPlayer = true
    elseif(entity.vel.y < 0) then
      -- entity.gravity = 20
      newState = "jump"
      entity.jumpTime = 0
      -- entity.hurtPlayer = true
    end

    -- if(newState == "walk") then
    --   local dir = entity.flipH and "l" or "r"
    --   if(results["b"..dir] == -1) then
    --     entity.flipH = not entity.flipH
    --   end
    -- end
    --
    -- if(entity.vel.y > 0 or entity.vel.y < 0) then
    --   newState = "fly"
    -- end

    entity.frames = states[newState]

  end

end
-- debug = true
function ConfigureEntityBoss(entity)

  entity.speed = NewPoint(1, 0)
  entity.visible = true
  entity.onScreen = false
  entity.useScrollPos = true
  entity.drawMode = DrawMode.SpriteBelow

  -- Setup animation
  ConfigureAnimation(entity, {bossfront1, bossfront2, bossfront3, bossfront4})

  -- Set up collision
  ConfigureCollision(entity, "Enemy", 72, 64, 4, 10)

  ConfigurePhysicsEntity(entity)

  ConfigureMeterValue(entity, "health", 4)

  entity.onUpdate = function(timeDelta)

    entity.vel.x = entity.flipH and - 1 or 1

    -- MoveEntity(entity, timeDelta)
    -- Apply physics
    UpdateEntityPhysics(entity, timeDelta, false)
    -- entity.pos.x = Repeat(entity.pos.x, Display().x)
    -- entity.pos.y = Repeat(entity.pos.y, Display().y)

  end

  entity.onMeterValueChange = function(type, value)

    if(type == "health") then

      activeScene:RemoveEnemey()

      PlaySound(6, 3)

      print("Meter Change", value)

      SpawnEntity("Explosion", entity.pos.x, entity.pos.y)

      if(value <= 0) then

        -- TODO need explosion animation

        for i = 1, 10 do
          SpawnEntity("Explosion", entity.pos.x + math.random(16, 62), entity.pos.y + math.random(16, 48))
        end

        AddScore(500)

        SpawnEntity("FoodD", entity.pos.x + 16, entity.pos.y + 24)

        entity.remove = true

      end


    end

  end

  entity.onPhysicsUpdate = function(nextPos, gridPos, results, collisionPoints)


    local result = { x = false, y = false}

    if(entity.vel.y > 0) then

      -- Falling
      result.x = (results["mr"] == 0 or results["ml"] == 0)

      if(result.x == false) then
        result.y = (results["bm"] == 0 and (results["bl"] == 0 or results["br"] == 0))
      end

    end

    PhysicsSolidCollision(entity, nextPos, gridPos, collisionPoints, result)

    -- if(newState == "walk") then
    local dir = entity.flipH and "l" or "r"
    if(results["b"..dir] == -1) then
      entity.flipH = not entity.flipH
    end
    -- end
    --
    -- if(result.y == 0) then
    --
    --   -- Test to see if there was a solid collision
    --   PhysicsSolidCollision(entity, nextPos, gridPos, collisionPoints, result.y)
    -- elseif(result.y == -1) then
    --
    --   entity.flipH = not entity.flipH
    -- end
    -- end

    -- Apply new position to the entity
    entity.pos.x = Repeat(nextPos.x, Display().x)
    entity.pos.y = Repeat(nextPos.y, Display().y)

    -- Update animation
    -- local newState = "walk"

    -- if(entity.vel.y > 0) then
    --   newState = "fall"
    -- elseif(entity.vel.y < 0) then
    --   newState = "jump"
    -- end

    -- entity.frames = states[newState]

    entity.visible = entity.pos.y < (cloudLayerStartRow + 5) * 8



  end

end
