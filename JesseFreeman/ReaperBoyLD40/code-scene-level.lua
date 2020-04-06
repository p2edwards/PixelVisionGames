--[[
  Pixel Vision 8 - ReaperBoy v3
  Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
  Created by Jesse Freeman (@jessefreeman)

  Licensed under the Microsoft Public License (MS-PL) License.

  Learn more about making Pixel Vision 8 games at http://pixelvision8.com
]]--

-- Splash Scene
LevelScene = {}
LevelScene.__index = LevelScene

function LevelScene:Init()

  local _level = {}
  setmetatable(_level, LevelScene) -- make Account handle lookup

  _level.flickerTime = 0
  _level.flickerDelay = 1

  return _level

end

function LevelScene:Reset()

  -- calculate the level offset
  local offset = 3 * levelBonus

  -- Each level you play you get more points for completing it
  levelBonus = levelBonus + 1

  if(levelBonus < 5) then
    -- Calculate the level
    level = math.random(1 + offset, 3 + offset)
  else
    level = 13
  end

  GoToScreen(1)

  BackgroundColor(3)

  RebuildTilemap()

  -- Clear tile area where score is
  DrawSprites({ - 1, - 1, - 1, - 1, - 1, - 1}, 32, 1, 6, false, false, DrawMode.Tile)

  totalStars = 0

  colOffset, rowOffset = TilePosFromIndex(level + 2, width)
  local totalLevelTiles = levelSize.x * levelSize.y

  -- Count up the stars in the next level
  for i = 1, totalLevelTiles do

    local c, r = TilePosFromIndex(i, levelSize.x)

    local realC = c + (colOffset * levelSize.x)
    local realR = r + (rowOffset * levelSize.y)

    local flag = Flag(realC, realR)

    -- TODO need to know what kind of enemy it is and how many stars its worth
    if(flag == ENEMY) then
      totalStars = totalStars + 1
    elseif(flag == BOSS) then
      totalStars = 4
    end

  end

  local startC = math.floor(((levelSize.x - 1) - (totalStars * staroff.width)) * .5)

  -- Draw stars
  for i = 1, totalStars do

    local tmpC = startC + ((i - 1) * staron.width) - 1
    local tmpR = 5

    DrawSprites(staron.spriteIDs, (tmpC + 21) * 8, tmpR * 8, staron.width, false, false, DrawMode.TilemapCache, 0, false, false)

  end

  -- Clearing high score from previous game
  -- DrawRect(32 + 168, 56, 96, 8, 3, DrawMode.TilemapCache)


end

function LevelScene:Update(timeDelta)
  --
  -- -- Universal flicker timer
  self.flickerTime = self.flickerTime + timeDelta

  if(self.flickerTime > self.flickerDelay) then
    self.flickerTime = 0
    SwitchScene(3)
  end

end

function LevelScene:Draw()

  local text = "LEVEL " .. levelBonus

  local x = (((levelSize.x - 1) - #text) * .5) * 8

  DrawText(text, x, 24, DrawMode.Sprite, "default")

end
