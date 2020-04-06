local meterSize = 4
local valuePerSlot = 4
local maxValue = meterSize * valuePerSlot

function ConfigureMeterValue(entity, type, total, value)

  entity[type] = value or total
  entity[type .. "Total"] = total

  -- We set the percent to -1 so we can force invalidation when drawing the meeter
  entity[type .. "Percent"] = -1

end

function GetMeterValue(entity, type)

  return entity[type]

end

function DecreaseMeterValue(entity, type, value)

  if(entity[type] ~= nil) then

    local newValue = entity[type] - value

    if(entity[type] ~= newValue) then

      entity[type] = newValue

      MeterCallback(entity, type)
    end

  end

end

function IncreaseMeterValue(entity, type, value)

  if(entity[type] ~= nil) then
    -- Increase health but clamp it so it can't go above or below the range
    entity[type] = Clamp(entity[type] + value, 0, entity[type .. "Total"])
    MeterCallback(type, value)
  end
end

function MeterCallback(entity, type)

  if(entity.onMeterValueChange ~= nil) then
    entity.onMeterValueChange(type, entity[type])
  end

end

function UpdateMeterBar(x, y, entity, type)

  -- Calculate the new percent
  local percent = entity[type] / entity[type .. "Total"]

  if(entity[type .. "Percent"] ~= percent) then
    -- Save the new percent
    entity[type .. "Percent"] = percent

    DrawMeterBar(x, y, type, percent)
  end

end

function DrawMeterBar(x, y, type, percent)

  percent = percent or 0

  local value = math.floor(maxValue * percent)

  local nextX = x

  local meterSprites = {
    "meterleft" .. type
  }

  local slotValue = 0

  for i = 0, maxValue - 1 do

    if(i < value) then

      slotValue = slotValue + 1

    end

    --
    if(i % valuePerSlot == valuePerSlot - 1) then

      table.insert(meterSprites, "metermiddle" .. slotValue)

      slotValue = 0

    end

  end

  table.insert(meterSprites, "meterright")

  for i = 1, #meterSprites do

    local spriteName = meterSprites[i]

    -- Draw meter to the display
    local spriteData = _G[spriteName]

    if(spriteData ~= nil) then
      DrawSprites(spriteData.spriteIDs, nextX, y, spriteData.width, false, false, DrawMode.TilemapCache, 0, false, false)
      nextX = nextX + spriteData.width * 8
    end

  end



end
