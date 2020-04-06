-- Configure the player
function ConfigureEntityPlayer(entity)

  -- Track the time between collisions
  entity.collisionTime = 0
  entity.collisionDelay = 2
  entity.useWeapon = true

  -- Set up collision
  --TODO need to look into why using negative value for collision offset
  ConfigureCollision(entity, "Player", 12, 22, 6, 4)

  ConfigurePhysicsEntity(entity)

  local states = {
    idle = {
      playeridle1,
      playeridle2
    },
    walk = {
      playerwalk2,
      playerwalk1,
      playerwalk3,
      playerwalk1,
    },
    jump = {
      playerjump,
    },
    fall = {
      playerfall,
    },
    idleGun = {
      playeridlegun1,
      playeridlegun2
    },
    walkGun = {
      playerwalkgun2,
      playerwalkgun1,
      playerwalkgun3,
      playerwalkgun1,
    },
    jumpGun = {
      playerjumpgun,
    },
    fallGun = {
      playerfallgun,
    }
  }

  ConfigureMeterValue(entity, "energy", 10)
  ConfigureMeterValue(entity, "health", 10)

  -- Setup animation
  ConfigureAnimation(entity, {
    playeridle1
  })

  entity.onUpdate = function(timeDelta)

    entity.vel.x = 2

    if( Button(Buttons.B, InputState.Down) == true) then
      if(entity.standing) then
        entity.vel.y = -4
        SpawnEntity("Dust", entity.pos.x+ 14, entity.pos.y + 16)
      end
    end

    -- Apply physics
    UpdateEntityPhysics(entity, timeDelta, false)

    entity.onMeterValueChange = function(type, value)

      if(type == "health" and entity.health <= 0) then

        SpawnEntity("Explosion", entity.pos.x + 4, entity.pos.y + 8)
        entity.remove = true

        GameOver()

      end

      if(type == "energy") then
        entity.useWeapon = entity.energy > 0

        if(entity.useWeapon == false) then
          DisplayMessage("       YOU ARE OUT OF ENERGY", 1)
        end
      end

    end

    entity.collisionTime = entity.collisionTime + timeDelta

    TestCollision(entity, "Enemy")

    -- Change player palette if damaged
    if(entity.collisionTime < entity.collisionDelay) then
      entity.colorOffset = 4 * (math.floor(entity.collisionTime * 10) % 2)
    else
      entity.colorOffset = 0
    end

    if( Button(Buttons.A, InputState.Released) == true) then

      if(GetMeterValue(entity, "energy") > 0) then
        DecreaseMeterValue(entity, "energy", 1)

        SpawnEntity("SmallShot", entity.pos.x + 14, entity.pos.y + 12, entity.flipH)

      end

    end

    if(entity.time == 0 and entity.health > 0) then

      if(score ~= nil) then
        AddScore(1)
      end

    end

  end

  entity.onCollision = function(targetB)

    local value = -1
    local meter = "health"

    if(targetB.type == "PelletShot") then
      targetB.remove = true
    elseif(targetB.type == "SmallSpikeBall") then
      value = -2
      targetB.remove = true
    elseif(targetB.type == "Health") then
      targetB.remove = true
      value = 5
    elseif(targetB.type == "Energy") then
      targetB.remove = true
      meter = "energy"
      value = 5
    end

    if(value < 0) then
      if(entity.collisionTime > entity.collisionDelay) then
        DecreaseMeterValue(entity, meter, math.abs(value))
        entity.collisionTime = 0
      end
    else
      IncreaseMeterValue(entity, meter, value)
    end

  end

  entity.onPhysicsUpdate = function(nextPos, gridPos, result, collisionPoints)

    -- Look to see if the player collides with spikes on the ceiling
    if(result.x == 2 or result.y == 2) then

      if(entity.collisionTime > entity.collisionDelay) then
        DecreaseMeterValue(entity, "health", 100)
      end

    -- Test for player colliding with spikes in the floor gaps
  elseif(result.x == 1 or result.y == 1) then

      if(entity.collisionTime > entity.collisionDelay) then
        DecreaseMeterValue(entity, "health", 100)
      else
        -- Test to see if there was a solid collision
        PhysicsSolidCollision(entity, nextPos, gridPos, collisionPoints, 1)
      end

    -- Test for collision on the ground
  elseif(result.x == 0 or result.y == 0) then

      if(entity.pos.y > 56) then
        -- Test to see if there was a solid collision
        PhysicsSolidCollision(entity, nextPos, gridPos, collisionPoints, 0)
      end

    end

    -- Apply new position to the entity
    entity.pos.x = nextPos.x
    entity.pos.y = nextPos.y

    -- Update animation
    local newState = "idle"
    if(entity.standing) then

      if(math.abs(entity.vel.x) > 0) then
        newState = "walk"
      end

    else

      if(entity.vel.y > 0) then
        newState = "fall"
      elseif(entity.vel.y < 0) then
        newState = "jump"
      end

    end

    if(entity.useWeapon) then
      newState = newState .. "Gun"
    end

    entity.frames = states[newState]

  end

end
