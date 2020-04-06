function InitGame()

  -- Test Snake
  SpawnEntity("Snake", 150, 96, true)

  SpawnEntity("Health", 48, 96)
  SpawnEntity("Energy", 88, 96)

  -- Test Hard Head
  SpawnEntity("HardHead", 160, 96, true)

  -- Test Turret
  SpawnEntity("Turret", 68, 96)

  -- Test Hidden Turret
  SpawnEntity("HiddenTurret", 24, 96)
  SpawnEntity("HiddenTurret", 120, 96, true)

  -- Test spawning explosion
  SpawnEntity("Explosion", 8, 80)

  -- Test spawning explosion
  SpawnEntity("Dust", 8, 104)
end

function UpdateGame(timeDelta)

  -- Update Map buffer
  UpdateMapBuffer(timeDelta, scrollPos)

end

function DrawGame()

  RedrawDisplay()

end

function ProcessTile(column, row, spriteID, colorOffset, flag, entities)

  Tile(column, row, spriteID, colorOffset, flag)

end
