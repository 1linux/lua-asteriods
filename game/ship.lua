require"class"
require"object"

Ship=Object:extend()

function Ship:init( x, y, enginePower, maneuveringThrusterPower, maxAngularVelocity)
  Object.init(self,'Ship',x,y)
  self.vertices={
    -10, 10,
      0, -15,
     10, 10,
  }
  self.options = {
    maxAngularVelocity = maxAngularVelocity or 8,
    maneuveringThrusterPower = maneuveringThrusterPower or 1,
    enginePower = enginePower or 1
  }
  self.shape = love.physics.newPolygonShape(self.vertices)
  self.fixture = love.physics.newFixture(self.body, self.shape, 1) -- A higher density gives it more mass.
  self.fixture:setFilterData( 2, 1, 0 )
  self.body:setAngularDamping( 0.3 )
  --self.angle=0
end

local function clamp(x, min, max)
  if x < min then return min end
  if x > max then return max end
  return x
end

function Ship:update(dt)
  self:updatePropulsion(dt)
  self:updateAngularVelocity(dt)

  Object.update(self,dt)
end

function Ship:draw()
  love.graphics.setLineStyle("rough")
  love.graphics.setColor(0,1,0)
  love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
  --[[
  local cx, cy = self.body:getWorldCenter()
  if love.keyboard.isDown("w", "s") then
    local propX, propY = self:getPropulsionVector()
    love.graphics.line(cx, cy, cx + propX, cy + propY)
  end
  ]]--
end

function Ship:getPropulsionVector(dt, backward)
  local angle = self.body:getAngle()
  local propulsion = cosmologicalConstant * dt * self.options["enginePower"]
  local fx, fy = math.cos(angle - math.pi / 2) * propulsion, math.sin(angle - math.pi / 2) * propulsion

  if backward then
    fx = fx * -1
    fy = fy * -1
  end

  return fx, fy
end

function Ship:updatePropulsion(dt)
  if love.keyboard.isDown("w", "s", "up", "down") then
    local backward=love.keyboard.isDown("s", "down")
    self.body:applyLinearImpulse(self:getPropulsionVector(dt, backward))
  end
end

function Ship:updateAngularVelocity(dt)
  local angularVelocity = self.body:getAngularVelocity()
  if love.keyboard.isDown("a", "d", "left", "right") then
    local fAngularVelocity = cosmologicalConstant2 * dt * self.options["maneuveringThrusterPower"]
    if love.keyboard.isDown("a","left") then
      fAngularVelocity = fAngularVelocity * -1
    end
    angularVelocity = angularVelocity + fAngularVelocity
  end
  self.body:setAngularVelocity(clamp(angularVelocity, -self.options["maxAngularVelocity"], self.options["maxAngularVelocity"]))
end

function Ship:event(eventName, ...)
  if eventName=='COLLISION' then
    Statics.tmp.didCrash=true
  end
end