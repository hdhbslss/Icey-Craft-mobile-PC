if getgenv().CrossPlatformHub then return end
getgenv().CrossPlatformHub=true

local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")

local LP=Players.LocalPlayer
local Camera=workspace.CurrentCamera
local Mouse=LP:GetMouse()

local Settings={
Fly=false,
Noclip=false,
ESP=false,
Aimbot=false,
SilentAim=false,
WallCheck=true,
KillCheck=true,
FlySpeed=80,
FOV=150
}

-- UI
local gui=Instance.new("ScreenGui",game.CoreGui)

local frame=Instance.new("Frame",gui)
frame.Size=UDim2.new(0,240,0,440)
frame.Position=UDim2.new(.5,-120,.5,-220)
frame.BackgroundColor3=Color3.fromRGB(25,25,25)
frame.Active=true
frame.Draggable=true
Instance.new("UICorner",frame)

local title=Instance.new("TextLabel",frame)
title.Size=UDim2.new(1,0,0,40)
title.BackgroundTransparency=1
title.Text="Cross Hub"
title.TextColor3=Color3.fromRGB(0,170,255)
title.Font=Enum.Font.GothamBold
title.TextSize=20

-- Mobile Hide
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

-- PC Hide
UIS.InputBegan:Connect(function(i,g)
if g then return end
if i.KeyCode==Enum.KeyCode.K then
frame.Visible=not frame.Visible
end
end)

-- Button
local function Button(text,y,func)

local b=Instance.new("TextButton",frame)
b.Size=UDim2.new(0,200,0,30)
b.Position=UDim2.new(0,20,0,y)
b.BackgroundColor3=Color3.fromRGB(35,35,35)
b.TextColor3=Color3.new(1,1,1)
b.Text=text
Instance.new("UICorner",b)

b.MouseButton1Click:Connect(func)

return b
end

-- Toggle
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
end)

end

-- Fly (PC + Mobile)
local flyBV=nil

RunService.Heartbeat:Connect(function()

if Settings.Fly and LP.Character then

local hrp=LP.Character:FindFirstChild("HumanoidRootPart")
local hum=LP.Character:FindFirstChildOfClass("Humanoid")

if hrp and hum then

if not flyBV then
flyBV=Instance.new("BodyVelocity")
flyBV.MaxForce=Vector3.new(1e9,1e9,1e9)
flyBV.Parent=hrp
end

local move=hum.MoveDirection
flyBV.Velocity=Vector3.new(move.X,0,move.Z)*Settings.FlySpeed

end

else

if flyBV then
flyBV:Destroy()
flyBV=nil
end

end

end)

-- Noclip
RunService.Stepped:Connect(function()

if Settings.Noclip and LP.Character then
for _,v in pairs(LP.Character:GetDescendants()) do
if v:IsA("BasePart") then
v.CanCollide=false
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

if result then
return false
end

return true

end

-- Target
local function GetTarget()

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

local diff=(Vector2.new(pos.X,pos.Y)-
Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude

if diff<dist then
dist=diff
closest=head
end

end

end

end

return closest

end

-- Aimbot
RunService.RenderStepped:Connect(function()

if Settings.Aimbot then

local target=GetTarget()

if target then
Camera.CFrame=CFrame.new(Camera.CFrame.Position,target.Position)
end

end

end)

-- Silent Aim
local mt=getrawmetatable(game)
local old=mt.__index
setreadonly(mt,false)

mt.__index=newcclosure(function(self,key)

if self==Mouse and key=="Hit" and Settings.SilentAim then

local target=GetTarget()

if target then
return CFrame.new(target.Position)
end

end

return old(self,key)

end)

setreadonly(mt,true)

-- Buttons
Toggle("Fly",60,"Fly")
Toggle("Noclip",100,"Noclip")
Toggle("ESP",140,"ESP")
Toggle("Aimbot",180,"Aimbot")
Toggle("Silent Aim",220,"SilentAim")
Toggle("Wall Check",260,"WallCheck")
Toggle("Kill Check",300,"KillCheck")

Button("Fly Speed +",340,function()
Settings.FlySpeed+=20
end)

Button("Fly Speed -",380,function()
Settings.FlySpeed=math.max(20,Settings.FlySpeed-20)
end)

Button("FOV +",420,function()
Settings.FOV+=10
end)

Button("FOV -",460,function()
Settings.FOV=math.max(50,Settings.FOV-10)
end)
