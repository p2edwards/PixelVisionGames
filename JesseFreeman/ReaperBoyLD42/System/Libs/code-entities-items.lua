function ConfigureEntityFoodA(entity)

  local sprites = {itemfood1, itemfood2, itemfood3, itemfood4, itemfood5}
  local spriteID = math.random(1, #sprites)
  entity.onScreen = false
  entity.useScrollPos = true
  entity.visible = true
  entity.scoreValue = 100
  entity.spriteData = sprites[spriteID]

  ConfigureCollision(entity, "Enemy", 14, 9, 1, 3)

  entity.onUpdate = function(timeDelta)

    entity.visible = entity.pos.y < (cloudLayerStartRow + 5) * 8

  end

end

function ConfigureEntityFoodB(entity)

  local sprites = {itemfood6, itemfood7, itemfood8}
  local spriteID = math.random(1, #sprites)
  entity.onScreen = false
  entity.useScrollPos = true
  entity.visible = true
  entity.scoreValue = 250
  entity.spriteData = sprites[spriteID]

  ConfigureCollision(entity, "Enemy", 14, 9, 1, 3)

  entity.onUpdate = function(timeDelta)

    entity.visible = entity.pos.y < (cloudLayerStartRow + 5) * 8

  end

end

function ConfigureEntityFoodC(entity)

  local sprites = {itemfood9, itemfood10}
  local spriteID = math.random(1, #sprites)
  entity.onScreen = false
  entity.useScrollPos = true
  entity.visible = true
  entity.scoreValue = 500
  entity.spriteData = sprites[spriteID]

  ConfigureCollision(entity, "Enemy", 14, 9, 1, 3)

  entity.onUpdate = function(timeDelta)

    entity.visible = entity.pos.y < (cloudLayerStartRow + 5) * 8

  end

end

function ConfigureEntityFoodD(entity)
  entity.onScreen = false
  entity.useScrollPos = true
  entity.spriteData = locked
  entity.visible = true
  entity.scoreValue = 1000
  entity.spriteData = itemfood11

  ConfigureCollision(entity, "Enemy", 40, 48, 0, 0)

  entity.onUpdate = function(timeDelta)

    entity.visible = entity.pos.y < (cloudLayerStartRow + 5) * 8

  end

end
