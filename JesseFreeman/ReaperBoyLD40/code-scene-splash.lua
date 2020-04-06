--[[
  Pixel Vision 8 - ReaperBoy v3
  Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
  Created by Jesse Freeman (@jessefreeman)

  Licensed under the Microsoft Public License (MS-PL) License.

  Learn more about making Pixel Vision 8 games at http://pixelvision8.com
]]--

-- Splash Scene
SplashScene = {}
SplashScene.__index = SplashScene

function SplashScene:Init()

  local _splash = {}
  setmetatable(_splash, SplashScene) -- make Account handle lookup

  _splash.flickerTime = 0
  _splash.flickerDelay = .2
  _splash.flickerVisible = true

  return _splash

end

function SplashScene:Reset()

  win = false
  RebuildTilemap()

  GoToScreen(0)

  BackgroundColor(3)

  -- Draw logo to the UI layer
  DrawSprites(logo.spriteIDs, 0, 98, logo.width, false, false, DrawMode.TilemapCache)

  PlayPatterns({3}, true)

end

function SplashScene:Update(timeDelta)

  -- Universal flicker timer
  self.flickerTime = self.flickerTime + timeDelta

  if(self.flickerTime > self.flickerDelay) then
    self.flickerTime = 0
    self.flickerVisible = not self.flickerVisible
  end


  if(Button(Buttons.Start) == true) then

    -- Update global level value
    score = 0

    level = 1

    levelBonus = 0

    -- Switch to level scene
    SwitchScene(2)

    -- Change song

    PlayPatterns({1}, true)

  end

end

function SplashScene:Draw()

  if(self.flickerVisible == true) then

    DrawText("PRESS START", 36, 125, DrawMode.Sprite, "default")

  end

end
