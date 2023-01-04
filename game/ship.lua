require"class"
require"object"

Ship=Object:extend()

function Ship:init(world, x, y)
  Object.init(self,world,x,y)
  self.vertices={
    -10, 10,
      0, -15,
     10, 10,
  }
  self.shape = love.physics.newPolygonShape(self.vertices)
  self.fixture = love.physics.newFixture(self.body, self.shape, 1) -- A higher density gives it more mass.

  self.angle=0
end

function Ship:update(dt)
  self.heading=self.heading+0.6*dt
  Object.update(self,dt)
end

function Ship:draw()
  if false then
    love.graphics.push()
    -- love.graphics.setCanvas(canvas)
    love.graphics.setLineStyle("rough")
    love.graphics.setColor(0,1,0)

    love.graphics.translate(self.x+0.5,self.y+0.5)
    love.graphics.rotate(self.rotation)
    love.graphics.polygon("line", self.vertices)
    love.graphics.pop()
  end
  love.graphics.setLineStyle("rough")
  love.graphics.setColor(0,1,0)
  love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))

  -- love.graphics.setCanvas()
end