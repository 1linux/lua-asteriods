require"class"

Object = class()

Object.objects={}

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
  if self.x > love.graphics.getWidth() then
    self.x = self.x - love.graphics.getWidth()
  elseif self.x<0 then
    self.x = self.x + love.graphics.getWidth()
  end
  if self.y > love.graphics.getHeight() then
    self.y = self.y - love.graphics.getHeight()
  elseif self.y<0 then
    self.y = self.y + love.graphics.getHeight()
  end
  return
end

function Object:draw()
  -- pure virtual function
end

function Object:delete()
  --TODO: Delete-Marker setzen, bei nächstem Update löschen
end

function Object:init(world,x,y)
  self.body=love.physics.newBody(world, x, y, "dynamic")
  self.x=x
  self.y=y
  table.insert(Object.objects,self)
end
