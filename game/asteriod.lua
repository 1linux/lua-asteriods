require"class"
require"object"

Asteroid=Object:extend()

function Asteroid:init(size, parent)
  Object.init(self)
  self.size=size
  self.distorts={}
  self.vertices={}
  local dist=0
  local distDir=0
  local points=40
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
    table.insert(self.vertices, math.cos(ra)*(10+self.distorts[r]))
    table.insert(self.vertices, math.sin(ra)*(10+self.distorts[r]))
  end
  self.__vertices={
    -9, 0,
    -10,-10,
    -2,-10,
    7,-8,
    10,0,
    9,8,
    5,8,
    -2,10,
    -6,5,
  }
end

function Asteroid:draw()
  love.graphics.push()
  -- love.graphics.setCanvas(canvas)
  love.graphics.setLineStyle("rough")

  love.graphics.translate(self.x+0.5,self.y+0.5)
  love.graphics.rotate(self.rotation)
  love.graphics.scale(self.size)
  love.graphics.setLineWidth( 1/self.size )

  love.graphics.setColor(0,0.1,0)
  love.graphics.polygon("fill", self.vertices)
  love.graphics.setColor(0,1,0)
  love.graphics.polygon("line", self.vertices)
  love.graphics.pop()
  love.graphics.setLineWidth( 1 )
  -- love.graphics.setCanvas()
end