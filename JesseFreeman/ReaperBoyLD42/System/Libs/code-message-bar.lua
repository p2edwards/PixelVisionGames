local textColorOffset = 0
local font = "small"
local messageDelay = 0
local time = 0
local maxChars = 35
local offset = -4
local currentMessage = ""
local invalid = false

messageBarVisible = false

function DisplayMessage(text, delay)

  if(text == currentMessage) then
    return
  end

  if(#text > maxChars) then
    text = string.sub(text, 1, maxChars)
  end

  currentMessage = text


  messageDelay = delay or 2
  time = 0

  invalid = true

  messageBarVisible = true

end

function ClearMessage()

  currentMessage = ""
  messageDelay = 0
  invalid = false
  -- Clear BackgroundColor
  DrawRect(0, 0, (maxChars + 4) * 4, 8, BackgroundColor(), DrawMode.TilemapCache)

  messageBarVisible = false

end

function UpdateMessageBar(timeDelta)

  if(messageDelay == 0) then
    return
  end

  time = time + timeDelta


  if(time > messageDelay) then
    ClearMessage()
    time = 0
  end

end

function DrawMessageBar()

  if(invalid == true) then

    -- Clear BackgroundColor
    DrawRect(0, 0, (maxChars + 4) * 4, 8, 0, DrawMode.TilemapCache)

    local length = maxChars - #currentMessage + 1

    if(length < 0) then
      length = 0
    end

    local text = string.format("%s%" .. length .. "s", string.upper(currentMessage), "")

    DrawText(text, 4, -1, DrawMode.TilemapCache, "small", 0, -4)

    invalid = false

  end

end
