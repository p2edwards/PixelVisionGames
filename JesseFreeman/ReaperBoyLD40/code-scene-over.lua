--[[
  Pixel Vision 8 - ReaperBoy v3
  Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
  Created by Jesse Freeman (@jessefreeman)

  Licensed under the Microsoft Public License (MS-PL) License.

  Learn more about making Pixel Vision 8 games at http://pixelvision8.com
]]--

-- Splash Scene
OverScene = {}
OverScene.__index = OverScene

function OverScene:Init()

  local _over = {}
  setmetatable(_over, OverScene) -- make Account handle lookup

  _over.flickerTime = 0
  _over.flickerDelay = 6

  return _over

end

function OverScene:Reset()

  -- Clear tile area where score is
  DrawSprites({ - 1, - 1, - 1, - 1, - 1, - 1}, 32, 1, 6, false, false, DrawMode.Tile)

  RebuildTilemap()

  self.scoreDisplay = 0

  -- Read best score from save file

  bestScore = tonumber(ReadSaveData("bestScore", "500"))

  if(score > bestScore) then
    bestScore = score
    WriteSaveData("bestScore", tostring(score))
  end

  GoToScreen(1)

  BackgroundColor(0)

  -- Offset where we draw the tiles based on what screen we are at
  self.col = (colOffset * levelSize.x)
  self.row = (rowOffset * levelSize.y)

  local spriteData = win == true and gamewin or gameover

  if(spriteData ~= nil) then
    -- Draw logo to the UI layer
    DrawSprites(spriteData.spriteIDs, (self.col + 5) * 8, (self.row + 10) * 8, spriteData.width, false, false, DrawMode.TilemapCache, 0, false, false)

  end

  local text = (win == true) and " YOU WIN" or "GAME OVER"

  DrawText(text, (self.col + 5) * 8, (self.row + 2) * 8, DrawMode.TilemapCache, "default", 1)

  if(bestScore ~= nil) then

    DrawText(" BEST " .. LeftPad(tostring(bestScore), 6, "0"), (self.col + 4) * 8, (self.row + 4) * 8, DrawMode.TilemapCache, "default", 1)

  end

  PlayPatterns({2}, false)

end

function OverScene:Update(timeDelta)
  --
  -- -- Universal flicker timer
  self.flickerTime = self.flickerTime + timeDelta

  if(self.flickerTime > self.flickerDelay) then
    self.flickerTime = 0
    SwitchScene(1)
    return
  end

  if(self.scoreDisplay ~= score) then

    local diff = math.ceil((score - self.scoreDisplay) / 2)

    -- print(score, self.scoreDisplay, diff)

    self.scoreDisplay = self.scoreDisplay + diff

    if(self.scoreDisplay < 0) then
      self.scoreDisplay = 0
    end

    DrawText("SCORE " .. LeftPad(tostring(self.scoreDisplay), 6, "0"), (self.col + 4), (self.row + 7), DrawMode.Tile, "default", 1)

  end

end

function OverScene:Draw()

end
