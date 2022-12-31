if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
end

--require"object"
require"asteriod"
require"ship"

objects={}

function love.load()
  love.window.setMode( 0, 0) -- full screen

  for t=1,15 do
    local ast=Asteroid(math.random(1,5))
    ast.velocity=1
    ast.spin=(math.random()-0.5)*2+0.2
    ast.heading=math.random()*8
    table.insert(objects, ast)
  end
  for t=1,3 do
    local ship = Ship()
    ship.velocity=0.5+math.random()*2
    ship.heading=1+math.random()*4
    ship.spin=(math.random()-0.5)*2*math.pi
    ship.x=400+math.random()*800-400
    ship.y=300+math.random()*600-300
    table.insert(objects,ship)
  end
end


function love.draw()
  love.graphics.print('Hello World!', 400, 300)
  for _,obj in ipairs(objects) do
    obj:draw()
  end
end

function love.update(dt)
  for _,obj in ipairs(objects) do
    obj:update(dt)
  end
end