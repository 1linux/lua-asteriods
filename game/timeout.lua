require"class"

---@class Object:Timeout
Timeout = class()

Timeout.list={}

function Timeout:init(object, secs, fun, params )
  self.timeout=love.timer.getTime()+secs
  self.fun=fun
  self.object=object
  self.params=params
  local inserted
   for i=1,#Timeout.list do
    local t=Timeout.list[i]
    if t.timeout<self.timeout then
      table.insert(Timeout.list, i,self)
      inserted=true
    break
    end
  end
  if not inserted then
    table.insert(Timeout.list,self) -- ganz ans Ende
  end
end

function Timeout.remove(object)
  for i=#Timeout.list,1,-1 do
    local t=Timeout.list[i]
    if t.object==object then
      table.remove(Timeout.list,i)
    end
  end
end

function Timeout.update(dt)
  local tme=love.timer.getTime()
  for i=#Timeout.list,1,-1 do
    local t=Timeout.list[i]
    if t.timeout<=tme then
      table.remove(Timeout.list,i)
      t.fun(t.object,table.unpack(t.params))
    else
      break
    end
  end
end