function ConfigureEntityPelletShot(entity)

  entity.speed = NewPoint(1, 0)
  entity.spriteData = pelletshot

  PlaySound(8, 3)

  ConfigureCollision(entity, "Enemy", 6, 6, 1, 1)

  entity.onUpdate = function(timeDelta)

    MoveEntity(entity, timeDelta)

    if( Flag(math.floor(entity.pos.x / 8), math.floor(entity.pos.y / 8)) == 0) then
      entity.remove = true
    end

  end

end

function ConfigureEntitySmallSpikeBall(entity)

  entity.speed = NewPoint(1, 0)

  PlaySound(8, 3)

  ConfigureCollision(entity, "Enemy", 8, 8, 4, 4)

  -- Setup animation
  ConfigureAnimation(
    entity,
    {
      spikeballsmall1,
      spikeballsmall2
    }
  )

  entity.onUpdate = function(timeDelta)

    MoveEntity(entity, timeDelta)

    if( Flag(math.floor(entity.pos.x / 8), math.floor(entity.pos.y / 8)) == 0) then
      entity.remove = true
    end

  end

end

function ConfigureEntitySmallShot(entity)

  entity.speed = NewPoint(3, 0)
  entity.rect.width = 8
  entity.rect.height = 8
  entity.attackValue = 1

  PlaySound(4, 3)

  -- Setup animation
  ConfigureAnimation(
    entity,
    {
      smallshot1,
      smallshot2,
      smallshot3,
      smallshot4
    }
  )

  -- Set up collision and use default rect for value
  ConfigureCollision(entity, "Bullet")

  entity.onUpdate = function(timeDelta)

    MoveEntity(entity, timeDelta)

    if( Flag(math.floor(entity.pos.x / 8), math.floor(entity.pos.y / 8)) == 0) then
      entity.remove = true
    else
      TestCollision(entity, "Enemy")
    end

  end

  entity.onCollision = function(targetB)

    -- Ignore collision when hitting health or energy pickup
    if(targetB.type == "Health" or targetB.type == "Energy") then
      return
    elseif(targetB.type == "SmallSpikeBall") then
      targetB.remove = true
    end

    -- If the bullet collides, remove it from the screen
    entity.remove = true

    DecreaseMeterValue(targetB, "health", entity.attackValue)

  end

end
