require"class"
require"object"

---@class Shot:Object
---@overload fun(x: number, y: number, maxVelocity: number): Shot
Shot=Object:extend()

function Shot:init(parent, params) --x, y, angle, xVel, yVel, maxVelocity)  
  self.parent=parent
  local angle = parent.body:getAngle()
  local shipForewardAngle = angle - math.pi / 2
  local xVel, yVel = math.cos(shipForewardAngle), math.sin(shipForewardAngle)

  Object.init(self,'Shot',parent.x + 15*xVel,parent.y + 15*yVel)  -- make shot appear outside the ship

  local shipVx, shipVy = parent.body:getLinearVelocity()
  local relativeVelocity = params.speed or 8000
  xVel=shipVx + xVel * relativeVelocity
  yVel=shipVy + yVel * relativeVelocity

  local runtime=params.runtime or 5
  self.timeout = love.timer.getTime() + runtime

  self.shape = love.physics.newRectangleShape(1, 6)
  self.fixture = love.physics.newFixture(self.body, self.shape, 1) -- A higher density gives it more mass.
  self.fixture:setFilterData( 2, 1, 0 )
  --self.body:setAngularDamping( 0.3 )
  self.body:setAngle(angle)
  self.body:setLinearVelocity( xVel, yVel )
  parent.activeShots = parent.activeShots + 1
  Statics.sounds.sndLaserShoot:stop()
  Statics.sounds.sndLaserShoot:play()  
end

function Shot:update(dt)
  if self.timeout < love.timer.getTime() then
    self.deleted = true
  end
end

function Shot:destroy()
  self.parent.activeShots = self.parent.activeShots - 1
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
      nextTick(function()
        hit:delete()
      end)
      if hit.size > 2 then
        for i = 1, 2 do
          nextTick(function()
            Asteroid(math.floor(hit.size / 2), hit)
          end)
        end
      end
    end
    self:delete()
  elseif eventName=='REPOSITION' then
    self:delete()
  end
end
