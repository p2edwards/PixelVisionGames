--[[
	Pixel Vision 8 - Reaper Boy 42 Disk 2 (Level Scene)
	Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
	Created by Jesse Freeman (@jessefreeman)

	Learn more about making Pixel Vision 8 games at https://www.pixelvision8.com/getting-started
]]--

LoadScript("sb-sprites")
LoadScript("code-entities-enemies")
LoadScript("code-entities-player")
LoadScript("code-entities-effects")
LoadScript("code-entities-items")
LoadScript("code-score")

GameScene = {}
GameScene.__index = GameScene

local curtainlayer = {
  {spriteIDs = curtainleft.spriteIDs, x = 0, y = 0, width = curtainleft.width, flipH = false},
  {spriteIDs = curtaincenter.spriteIDs, x = 32, y = 0, width = curtaincenter.width, flipH = false},
  {spriteIDs = curtainleft.spriteIDs, x = 224, y = 0, width = curtainleft.width, flipH = true}
}

local cloudLayer = {
  spriteIDs = levelforeground.spriteIDs, x = 0, y = 176, width = levelforeground.width
}

local cloudFillTile = cloudLayer.spriteIDs[#cloudLayer.spriteIDs]

cloudLayerStartRow = 0

function GameScene:Init()

  SetScorePos(128, 16)

  -- debug = true
  local _game = {}
  setmetatable(_game, GameScene) -- make Account handle lookup

  _game.levelSize = {x = 33, y = 31}
  _game.minCloudSpeed = 1
  _game.cloudLayerSpeed = _game.minCloudSpeed
  _game.totalLevelTiles = _game.levelSize.x * _game.levelSize.y
  _game.playerSpawnPos = {x = _game.levelSize.x / 2, y = 0}
  _game.levelCompleted = false

  return _game

end

function GameScene:OnLevelComplete()

  self.levelCompleted = true

  self.cloudLayerSpeed = 20
  --
  -- AddScore(1000)
  PlayPatterns({0}, false)

end

function GameScene:Reset()

  PlayPatterns({math.random(1, 3)}, true)

  enemyMultiplier = 1
  self.levelCompleted = false

  -- self.cloudLayerSpeed = 25

  self.hurryUpTime = -1
  self.hurryUpDelay = .5
  self.showHurryUpTime = false

  -- Get the current scroll position
  local pos = ScrollPosition()

  -- Create a new vector for the scroll position
  self.scrollPos = NewPoint(pos.x, pos.y)

  GoToScreen(Game + (currentlevel - 1))

  BackgroundColor(2)

  self.scrollPos = ScrollPosition()

  cloudLayer.y = 176
  cloudLayerStartRow = math.floor(cloudLayer.y / 8)



  for i = 1, 3 do
    SpawnEntity(i < 3 and "CloudA" or "CloudB", math.random(0, self.levelSize.x) * 8, math.random(7, self.levelSize.y - 6) * 8)
  end

  self:ParseLevelFlags()

  self:RespawnPlayer()

  CopyScoreToBackground()

  -- self:UpdateMeter()

end

function GameScene:ParseLevelFlags()

  enemyTotal = 0
  self.portalExist = false

  for i = 1, self.totalLevelTiles do

    local c, r = TilePosFromIndex(i, self.levelSize.x)

    local realC = c + (colOffset * self.levelSize.x) - 1
    local realR = r + (rowOffset * self.levelSize.y)

    local flag = Flag(realC, realR)

    -- Convert the x and y to pixels
    local x = c * 8 - 16
    local y = r * 8

    -- TODO need to make sure its within the screen to display?

    local entity = nil

    -- Player spawn position
    if(flag == 1) then

      self.playerSpawnPos.x = x
      self.playerSpawnPos.y = y

      -- Spawn exit
    elseif(flag == 2) then
      if(self.portalExist ~= true) then
        SpawnEntity("Exit", x, y)
        self.portalExist = true
      end

    elseif(flag == 3 or flag == 4) then

      SpawnEntity("Penguin", x, y, flag == 4)

      enemyTotal = enemyTotal + 1

    elseif(flag == 5 or flag == 6) then

      SpawnEntity("Ladybug", x, y, flag == 6)

      enemyTotal = enemyTotal + 1

    elseif(flag == 7 or flag == 8) then

      SpawnEntity("Toad", x, y, flag == 8)

      enemyTotal = enemyTotal + 1

    elseif(flag == 9) then

      SpawnEntity("Boss", x, y)

      enemyTotal = enemyTotal + 4

    elseif(flag == 10) then

      SpawnEntity("Spike", x, y - 8)

    elseif(flag == 11) then

      SpawnEntity("FoodA", x, y)

    elseif(flag == 12) then

      SpawnEntity("FoodB", x, y)

    elseif(flag == 13) then

      SpawnEntity("FoodC", x, y)

    end

    -- if(entity ~= nil) then
    --
    --   -- Add the instance to the list to render
    --   table.insert(self.instances, entity)
    --
    -- end

    -- self:RestartLevel()

  end

  -- Store the total enemies
  self.totalEnemies = enemyTotal

end

function GameScene:RemoveEnemey()

  enemyTotal = enemyTotal - 1
  if(enemyTotal < 0) then
    enemyTotal = 0
  end

  self.cloudLayerSpeed = self.cloudLayerSpeed - 1

  if(self.cloudLayerSpeed < self.minCloudSpeed) then
    self.cloudLayerSpeed = self.minCloudSpeed
  end



end

function GameScene:UpdateMeter()

  local startX = 32
  local startY = 16

  DrawSprites(healthbarleft.spriteIDs, startX, startY, healthbarleft.width, false, false, DrawMode.UI, 0, false, false)

  local totalBars = (self.totalEnemies - enemyTotal)

  for i = 1, self.totalEnemies do

    startX = startX + 8

    local spriteData = ((i - 1) < totalBars) and healthbarcenteron or healthbarcenteroff

    DrawSprites(spriteData.spriteIDs, startX, startY, spriteData.width, false, false, DrawMode.UI, 0, false, false)

  end

  DrawSprites(healthbarright.spriteIDs, startX + 8, startY, healthbarright.width, false, false, DrawMode.UI, 0, false, false)

end

function GameScene:RespawnPlayer()

  enemyMultiplier = 1

  self.playerEntity = SpawnEntity("Player", self.playerSpawnPos.x, self.playerSpawnPos.y, false)

  self.cloudLayerSpeed = self.cloudLayerSpeed + 1

end

function GameScene:Update(timeDelta)

  -- Reset scroll position
  ScrollPosition(self.scrollPos.x, self.scrollPos.y)

  if(entities ~= nil) then
    UpdateEntities(timeDelta, self.scrollPos)
  end

  cloudLayer.y = cloudLayer.y - (self.cloudLayerSpeed * timeDelta)

  local currentRow = math.floor((cloudLayer.y - 5) / 8)

  if(currentRow < 15) then
    self.hurryUpTime = self.hurryUpTime + timeDelta

    if(self.hurryUpTime > self.hurryUpDelay) then
      self.hurryUpTime = 0
      self.showHurryUpTime = not self.showHurryUpTime

      if(self.levelCompleted == false) then
        PlaySound(16, 3)
      end
    end

  end

  if(currentRow ~= cloudLayerStartRow) then

    cloudLayerStartRow = currentRow

    local offset = ScrollPosition()

    for i = 1, 33 do

      DrawSprite(cloudFillTile, offset.x + ((i - 1) * 8) - 4, offset.y + (cloudLayerStartRow * 8) + 64, false, false, DrawMode.TilemapCache)
    end

    if(self.levelCompleted == true) then
      self.cloudLayerSpeed = self.cloudLayerSpeed + 2
      AddScore(100)
    else
      if(currentRow < 10) then
        self.cloudLayerSpeed = self.cloudLayerSpeed + 2
      end
    end

    if(self.hurryUpTime >= 0) then
      self.hurryUpDelay = self.hurryUpDelay - .05

      if(self.hurryUpDelay < .2) then
        self.hurryUpDelay = .2
      end
    end

  end


  if(currentRow <= -5) then
    if(self.levelCompleted == true) then
      self.cloudLayerSpeed = 0
      if(ScoreAnimating() == false) then
        SwitchScene(Level)
        currentlevel = currentlevel + 1
        ClearAllEntities()
      end
    else
      self:OnGameOver()
    end

  end

  if(self.playerEntity ~= nil) then
    if(self.playerEntity.loop > 2 and self.levelCompleted == false) then

      local loop = self.playerEntity.loop - 2

      local maxLoop = 6
      if(loop > maxLoop) then
        loop = maxLoop
      end

      loop = 4 * (loop / maxLoop)

      -- local offset =
      self.shakeX = math.random(-loop / 2, loop / 2)
      self.shakeY = math.random(-loop, 0)

      ScrollPosition(self.scrollPos.x + self.shakeX, self.scrollPos.y + self.shakeY)

    else
      self.shakeX = 0
      self.shakeY = 0
    end
  end

end

function GameScene:Draw()

  RedrawDisplay()

  -- local scrollPos = ScrollPosition()

  -- TODO loop through and draw game sprites
  if(entities ~= nil) then
    DrawEntities(timeDelta, self.scrollPos)
  end

  DrawScore()

  -- if(enemyMultiplier > 1) then
  --
  -- end

  self:UpdateMeter()

  -- Draw foreground layer
  DrawSprites(cloudLayer.spriteIDs, cloudLayer.x, cloudLayer.y, cloudLayer.width, false, false, DrawMode.SpriteAbove, 0, false, false)

  -- Draw curtain layer
  for i = 1, #curtainlayer do

    local layer = curtainlayer[i]

    DrawSprites(layer.spriteIDs, layer.x, layer.y, layer.width, layer.flipH, false, DrawMode.SpriteAbove, 0, false, false)

  end

  if(self.levelCompleted == false and self.showHurryUpTime == true) then

    DrawSprites(hurryup.spriteIDs, 88, 216, hurryup.width, false, false, DrawMode.SpriteAbove, 0, false, false)
  end

end

function GameScene:OnGameOver()

  local disk1Path = ReadBiosData("disk1Path")

  if(disk1Path == nil or disk1Path == "") then

    disk1Path = "/Disks/ReaperBoy/ReaperBoyDisk1/"

  end

  local metaData = 
  {
    mode = "Lose",
    previousDisk = "Disk2",
    level = tostring(currentlevel)
  }

  LoadGame(disk1Path, metaData)

end
