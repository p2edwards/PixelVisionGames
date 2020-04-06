local displayError = false
local messageTime = 0
local messageDelay = 0
messageText = ""
local messageRect = {x = 8, y = 224 - 8, w = 240, h = 8}

function DisplayMessage(text, delay)

  messageDelay = delay or 5
  messageText = text
  messageTime = 0

  print("message", messageText)

  -- ClearMessage()
  DrawMessage()

end

function UpdateMessage(timeDelay)

  if(messageText ~= "") then

    messageTime = messageTime + timeDelay

    if(messageTime > messageDelay) then
      ClearMessage()
    elseif(Key(Keys.Enter) == true and messageTime > .2) then
      ClearMessage()
    end



  end

end

function DrawMessage()

  -- Draw the text to the display
  DrawText(messageText, messageRect.x, messageRect.y, DrawMode.TilemapCache, "large", 11)

end

function ClearMessage()

  messageText = ""

  -- Clear the line
  DrawRect(messageRect.x, messageRect.y, messageRect.w, messageRect.h, 0, DrawMode.TilemapCache)

end
