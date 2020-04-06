LoadScript("sb-sprites")

LoadScript("code-map-templates")
LoadScript("code-entities-enemies")
LoadScript("code-entities-player")
LoadScript("code-entities-projectiles")
LoadScript("code-entities-effects")
LoadScript("code-entities-items")

LoadScript("code-game")

scrollPos = NewPoint()
debug = false

function Init()

  BackgroundColor(1)

  StitchTemplatesTogether()

  InitGame()

end

function Update(timeDelta)

  UpdateGame(timeDelta)

  if(entities ~= nil) then
    UpdateEntities(timeDelta, scrollPos)
  end

end

function Draw()

  DrawGame()

  if(entities ~= nil) then
    DrawEntities(timeDelta, scrollPos)
  end

end
