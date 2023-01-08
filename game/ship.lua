require"class"
require"object"

Ship=Object:extend()

function Ship:init(x, y)
  Object.init(self,'Ship',x,y)
  self.vertices={
    -10, 10,
      0, -15,
     10, 10,
  }
  self.shape = love.physics.newPolygonShape(self.vertices)
  self.fixture = love.physics.newFixture(self.body, self.shape, 1) -- A higher density gives it more mass.
  self.fixture:setFilterData( 2, 1, 0 )
  self.body:setAngularDamping( 0.1 )
  --self.angle=0
end

function Ship:update(dt)
  -- self.heading=self.heading+0.6*dt
  Object.update(self,dt)
end

function Ship:draw()
  love.graphics.setLineStyle("rough")
  love.graphics.setColor(0,1,0)
  love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
end

function Ship:event(eventName, ...)
  if eventName=='COLLISION' then
    Statics.tmp.didCrash=true
  end

end