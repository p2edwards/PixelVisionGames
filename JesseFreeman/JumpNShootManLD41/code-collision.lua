-- This is used for testing only
local tmpRectA = NewRect()
local tmpRectB = NewRect()

-- Add collision debug color
Color(10, "#FF0000")

function CalculateRect(entity, tmpRect)

  tmpRect = tmpRect or NewRect()

  tmpRect.x = entity.pos.x + entity.rect.x
  tmpRect.y = entity.pos.y + entity.rect.y
  tmpRect.width = entity.rect.width
  tmpRect.height = entity.rect.height

  return tmpRect

end

-- use this to set up a collision entity
function ConfigureCollision(entity, collisionType, width, height, offsetX, offsetY)

  entity.collisionType = collisionType

  entity.rect.x = offsetX or 0
  entity.rect.y = offsetY or 0
  entity.rect.width = width or entity.rect.width
  entity.rect.height = height or entity.rect.height


end

function TestCollision(targetA, collisionType)

  for i = 1, #entities do

    local targetB = entities[i]

    -- Need to make sure the two entities aren't the same
    if(targetA.uid ~= targetB.uid and targetB.rect ~= nil) then

      CollidesWithEntity(targetA, targetB, collisionType)

    end

  end

end

-- Use this for 1 to 1 collision testing
function CollidesWithEntity(targetA, targetB, collisionType)

  if(targetB.rect.height <= 0 or targetB.rect.width <= 0) then
    return
  end

  -- Test to see if the entity is the correct type
  if(targetB.collisionType == collisionType) then

    CalculateRect(targetA, tmpRectA)
    CalculateRect(targetB, tmpRectB)

    -- Check for a collision with each entities rects
    if(tmpRectA.Contains(tmpRectB)) then

      -- Test to see if targetA has a collision callback
      if(targetA.onCollision ~= nil) then
        targetA.onCollision(targetB)
      end

    end

  end

end
