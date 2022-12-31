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
  x = 0,  -- 0..1 Bezüglich des Spieldfelds
  y = 0,
  rotation=0,
  spin=0,
  heading=0, -- Vektor der Geschwindigkeit
  velocity=0, -- Velocity in units / Sekunde
  vector=0, -- >Vektor der Kraft
  acceleration=0, -- Acceleration in units / Sekunde^2

	property = {
		value = "v",
		get = function(self, value) return self.a .. value end
	},
	property2 = {
		value = 3,
		set = function(self, newVal, oldVal) return newVal * oldVal end
	}
}

-- Simple Object - bewegt sich nicht
function Object:update(dt)
  if self.velocity>0 then
    self.x = self.x + math.cos(self.heading)*self.velocity
    self.y = self.y + math.sin(self.heading)*self.velocity
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

  end
  self.rotation=self.rotation+self.spin*dt
  if self.rotation >2*math.pi then
    self.rotation=self.rotation-2*math.pi
  end
  return
end

function Object:draw()
  -- pure virtual function
end

function Object:delete()
  --TODO: Delete-Marker setzen, bei nächstem Update löschen
end

function Object:init()
  self.tt=7
  table.insert(Object.objects,self)
  -- TODO
end
