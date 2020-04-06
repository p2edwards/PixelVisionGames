-- debug = true
-- Configure the player
function ConfigureEntityPlayer(entity)

  -- Track the time between collisions
  entity.collisionTime = 0
  entity.collisionDelay = 2
  entity.useWeapon = false
  entity.onScreen = false
  entity.useScrollPos = true
  entity.visible = true
  entity.attackMultiplier = 0
  entity.loop = 0
  entity.lastState = "none"
  -- entity.maxFallVel = 8
  -- entity.startMaxFallVel = 8
  -- entity.capMaxFallVel = 10
  entity.maxAttackMultiplier = 4
  entity.drawMode = DrawMode.UI
  entity.loopTime = 0
  entity.loopDelay = 1

  -- Set up collision
  --TODO need to look into why using negative value for collision offset
  ConfigureCollision(entity, "Player", 12, 16, 2, 2)

  ConfigurePhysicsEntity(entity)

  ResetPlayerPhysics(entity)

  local states = {
    idle = {
      playerstand
    },
    walk = {
      playerwalk1,
      playerwalk2,
      playerwalk3,
      playerwalk4,
    },
    jump = {
      playerjump,
    },
    fall = {
      playerfall,
    },
    -- idleGun = {
    --   playeridlegun1,
    --   playeridlegun2
    -- },
    -- walkGun = {
    --   playerwalkgun2,
    --   playerwalkgun1,
    --   playerwalkgun3,
    --   playerwalkgun1,
    -- },
    -- jumpGun = {
    --   playerjumpgun,
    -- },
    -- fallGun = {
    --   playerfallgun,
    -- }
  }

  -- ConfigureMeterValue(entity, "energy", 10)
  ConfigureMeterValue(entity, "health", 1)

  -- Setup animation
  ConfigureAnimation(entity, {
    playerstand
  })

  entity.onUpdate = function(timeDelta)

    if( Button(Buttons.Right, InputState.Down) == true) then
      entity.vel.x = 1
      entity.flipH = false
    elseif( Button(Buttons.Left, InputState.Down) == true) then
      entity.vel.x = -1
      entity.flipH = true
    else
      entity.vel.x = 0
    end

    if( Button(Buttons.A, InputState.Down) == true or Button(Buttons.B, InputState.Down) == true) then
      if(entity.standing) then
        entity.vel.y = -5
        SpawnEntity("Dust", entity.pos.x + 2, entity.pos.y + 8, entity.flipH)
      end
    end

    -- Apply physics
    UpdateEntityPhysics(entity, timeDelta, false)

    entity.collisionTime = entity.collisionTime + timeDelta

    TestCollision(entity, "Enemy")

    if(entity.time == 0 and entity.health > 0) then

      if(score ~= nil) then
        AddScore(1)
      end

    end

    if(entity.loop > 1) then

      entity.loopTime = entity.loopTime + timeDelta

      if(entity.loopTime > entity.loopDelay) then

        entity.loopTime = 0

        local sfxID = 11

        if(entity.loop > 7) then
          sfxID = 13
        elseif(entity.loop > 3) then
          sfxID = 12
        end

        PlaySound(sfxID, 3)
      end


    end

  end

  entity.onMeterValueChange = function(type, value)

    if(type == "health" and entity.health <= 0) then

      SpawnEntity("TombstoneExplosion", entity.pos.x, entity.pos.y, entity.flipH)
      entity.remove = true

      -- GameOver()

    end

    -- if(type == "energy") then
    --   entity.useWeapon = entity.energy > 0
    --
    --   if(entity.useWeapon == false) then
    --     DisplayMessage("       YOU ARE OUT OF ENERGY", 1)
    --   end
    -- end

  end

  entity.onCollision = function(targetB)

    local value = -1
    local meter = "health"


    --
    -- if(targetB.type == "PelletShot") then
    --   targetB.remove = true
    -- elseif(targetB.type == "SmallSpikeBall") then
    --   value = -2
    --   targetB.remove = true
    -- elseif(targetB.type == "Health") then
    --   targetB.remove = true
    --   value = 5
    -- elseif(targetB.type == "Energy") then
    --   targetB.remove = true
    --   meter = "energy"
    --   value = 5
    -- end

    if(targetB.type == "Portal") then
      activeScene:OnLevelComplete()
      value = 0
      entity.remove = true
      PlaySound(14, 3)
      return
    elseif(targetB.type == "FoodA" or targetB.type == "FoodB" or targetB.type == "FoodC" or targetB.type == "FoodD") then

      value = 0

      PlaySound(15, 3)

      AddScore(targetB.scoreValue or 10)
      targetB.remove = true

    end

    if(value < 0) then
      -- if(entity.collisionTime > entity.collisionDelay) then

      if(targetB.collisionType == "Enemy") then

        -- print("Hit enemy", entity.attackMultiplier)

        if(entity.pos.y < targetB.pos.y and targetB.hurtPlayer ~= true) then



          DecreaseMeterValue(targetB, meter, math.abs(value) * entity.attackMultiplier)

          if(entity.attackMultiplier > 0) then
            enemyMultiplier = enemyMultiplier + 1
          end

          entity.collisionTime = 0

          local vel = NewPoint(0, - 5)

          -- Reset attack if hitting boss
          if(targetB.type == "Boss") then
            --
            entity.attackMultiplier = 0

            vel.y = -7
            --
          end
          PlaySound(9, 3)

          ResetPlayerPhysics(entity, vel.x, vel.y)

        else
          DecreaseMeterValue(entity, meter, math.abs(value))
          entity.collisionTime = 0
          return
        end

      end

      -- end


    elseif(value > 0) then
      IncreaseMeterValue(entity, meter, value)
    end

  end
  --
  -- entity.onRemove = function()
  --   print("remove player")
  -- end

  -- DebugCollision(entity)

  entity.resetVel = function()

  end

  entity.onPhysicsUpdate = function(nextPos, gridPos, results, collisionPoints)


    local result = { x = false, y = false}

    local lastVelY = entity.vel.y

    if(entity.vel.y > 0) then


      -- Falling
      result.x = (results["mr"] == 0 or results["ml"] == 0)

      if(result.x == false) then
        result.y = (results["bm"] == 0 and (results["bl"] == 0 or results["br"] == 0))
      end

    elseif(entity.vel.y < 0) then

      result.x = (results["mr"] == 0 or results["ml"] == 0)

      if(result.x == false) then
        -- Jumping
        result.y = (results["tm"] == 0 and (results["tl"] == 0 or results["tr"] == 0))
      end
    end

    PhysicsSolidCollision(entity, nextPos, gridPos, collisionPoints, result)

    if(entity.lastState == "fall" and entity.standing) then


      -- print("Landing", lastVelY)

      if(entity.loop >= 8) then
        DecreaseMeterValue(entity, "health", 1)
        PlaySound(8, 3)
      else
        PlaySound(7, 3)
      end

      -- Reset attack and loop when hitting ground
      -- entity.attackMultiplier = 0


      ResetPlayerPhysics(entity, 0, lastVelY <= 5 and 0 or - math.floor(lastVelY / 2))

    end


    if(nextPos.y >= Display().y - 1) then

      entity.loop = entity.loop + 1

      -- PlaySound(11, 3)

      entity.attackMultiplier = 1--entity.attackMultiplier + 1

      entity.maxFallVel = entity.maxFallVel + 1

      if(entity.maxFallVel > 8) then
        entity.maxFallVel = 8
      end

      -- print("Loop", entity.loop, entity.vel.y)


      -- if(entity.vel.y > entity.maxFallVel) then
      --   entity.vel.y = entity.maxFallVel
      -- end
      -- if(entity.attackMultiplier > entity.maxAttackMultiplier) then
      --   entity.attackMultiplier = entity.maxAttackMultiplier
      -- end

      -- entity.maxFallVel = entity.maxFallVel + 1
      --
      -- if(entity.maxFallVel > entity.capMaxFallVel) then
      --   entity.maxFallVel = entity.capMaxFallVel
      -- end

    end
    -- Apply new position to the entity
    entity.pos.x = Repeat(nextPos.x, Display().x)
    entity.pos.y = Repeat(nextPos.y, Display().y)

    -- Update animation
    local newState = "idle"
    if(entity.standing) then


      enemyMultiplier = 1
      entity.attackMultiplier = 0
      entity.loop = 0

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



    -- if(entity.useWeapon) then
    --   newState = newState .. "Gun"
    -- end

    entity.frames = states[newState]

    entity.visible = entity.pos.y < (cloudLayerStartRow + 5) * 8

    entity.lastState = newState

  end

end

function ResetPlayerPhysics(entity, velX, velY)

  velX = velX or 0
  velY = velY or 0

  entity.vel.x = velX-- * (entity.flipH and - 1 or 1)
  entity.vel.y = velY-- + entity.maxFallVel * .25

  entity.maxFallVel = 5
  entity.loop = 0
  -- entity.maxFallVel = entity.startMaxFallVel

end
