--[[
  Pixel Vision 8 - ReaperBoy v2
  Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
  Created by Jesse Freeman (@jessefreeman)

  Licensed under the Microsoft Public License (MS-PL) License.

  Learn more about making Pixel Vision 8 games at http://pixelvision8.com
]]--

-- Load sprites
LoadScript("sb-sprites")

-- Load scenes
LoadScript("code-scene-splash")
LoadScript("code-scene-level")
LoadScript("code-scene-over")
LoadScript("code-scene-game")

-- Make some global constants
EXIT, SPAWN, ENEMY, BOSS = 5, 8, 10, 15

-- Calculate the level size
levelSize = {x = 21, y = 19}

-- The total number of levels horizontally placed in the tilemap
width = 6

-- print("size", width, TilemapSize().x)
-- Create a variable to store the active scene
local activeScene = nil

-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw a text box.
function Init()

  -- Create a table for each of the scenes that make up the game
  scenes = {
    SplashScene:Init(),
    LevelScene:Init(),
    GameScene:Init(),
    OverScene:Init()
  }

  -- Switch to the first scene
  SwitchScene(1)

end

function SetSystemColor()

  -- look to see what key combination is pressed

  local dir = nil

  if( Button(0) == true) then
    dir = 1
  elseif( Button(1) == true) then
    dir = 2
  elseif( Button(2) == true) then
    dir = 3
  elseif( Button(3) == true) then
    dir = 4
  end

  local button = nil

  if( Button(4) == true) then
    button = 1
  elseif( Button(5) == true) then
    button = 2
  end

  local offset = 0

  if(dir ~= nil) then

    offset = dir * 4

    if(button ~= nil) then
      offset = offset + (button * 16)
    end

  end

  for i = 0, 3 do
    ReplaceColor(i, i + offset)
  end

end

function SwitchScene(id)

  -- Set the new active scene
  activeScene = scenes[id]

  -- Call reset on the new active scene
  activeScene:Reset()

end

-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame
-- before the Draw() method. It accepts one argument, timeDelta, which is the difference in
-- milliseconds since the last frame.
function Update(timeDelta)

  -- The timeDelta is passed in as an int, so we'll need to convert it to a float to track the milliseconds between frames.
  timeDelta = timeDelta / 1000

  -- On first run, check to see if the system colors should be changed
  if(firstRun == nil)then

    SetSystemColor()

    firstRun = false

  end

  -- Check to see if there is an active scene before trying to update it.
  if(activeScene ~= nil) then
    activeScene:Update(timeDelta)
  end



end

-- The Draw() method is part of the game's life cycle. It is called after Update() and is where
-- all of our draw calls should go. We'll be using this to render sprites to the display.
function Draw()

  -- We can use the RedrawDisplay() method to clear the screen and redraw the tilemap in a
  -- single call.
  RedrawDisplay()

  -- Check to see if there is an active scenes before trying to draw it.
  if(activeScene ~= nil) then
    activeScene:Draw()
  end

end

-- Global function that changes the background to the correct position
function GoToScreen(id)

  -- Need to figure out which background screen to move to for the level, 0 is the home screen
  colOffset, rowOffset = TilePosFromIndex(id, width)

  -- Offset x, y by the level size and convert to pixels
  local x = (colOffset * levelSize.x) * 8
  local y = (rowOffset * levelSize.y) * 8

  -- Scroll to the correct position and convert the tile id to pixels
  ScrollPosition(x, y)

end

-- Global function to help calculate the tile position from an ID
function TilePosFromIndex(index, width)
  return index % width, math.floor(index / width)
end

function LeftPad(str, len, char)
  if char == nil then char = ' ' end
  return string.rep(char, len - #str) .. str
end
