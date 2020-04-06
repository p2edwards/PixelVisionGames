--[[
	Pixel Vision 8 - Reaper Boy 42 Disk 2 (Level Scene)
	Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
	Created by Jesse Freeman (@jessefreeman)

	Learn more about making Pixel Vision 8 games at https://www.pixelvision8.com/getting-started
]]--

LevelScene = {}
LevelScene.__index = LevelScene

function LevelScene:Init()

  local _level = {}
  setmetatable(_level, LevelScene) -- make Account handle lookup

  _level.flickerTime = 0
  _level.flickerDelay = 1

  currentlevel = tonumber(ReadMetadata("level", nil))

  return _level

end

function LevelScene:Reset()

  -- entities = {}
  RebuildTilemap()

  currentlevel = currentlevel or 1
  -- currentlevel = 10

  print("currentlevel", currentlevel)

  if(currentlevel >= 10) then
    self:OnWin()
  else
    GoToScreen(Level)

    BackgroundColor(0)

  end

end

function LevelScene:OnWin()

  local disk1Path = ReadBiosData("disk1Path")

  if(disk1Path == nil or disk1Path == "") then

    disk1Path = "/Workspace/Games/ReaperBoyLD42Disk1/"

  end

  local metaData = 
  {
    mode = "Win",
    previousDisk = "Disk2",
    score = GetScore()
  }

  LoadGame(disk1Path, metaData)

end

function LevelScene:Update(timeDelta)
  --
  -- -- Universal flicker timer
  self.flickerTime = self.flickerTime + timeDelta

  if(self.flickerTime > self.flickerDelay) then
    self.flickerTime = 0
    SwitchScene(Game)
  end

end

function LevelScene:Draw()

  RedrawDisplay()

  local text = "LEVEL " .. string.format("%02d", currentlevel)

  DrawText(text, 96, 216, DrawMode.Sprite, "large-orange")

end
