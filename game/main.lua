if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
end

--require"object"
require"asteriod"
require"ship"
love.physics.setMeter(64)
world = love.physics.newWorld(0, 0, true)

-- objects={}

local randDir=function()
  if math.random()<0.5 then return -1 else return 1 end
end

function love.load()
  --love.window.setMode( 0, 0) -- full screen

  for t=1,13 do
    local ast=Asteroid(world, math.random(2,4), nil, 400+math.random()*800-400,300+math.random()*600-300)
    ast.velocity=1
    ast.spin=randDir()*(math.random()*2+0.2)
    ast.heading=math.random()*8
    ast.body:setLinearVelocity(randDir()*math.random(80,150), randDir()*math.random(80,150))
    -- ast.body:applyForce(400, 0)
    --table.insert(objects, ast)
  end
  for t=1,3 do
    local ship = Ship(world,400+math.random()*800-400,300+math.random()*600-300)
    ship.heading=1+math.random()*4
    ship.velocity=0.5+math.random()*2
    ship.spin=randDir()*(math.random())*2*math.pi
    --table.insert(objects,ship)
  end
end


function love.draw()
  love.graphics.print('Hello World!', 400, 300)
  for _,obj in ipairs(Object.objects) do
    obj:draw()
  end
end

function love.update(dt)
  world:update(dt) --this puts the world into motion
  for _,obj in ipairs(Object.objects) do
    obj:update(dt)
  end
end