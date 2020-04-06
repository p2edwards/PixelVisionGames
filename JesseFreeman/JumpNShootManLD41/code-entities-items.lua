function ConfigureEntityHealth(entity)

  entity.flipH = false
  entity.spriteData = health

  ConfigureCollision(entity, "Enemy", 14, 9, 1, 3)

end

function ConfigureEntityEnergy(entity)

  entity.flipH = false
  entity.spriteData = energy

  ConfigureCollision(entity, "Enemy", 14, 9, 1, 3)

end
