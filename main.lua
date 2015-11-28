function drawSprite(character, sprite)
  local sectionWidth = character.width / character.spriteDims[1]
  local sectionHeight = character.height / character.spriteDims[2]
  local y = character.y - character.height / 2
  for i, row in ipairs(sprite) do
    local x = character.x - character.width / 2
    y = y + sectionHeight
    for j, col in ipairs(row) do
      x = x + sectionWidth
      if col == 1 then
        love.graphics.rectangle("fill", x, y, sectionWidth, sectionHeight)
      end
    end
  end
end

function explodeSprite(character, sprite)
  local sectionWidth = character.width / character.spriteDims[1]
  local sectionHeight = character.height / character.spriteDims[2]
  local y = character.y - character.height / 2
  for i, row in ipairs(sprite) do
    local x = character.x - character.width / 2
    y = y + sectionHeight
    for j, col in ipairs(row) do
      x = x + sectionWidth
      if col == 1 then
        if math.random() > 0.7 then
          love.graphics.setColor(255 * math.random(), 255 * math.random(), 255 * math.random(), 255)
          love.graphics.rectangle("fill", x, y, sectionWidth, sectionHeight)
        end
      end
    end
  end
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function makeHero()
  hero.shots = {}
  hero.x = 300
  hero.y = 450
  hero.speed = 200
  hero.width = 36
  hero.height = 20
  hero.lives = 3
  hero.protectedUntil = 0
  hero.score = 0
  hero.sprite = {{0, 0, 0, 0, 1, 0, 0, 0, 0}, {0, 0, 0, 1, 1, 1, 0, 0, 0}, {0, 1, 1, 1, 1, 1, 1, 1, 0}, {1, 1, 1, 1, 1, 1, 1, 1, 1}, {1, 1, 1, 1, 1, 1, 1, 1, 1}}
  hero.spriteDims = {9, 5}
end

function makeEnemies()
  world.numberOfEnemies = 6
  enemies.speed = 30
  for i = 0, world.numberOfEnemies - tablelength(enemies) do
    enemy = {}
    enemy.random = math.random()
    enemy.width = 44
    enemy.height = 32
    enemy.x = world.width * math.random()
    enemy.y = -20
    enemy.speed = enemies.speed
    enemy.r = math.random() * 255
    enemy.g = math.random() * 255
    enemy.b = math.random() * 255
    enemy.spriteDims = {11, 8}
    enemy.sprite1 = {{0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0}, {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0}, {0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0}, {0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0}, {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, {1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1}, {1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1}, {0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0}}
    enemy.sprite2 = {{0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0}, {1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1}, {1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1}, {1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1}, {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, {0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0}, {0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0}, {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0}}
    table.insert(enemies, enemy)
  end
end

function shoot()
  local shot = {}
  shot.x = hero.x + hero.width/2
  shot.y = hero.y
  table.insert(hero.shots, shot)
end

function love.keyreleased(key)
  if key == " " then
      shoot()
  end
  if key == "r" and world.pause then
    hero = {}
    enemies = {}
    makeHero()
    makeEnemies()
    world.pause = false
    world.time = 0
  end
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1 end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function controlHero(dt)
  if love.keyboard.isDown("left") then
    hero.x = hero.x - hero.speed*dt
  elseif love.keyboard.isDown("right") then
    hero.x = hero.x + hero.speed*dt
  end
  if hero.x < 0 then
    hero.x = 800 - hero.width
  elseif hero.x > 800 then
    hero.x = 0
  end
end

function addMoreEnemies()
  if tablelength(enemies) < world.numberOfEnemies then
    makeEnemies()
  end
end

function love.load()
  bg = love.graphics.newImage("bg.png")
  fg = love.graphics.newImage("fg.png")
  love.window.setTitle('Invaders Must Die')
  love.graphics.setBackgroundColor(255, 255, 255)
  titleFont = love.graphics.newFont("8-BIT WONDER.TTF", 100)
  bodyFont = love.graphics.newFont("8-BIT WONDER.TTF", 30)
  scoreFont = love.graphics.newFont("8-BIT WONDER.TTF", 20)
  hero = {}
  enemies = {}
  world = {}
  explosions = {}
  world.width, world.height, world.flags = love.window.getMode()
  world.ground = 465
  world.tab = 20
  world.time = 0
  world.pause = true
  makeHero()
  makeEnemies()
end

function love.update(dt)
  world.time = world.time + dt
  if not world.pause then
    local remEnemy = {}
    local remShot = {}
    controlHero(dt)
    addMoreEnemies()
    -- Control Enemies
    for i,v in ipairs(enemies) do
      v.y = v.y + dt * v.speed
      v.x = v.x + math.sin(v.random*(world.time + v.random))
      if v.y > (world.ground - v.height) then
        table.remove(enemies, i)
        if hero.protectedUntil < world.time then
          hero.lives = hero.lives - 1
          hero.protectedUntil = world.time + 2
        end
      end
    end
    -- Control Shots
    for i,v in ipairs(hero.shots) do
      v.y = v.y - dt * 500
      if v.y == 0 then
        table.remove(hero.shots, i)
      end
      for ii, vv in ipairs(enemies) do
        if CheckCollision(v.x, v.y, 2, 5, vv.x, vv.y, vv.width, vv.height) then
          explosion = deepcopy(vv)
          explosion.sprite = vv.sprite1
          explosion.duration = world.time + 1
          table.insert(explosions, explosion)
          table.remove(enemies, ii)
          table.remove(hero.shots, i)
          hero.score = hero.score + 1
        end
        if vv.x < 0 then
          vv.x = vv.x + world.width
        end
        if vv.x > world.width then
          vv.x = vv.x - world.width
        end
      end
    end
    for h, explosion in ipairs(explosions) do
      if explosion.duration < world.time then
        table.remove(explosions, h)
      end
    end
    if hero.lives < 1 then
      world.pause = true
    end
    if math.mod(hero.score, 20) == 0 and hero.score > 19 then
      enemies.speed = enemies.speed + 0.5
    end
    if math.mod(hero.score, 50) == 0 and hero.score > 19 then
      world.numberOfEnemies = world.numberOfEnemies + 1
    end
  end
end

function love.draw()
  -- The Ground
  love.graphics.draw(bg)
  love.graphics.draw(fg)
  -- The Hero
  if hero.protectedUntil > world.time then
    -- love.graphics.setColor(255 * math.random(), 255 * math.random(), 255 * math.random(), 255)
    explodeSprite(hero, hero.sprite)
  else
    love.graphics.setColor(255, 255, 0, 255)
    drawSprite(hero, hero.sprite)
  end
  love.graphics.setColor(255, 255, 0, 255)
  for i = 1, hero.lives do
    local tempHero = deepcopy(hero)
    tempHero.x = world.width - i * 2.5 * world.tab
    tempHero.y = world.tab
    drawSprite(tempHero, tempHero.sprite)
    i = i + 1
  end
  love.graphics.setFont(scoreFont)
  love.graphics.printf(hero.score, world.tab, world.tab, world.width, 'left')
  -- The Enemies
  for i, v in ipairs(enemies) do
    love.graphics.setColor(v.r, v.g, v.b, 255)
    if math.floor((world.time + v.random) * 3) % 2 == 0 then
      drawSprite(v, v.sprite2)
    else
      drawSprite(v, v.sprite1)
    end
  end
  -- The explosions
  for h, explosion in ipairs(explosions) do
    explodeSprite(explosion, explosion.sprite)
  end
  -- The Bullets
  love.graphics.setColor(255, 255, 255, 255)
  for i,v in ipairs(hero.shots) do
    love.graphics.rectangle("fill", v.x - hero.width / 2 + 3, v.y, 2, 5)
    love.graphics.rectangle("fill", v.x - 2 - hero.width / 2 + 3, v.y + 5, 6, 2) -- drawing bullets here is trivial / easier
  end
  if world.pause then
    if hero.lives == 0 then
      love.graphics.setFont(titleFont)
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.printf("GAME OVER", 0, 100, world.width, 'center')
      love.graphics.setFont(bodyFont)
      love.graphics.printf("Press r to Lose Again", 0, 400, world.width, 'center')
    else
      love.graphics.setFont(titleFont)
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.printf("INVADERS MUST DIE", 0, 100, world.width, 'center')
      love.graphics.setFont(bodyFont)
      love.graphics.printf("Press r to Lose Eventually", 0, 400, world.width, 'center')
    end
  end
end
