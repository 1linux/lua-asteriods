require"class"
require"object"

---@class Shot:Object
---@overload fun(x: number, y: number, maxVelocity: number): Shot
Shot=Object:extend()

function Shot:init( x, y, angle, xVel, yVel, maxVelocity)
  Object.init(self,'Shot',x,y)
  self.shape = love.physics.newRectangleShape(5, 45)
  self.fixture = love.physics.newFixture(self.body, self.shape, 1) -- A higher density gives it more mass.
  self.fixture:setFilterData( 2, 1, 0 )
  self.body:setAngularDamping( 0.3 )
  self.body:setAngle(angle)
  self.body:setLinearVelocity(xVel * maxVelocity, yVel * maxVelocity)
end

function Shot:destroy()
  self.shape:release()
  self.fixture:destroy()
  self.body:destroy()
end

function Shot:draw()
  love.graphics.setLineStyle("rough")
  love.graphics.setColor(1,1,0)
  love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end

function Shot:event(eventName, ...)
  if eventName=='COLLISION' then
    local hit = ({...})[1]
    if hit.name == "Asteroid" then
        if hit.size > 2 then
            for i = 1, 2 do
                nextTick(function()
                    Asteroid(math.floor(hit.size / 2), hit)
                end)
            end
        end
        nextTick(function()
            hit:delete()
        end)
    end
    self:delete()
  end
end
