if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
end

cosmologicalConstant = 150 *60
cosmologicalConstant2 = 0.15 * 60

require"statics"
require"object"
require"asteroid"
require"ship"
love.physics.setMeter(2)

Statics.world = love.physics.newWorld(0, 0, false)

Statics.sounds={}
Statics.sounds.sndClick = love.audio.newSource("sounds/click.wav", "static")
Statics.sounds.sndClick:setVolume(0.3)
Statics.sounds.sndExplosion = love.audio.newSource("sounds/explosion.wav", "static")
Statics.sounds.sndLaserShoot = love.audio.newSource("sounds/laserShoot.wav", "static")

local randDir=function()
  if math.random()<0.5 then return -1 else return 1 end
end

function love.load()
  love.window.setMode(1440, 768, {fullscreen=true, resizable=true, vsync=false,})
  love.mouse.setVisible(false)
  for t=1,15 do
    local ast=Asteroid(math.random(1,6), nil, 400+math.random()*800-400,300+math.random()*600-300)
    ast.velocity=1
    ast.spin=randDir()*(math.random()*2+0.2)
    ast.heading=math.random()*8
    ast.body:setLinearVelocity(randDir()*math.random(80,150), randDir()*math.random(80,150))
    -- ast.body:applyForce(400, 0)
    --table.insert(objects, ast)
  end

  Ship(400+math.random()*800-400,300+math.random()*600-300)

  Statics.world:setCallbacks(
    function(fixture_a, fixture_b, contact)
      local a,b
      for _, o in ipairs(Statics.objects) do
        if o.fixture==fixture_a then a=o end
        if o.fixture==fixture_b then b=o end
      end
      if a then a:event('COLLISION', b, contact) end
      if b then b:event('COLLISION', a, contact) end
    end, function() end
  )

end

function nextTick(func)
  table.insert(Statics.nextTick, func)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(tostring(love.timer.getFPS())..' FPS', 0, 0)
  if Statics.vsync then
    love.graphics.print('VSYNC', 0, 10)
  end
  for _,obj in ipairs(Statics.objects) do
    obj:draw()
  end
end

function love.update(dt)
  if love.keyboard.isDown("escape") then love.event.quit() end
  if love.keyboard.isDown("v") then love.window.setVSync( -1 ); Statics.vsync=true end
  if love.keyboard.isDown("b") then love.window.setVSync( 0 );Statics.vsync=false end

  Statics.tmp={}

  for i = 1, #Statics.nextTick do Statics.nextTick[i]() end
  Statics.nextTick = {}

  Statics.world:update(dt) --this puts the world into motion

  if Statics.tmp.didCollision then
    Statics.sounds.sndClick:stop()
    Statics.sounds.sndClick:play()
  end
  if Statics.tmp.didCrash then
    Statics.sounds.sndExplosion:stop()
    Statics.sounds.sndExplosion:play()
  end

  if Statics.nextAsteroidSpawn <= love.timer.getTime() then
    local ast=Asteroid(math.random(1,6), nil, 400+math.random()*800-400,300+math.random()*600-300)
    ast.velocity=1
    ast.spin=randDir()*(math.random()*2+0.2)
    ast.heading=math.random()*8
    ast.body:setLinearVelocity(randDir()*math.random(80,150), randDir()*math.random(80,150))
    Statics.nextAsteroidSpawn = love.timer.getTime() + math.random() * 30
  end

  for i = #Statics.objects, 1, -1 do
    local obj = Statics.objects[i]
    obj:update(dt)
    if obj.deleted then
      if obj.destroy then obj:destroy() end
      table.remove(Statics.objects, i)
    end
  end
end