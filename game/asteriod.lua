require"class"
require"object"

Asteroid=Object:extend()

function Asteroid:init(size, parent, x, y)
  Object.init(self,'Asteroid',x,y)
  self.size=size
  self.distorts={}
  self.vertices={}
  local dist=0
  local distDir=0
  local points=8
  for r=1,points do
    distDir=math.random()*2-1
    dist=dist+distDir
    if dist>6 then
      dist=6
    end
    if dist<-6 then
      dist=-6
    end
    self.distorts[r]=dist
    --dist
    local ra=2*math.pi / points * (r-1)
    table.insert(self.vertices, size*math.cos(ra)*(10+self.distorts[r]))
    table.insert(self.vertices, size*math.sin(ra)*(10+self.distorts[r]))
  end
  --self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
  self.shape = love.physics.newPolygonShape(self.vertices)
  self.fixture = love.physics.newFixture(self.body, self.shape, 1) -- A higher density gives it more mass.
  self.fixture:setRestitution( math.random()*1.0 +0.5 )
  self.fixture:setFriction( 1.0 )
  self:reconfigureCollission()
end

function Asteroid:draw()
  local _,_,group=self.fixture:getFilterData()
  local intense=(group-1)*0.04
  love.graphics.setColor(intense,intense,intense)
  love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
  love.graphics.setColor(0,1,0)
  love.graphics.setLineStyle("rough")
  love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
end

function Asteroid:reconfigureCollission()
  local ix=1
  if math.random()<0.5 then ix=2 end
  self.fixture:setFilterData( 1, 2, ix )
end

function Asteroid:event(eventname,...)
  if eventname=='REPOSITION' then
    self:reconfigureCollission()
    -- Statics.sounds.sndClick:play()
  elseif eventname=='COLLISION' then
    local args={...}
    if args[1].name=='Asteroid' then
      Statics.tmp.didCollision=true
    end

  end

end
