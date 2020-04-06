function ConfigureEntityExplosion(entity)

  PlaySound(6, 3)

  -- Setup animation
  ConfigureAnimation(entity, {
    explosion1,
    explosion2,
    explosion3,
    explosion4,
    explosion5,
    explosion6,
  })

  entity.onUpdate = function(timeDelta)

    if(entity.frame >= #entity.frames) then
      entity.remove = true
    end

  end

end

function ConfigureEntityDust(entity)

  PlaySound(3, 3)

  entity.rect.height = 8

  -- Setup animation
  ConfigureAnimation(entity, {
    dust1,
    dust2,
    dust3,
    dust4
  },
  .15)

  entity.onUpdate = function(timeDelta)

    if(entity.frame >= #entity.frames) then
      entity.remove = true
    end

  end

end
