if getgenv().UniversalHubFinal then return end
getgenv().UniversalHubFinal=true

local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")

local LP=Players.LocalPlayer
local Camera=workspace.CurrentCamera
local Mouse=LP:GetMouse()

local IsPC = not UIS.TouchEnabled

local Settings={
Aimbot=false,
SilentAim=false,
ESP=false,
Fly=false,
Noclip=false,
WallCheck=true,
KillCheck=true,
FlySpeed=80,
FOV=150,
Smooth=0.18
}

-- FOV Circle
local circle=Drawing.new("Circle")
circle.Color=Color3.fromRGB(0,170,255)
circle.Thickness=2
circle.NumSides=60
circle.Filled=false
circle.Visible=false

RunService.RenderStepped:Connect(function()
local size=Camera.ViewportSize
circle.Position=Vector2.new(size.X/2,size.Y/2)
circle.Radius=Settings.FOV
end)

-- UI
local gui=Instance.new("ScreenGui",game.CoreGui)

local frame=Instance.new("Frame",gui)
frame.Size=UDim2.new(0,250,0,480)
frame.Position=UDim2.new(.5,-125,.5,-240)
frame.BackgroundColor3=Color3.fromRGB(25,25,25)
frame.Active=true
frame.Draggable=true
Instance.new("UICorner",frame)

local title=Instance.new("TextLabel",frame)
title.Size=UDim2.new(1,0,0,40)
title.BackgroundTransparency=1
title.Text="Universal Hub"
title.TextColor3=Color3.fromRGB(0,170,255)
title.Font=Enum.Font.GothamBold
title.TextSize=22

-- Mobile toggle
local mobile=Instance.new("TextButton",gui)
mobile.Size=UDim2.new(0,40,0,40)
mobile.Position=UDim2.new(.5,-20,0,10)
mobile.Text="-"
mobile.BackgroundColor3=Color3.fromRGB(40,40,40)
mobile.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",mobile)

mobile.MouseButton1Click:Connect(function()
frame.Visible=not frame.Visible
end)

UIS.InputBegan:Connect(function(i,g)
if g then return end
if i.KeyCode==Enum.KeyCode.K then
frame.Visible=not frame.Visible
end
end)

-- UI helpers
local function Button(text,y,func)

local b=Instance.new("TextButton",frame)
b.Size=UDim2.new(0,210,0,32)
b.Position=UDim2.new(0,20,0,y)
b.BackgroundColor3=Color3.fromRGB(35,35,35)
b.TextColor3=Color3.new(1,1,1)
b.Text=text
Instance.new("UICorner",b)

b.MouseButton1Click:Connect(func)

return b
end

local function Toggle(text,y,setting)

local b=Button(text,y)

local function update()
if Settings[setting] then
b.Text=text.." ✔"
b.TextColor3=Color3.fromRGB(0,255,0)
else
b.Text=text
b.TextColor3=Color3.new(1,1,1)
end
end

update()

b.MouseButton1Click:Connect(function()

Settings[setting]=not Settings[setting]
update()

if setting=="Aimbot" then
circle.Visible=Settings.Aimbot
end

end)

end

local y=60

-- Fly PC only
local flyBV=nil

if IsPC then

Toggle("Fly",y,"Fly")
y+=40

Button("Fly Speed +",y,function()
Settings.FlySpeed+=20
end)
y+=40

Button("Fly Speed -",y,function()
Settings.FlySpeed=math.max(20,Settings.FlySpeed-20)
end)
y+=40

RunService.Heartbeat:Connect(function()

if Settings.Fly and LP.Character then

local char=LP.Character
local hrp=char:FindFirstChild("HumanoidRootPart")
local hum=char:FindFirstChild("Humanoid")

if hrp and hum then

if not flyBV then
flyBV=Instance.new("BodyVelocity")
flyBV.MaxForce=Vector3.new(1e9,1e9,1e9)
flyBV.Parent=hrp
end

local move=hum.MoveDirection

local direction=
(Camera.CFrame.RightVector*move.X)+
(Camera.CFrame.LookVector*move.Z)

flyBV.Velocity=direction*Settings.FlySpeed

end

else

if flyBV then
flyBV:Destroy()
flyBV=nil
end

end

end)

end

-- Noclip
Toggle("Noclip",y,"Noclip")
y+=40

RunService.Stepped:Connect(function()
if Settings.Noclip and LP.Character then
for _,v in pairs(LP.Character:GetDescendants()) do
if v:IsA("BasePart") then
v.CanCollide=false
end
end
end
end)

-- ESP (Red Glow)
Toggle("ESP",y,"ESP")
y+=40

task.spawn(function()

while true do
task.wait(0.5)

for _,p in pairs(Players:GetPlayers()) do

if p~=LP and p.Character then

local char=p.Character
local esp=char:FindFirstChild("Highlight")

if Settings.ESP then

if not esp then
esp=Instance.new("Highlight")
esp.Parent=char
esp.FillColor=Color3.fromRGB(255,0,0)
esp.OutlineColor=Color3.fromRGB(255,0,0)
esp.FillTransparency=0.5
esp.OutlineTransparency=0
end

else

if esp then
esp:Destroy()
end

end

end

end

end

end)

-- WallCheck
local function WallCheck(part)

local origin=Camera.CFrame.Position
local direction=(part.Position-origin)

local params=RaycastParams.new()
params.FilterType=Enum.RaycastFilterType.Blacklist
params.FilterDescendantsInstances={LP.Character,part.Parent}

local result=workspace:Raycast(origin,direction,params)

return result==nil

end

-- Target finder
local CurrentTarget=nil

task.spawn(function()

while true do
task.wait(0.08)

local closest=nil
local dist=Settings.FOV

for _,p in pairs(Players:GetPlayers()) do

if p~=LP and p.Character and p.Character:FindFirstChild("Head") then

local hum=p.Character:FindFirstChildOfClass("Humanoid")

if Settings.KillCheck then
if not hum or hum.Health<=0 then continue end
end

local head=p.Character.Head

if Settings.WallCheck and not WallCheck(head) then
continue
end

local pos,vis=Camera:WorldToViewportPoint(head.Position)

if vis then

local diff=(Vector2.new(pos.X,pos.Y)-circle.Position).Magnitude

if diff<dist then
dist=diff
closest=head
end

end

end

end

CurrentTarget=closest

end

end)

-- Aimbot
Toggle("Aimbot",y,"Aimbot")
y+=40

RunService.RenderStepped:Connect(function()

if Settings.Aimbot and CurrentTarget then

local targetCF=CFrame.new(Camera.CFrame.Position,CurrentTarget.Position)
Camera.CFrame=Camera.CFrame:Lerp(targetCF,Settings.Smooth)

end

end)

-- Silent Aim
Toggle("Silent Aim",y,"SilentAim")
y+=40

local mt=getrawmetatable(game)
local old=mt.__namecall
setreadonly(mt,false)

mt.__namecall=newcclosure(function(self,...)

local args={...}
local method=getnamecallmethod()

if Settings.SilentAim and CurrentTarget and method=="Raycast" then
args[2]=(CurrentTarget.Position-args[1]).Unit*1000
return old(self,unpack(args))
end

return old(self,...)

end)

setreadonly(mt,true)

Button("FOV +",y,function()
Settings.FOV+=10
end)

y+=40

Button("FOV -",y,function()
Settings.FOV=math.max(50,Settings.FOV-10)
end)

y+=40

Toggle("Wall Check",y,"WallCheck")
y+=40

Toggle("Kill Check",y,"KillCheck")
