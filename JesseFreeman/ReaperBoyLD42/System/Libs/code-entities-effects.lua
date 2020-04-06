function ConfigureEntityExplosion(entity)

  PlaySound(6, 3)

  entity.onScreen = false
  entity.useScrollPos = false

  -- Setup animation
  ConfigureAnimation(entity, {
    explosion1,
    explosion2,
    explosion3,
    explosion4,
  })

  entity.onUpdate = function(timeDelta)

    if(entity.frame >= #entity.frames) then
      entity.remove = true
    end

  end

end

function ConfigureEntityTombstoneExplosion(entity)

  PlaySound(6, 3)

  entity.onScreen = false
  entity.useScrollPos = false

  -- Setup animation
  ConfigureAnimation(entity, {
    explosion1,
    explosion2,
    explosion3,
    explosion4,
  })

  entity.onUpdate = function(timeDelta)

    if(entity.frame >= #entity.frames) then
      entity.remove = true
    end

    if(entity.remove == true) then

      entity.visible = entity.pos.y < (cloudLayerStartRow + 5) * 8

      -- if(entity.visible) then
      --   DrawSprites(tombstonea.spriteIDs, entity.pos.x + ScrollPosition().x, entity.pos.y + ScrollPosition().y, tombstonea.width, entity.flipH, false, DrawMode.TilemapCache, 0, false, false)
      -- end

      SpawnEntity("Ghost", entity.pos.x - 8, entity.pos.y - 16, entity.flipH)

    end

  end

end

function ConfigureEntityDust(entity)

  PlaySound(4, 3)
  entity.onScreen = false
  entity.useScrollPos = false
  entity.rect.height = 8

  -- Setup animation
  ConfigureAnimation(entity, {
    dust1,
    dust2,
    dust3
  },
.15)

entity.onUpdate = function(timeDelta)

  if(entity.frame >= #entity.frames) then
    entity.remove = true
  end

end

end

function ConfigureEntityGhost(entity)

PlaySound(10, 3)

entity.onScreen = false
entity.useScrollPos = false
entity.removeTime = 0
entity.removeDelay = 1
-- Setup animation
ConfigureAnimation(entity, {
  playerdeath1,
  playerdeath2,
  playerdeath3,
  playerdeath4,
})

entity.onUpdate = function(timeDelta)

  entity.removeTime = entity.removeTime + timeDelta

  if(entity.removeTime > entity.removeDelay or entity.pos.y < 0) then
    entity.remove = true
    activeScene:RespawnPlayer()
    SpawnEntity("Explosion", entity.pos.x + 8, entity.pos.y + 4)
    SpawnEntity("Tombstone", entity.pos.x + 8, entity.pos.y, entity.flipH)
  else
    entity.pos.y = entity.pos.y - 1
  end

  entity.visible = entity.pos.y < (cloudLayerStartRow + 5) * 8

end

end
