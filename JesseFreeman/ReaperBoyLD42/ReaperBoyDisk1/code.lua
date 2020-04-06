--[[
  Pixel Vision 8 - Reaper Boy 42 Disk 1
  Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
  Created by Jesse Freeman (@jessefreeman)

  Learn more about making Pixel Vision 8 games at https://www.pixelvision8.com/getting-started
]]--
LoadScript("code-score")

Start, Lose, Win = 0, 1, 2


local mode = -1
local frame = 0
local frameTime = 0
local frameDelay = .3
local blinkTime = 0
local blinkFlag = true
local continueTime = 0
local continueDelay = 2
local continueCount = 10

function Init()

  -- Disable the back key in this tool
  -- EnableBackKey(false)

  -- TODO need to read from meta data to see what mode to display or use Start by defaul
  local startMode = _G[ReadMetadata("mode", "Start")]

  -- print("startMode", startMode)
  ChangeMode(startMode)

  if(startMode == Start) then
    PlayPatterns({3}, true)
  elseif(startMode == Lose) then
    PlayPatterns({2}, true)
  elseif(startMode == Win) then
    PlayPatterns({0}, true)
  end

  if(startMode == Win) then

    SetScorePos(52, 184)

    AddScore(tonumber(ReadMetadata("score", "0")))
  end

end

function Update(timeDelta)

  -- Update blink
  blinkTime = blinkTime + timeDelta

  blinkFlag = math.floor(blinkTime) % 2 == 1

  -- if(Key(Keys.D1, InputState.Released)) then
  --   ChangeMode(Start)
  -- elseif(Key(Keys.D2, InputState.Released)) then
  --   ChangeMode(Lose)
  -- elseif(Key(Keys.D3, InputState.Released)) then
  --   ChangeMode(Win)
  -- end

  frameTime = frameTime + timeDelta

  if(frameTime > frameDelay) then
    frame = Repeat(frame + 1, 2)
    frameTime = 0
  end

  if(mode == Start) then

    if(Button(Buttons.Start, InputState.Released)) then

      -- local disk2Path = ReadBiosData("Disk2Path")
      --
      -- if(disk2Path == nil or disk2Path == "") then
      --
      --   disk2Path = "/Workspace/Games/ReaperBoyLD42Disk2/"
      --
      -- end

      local metaData = 
      {
        mode = "Play",
        previousDisk = "Disk1"
      }

      LoadDisk2(metaData)
      -- LoadGame(disk2Path, metaData)

    end

  elseif(mode == Lose) then

    -- print("Level", ReadMetadata("level", "1"))

    if(Button(Buttons.Start, InputState.Released)) then

      local metaData = 
      {
        mode = "Level",
        previousDisk = "Disk1",
        level = ReadMetadata("level", "1")
      }

      LoadDisk2(metaData)

    end

    continueTime = continueTime + timeDelta

    if(continueTime > continueDelay) then
      continueTime = 0
      continueCount = continueCount - 1

      if(continueCount < 0) then
        ChangeMode(Start)
      end

    end


  elseif(mode == Win) then

    if(Button(Buttons.Start, InputState.Released)) then
      ChangeMode(Start)
    end

    DrawScore()
    ScrollPosition(0, (mode + frame) * 240)

  end

end

function Draw()

  RedrawDisplay()

  if(mode == Start) then

    if(blinkFlag) then
      DrawText("PRESS START", 88, 224, DrawMode.Sprite, "large-green")
    end

  elseif(mode == Win) then

    if(blinkFlag) then
      DrawText("PRESS START TO PLAY AGAIN", 32, 224, DrawMode.Sprite, "large-orange")
    end
  elseif(mode == Lose) then

    if(blinkFlag) then

      DrawText("PRESS START TO CONTINUE "..string.format("%02d", continueCount), 24, 224, DrawMode.Sprite, "large-orange")
    end

  end

end

function ChangeMode(newMode)

  mode = newMode

  ScrollPosition(0, mode * 240)

end

function LoadDisk2(metaData)

  local disk2Path = ReadBiosData("Disk2Path")

  if(disk2Path == nil or disk2Path == "") then

    disk2Path = "/Disks/ReaperBoyLD42/ReaperBoyDisk2/"

  end

  LoadGame(disk2Path, metaData)

end
