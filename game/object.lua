require"class"

---@class Object:Class
Object = class()

Object:set{
	active = {
    value = true,
    set = function(self, newVal, oldVal)
      self.visible = newVal
      return newVal
    end,
  },
  dead = {
    value = false,
  },
  visible = {
    value = false,
  },
  x = {
    value=0,
    get = function(self,value)
            return self.body:getX( )
          end,
    set = function(self,newVal, oldVal)
            self.body:setX(newVal)
            return newVal
          end
  },
  y = {
    value=0,
    get = function(self,value)
            return self.body:getY( )
          end,
    set = function(self,newVal, oldVal)
            self.body:setY(newVal)
          end
  },
  rotation=0,
  spin={
    value=0,
    set = function(self,newVal, oldVal)
      self.body:setAngularVelocity(newVal)
      return newVal
    end
  },
  heading=0, -- Vektor der Geschwindigkeit
  velocity=0, -- Velocity in units / Sekunde
  vector=0, -- >Vektor der Kraft
  acceleration=0, -- Acceleration in units / Sekunde^2
}

-- Simple Object - bewegt sich nicht
function Object:update(dt)
  local repo=false
  if self.x > love.graphics.getWidth() then
    self.x = self.x - love.graphics.getWidth()
    repo=true
  elseif self.x<0 then
    self.x = self.x + love.graphics.getWidth()
    repo=true
  end
  if self.y > love.graphics.getHeight() then
    self.y = self.y - love.graphics.getHeight()
    repo=true
  elseif self.y<0 then
    self.y = self.y + love.graphics.getHeight()
    repo=true
  end
  if repo then
    self:event('REPOSITION')
  end
  return
end

function Object:draw()
  -- pure virtual function
end

function Object:delete()
  --TODO: Delete-Marker setzen, bei nächstem Update löschen
  self.deleted = true
end

function Object:event(eventname, ...)
  --TODO: Delete-Marker setzen, bei nächstem Update löschen
end

function Object:init(objectName,x,y)
  self.body=love.physics.newBody(Statics.world, x, y, "dynamic")
  self.x=x
  self.y=y
  self.name=objectName
  table.insert(Statics.objects,self)
end
