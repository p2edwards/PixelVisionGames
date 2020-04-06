--[[
	Pixel Vision 8 - Reaper Boy 42 Disk 2
	Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
	Created by Jesse Freeman (@jessefreeman)

	Learn more about making Pixel Vision 8 games at https://www.pixelvision8.com/getting-started
]]--

LoadScript("code-scene-level")
LoadScript("code-scene-game")

-- Calculate the level size
local levelSize = {x = 33, y = 31}

-- Calculate the level size width
local width = TilemapSize().x / levelSize.x

Level, Game = 1, 2

-- local mode = nil

local levelTime = 0
local levelDelay = 2
local currentLevel = 0

function Init()

  -- TODO Need to make sure disk 2 is loaded from disk 1

  local newMode = Level

  scenes = {
    LevelScene:Init(),
    GameScene:Init(),
  }

  SwitchScene(newMode)



end

function Update(timeDelta)


  if(activeScene ~= nil) then
    activeScene:Update(timeDelta)
  end

end

function Draw()



  -- Check to see if there is an active scenes before trying to draw it.
  if(activeScene ~= nil) then
    activeScene:Draw()
  end

end

function SwitchScene(newMode)

  -- Set the new active scene
  activeScene = scenes[newMode]

  if(activeScene ~= nil) then
    -- Call reset on the new active scene
    activeScene:Reset()

  end

end

-- Global function that changes the background to the correct position
function GoToScreen(id)

  -- Need to figure out which background screen to move to for the level, 0 is the home screen
  colOffset, rowOffset = TilePosFromIndex(id - 1, width)

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
