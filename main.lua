if getgenv().FinalStableHub then return end
getgenv().FinalStableHub=true

local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")

local LP=Players.LocalPlayer
local Camera=workspace.CurrentCamera
local Mouse=LP:GetMouse()

-------------------------------------------------
-- SETTINGS
-------------------------------------------------

local Settings={
Fly=false,
Noclip=false,
ESP=false,
Aimbot=false,
SilentAim=false,
FlySpeed=80,
FOV=150
}

-------------------------------------------------
-- UI
-------------------------------------------------

local gui=Instance.new("ScreenGui",game.CoreGui)

local frame=Instance.new("Frame",gui)
frame.Size=UDim2.new(0,240,0,360)
frame.Position=UDim2.new(.5,-120,.5,-180)
frame.BackgroundColor3=Color3.fromRGB(25,25,25)
frame.Active=true
frame.Draggable=true
Instance.new("UICorner",frame)

local title=Instance.new("TextLabel",frame)
title.Size=UDim2.new(1,0,0,35)
title.BackgroundTransparency=1
title.Text="Final Hub"
title.TextColor3=Color3.fromRGB(0,170,255)
title.Font=Enum.Font.GothamBold
title.TextSize=18

local container=Instance.new("Frame",frame)
container.Size=UDim2.new(1,-20,1,-45)
container.Position=UDim2.new(0,10,0,40)
container.BackgroundTransparency=1

local layout=Instance.new("UIListLayout",container)
layout.Padding=UDim.new(0,6)

-------------------------------------------------
-- BUTTON
-------------------------------------------------

local function Toggle(text,setting)

local b=Instance.new("TextButton",container)
b.Size=UDim2.new(1,0,0,30)
b.BackgroundColor3=Color3.fromRGB(40,40,40)
b.TextColor3=Color3.new(1,1,1)
b.Font=Enum.Font.Gotham
b.TextSize=14
Instance.new("UICorner",b)

local function update()
b.Text = Settings[setting] and text.." ✔" or text
end

update()

b.MouseButton1Click:Connect(function()
Settings[setting]=not Settings[setting]
update()
end)

end

local function Button(text,func)

local b=Instance.new("TextButton",container)
b.Size=UDim2.new(1,0,0,30)
b.BackgroundColor3=Color3.fromRGB(40,40,40)
b.TextColor3=Color3.new(1,1,1)
b.Font=Enum.Font.Gotham
b.TextSize=14
Instance.new("UICorner",b)

b.MouseButton1Click:Connect(func)

end

-------------------------------------------------
-- HIDE
-------------------------------------------------

local hide=Instance.new("TextButton",gui)
hide.Size=UDim2.new(0,24,0,24)
hide.Position=UDim2.new(0,6,0,6)
hide.BackgroundTransparency=0.4
hide.BackgroundColor3=Color3.fromRGB(30,30,30)
hide.Text="-"
Instance.new("UICorner",hide)

hide.MouseButton1Click:Connect(function()
frame.Visible=not frame.Visible
end)

UIS.InputBegan:Connect(function(i,g)
if g then return end
if i.KeyCode==Enum.KeyCode.K then
frame.Visible=not frame.Visible
end
end)

-------------------------------------------------
-- FOV CIRCLE
-------------------------------------------------

local circle=Drawing.new("Circle")
circle.Color=Color3.fromRGB(0,170,255)
circle.Thickness=2
circle.Filled=false

RunService.RenderStepped:Connect(function()

circle.Position=Vector2.new(
Camera.ViewportSize.X/2,
Camera.ViewportSize.Y/2
)

circle.Radius=Settings.FOV
circle.Visible=Settings.Aimbot or Settings.SilentAim

end)

-------------------------------------------------
-- FLY
-------------------------------------------------

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
local cam=Camera.CFrame

flyBV.Velocity=
(cam.LookVector*move.Z +
cam.RightVector*move.X)
*Settings.FlySpeed

end

else

if flyBV then
flyBV:Destroy()
flyBV=nil
end

end

end)

-------------------------------------------------
-- NOCLIP
-------------------------------------------------

RunService.Stepped:Connect(function()

if Settings.Noclip and LP.Character then

for _,v in pairs(LP.Character:GetDescendants()) do
if v:IsA("BasePart") then
v.CanCollide=false
end
end

end

end)

-------------------------------------------------
-- ESP
-------------------------------------------------

spawn(function()

while task.wait(0.4) do

for _,p in pairs(Players:GetPlayers()) do

if p~=LP and p.Character then

local h=p.Character:FindFirstChild("Highlight")

if Settings.ESP then

if not h then
h=Instance.new("Highlight")
h.Parent=p.Character
end

if p.Team==LP.Team then
h.FillColor=Color3.fromRGB(0,255,0)
else
h.FillColor=Color3.fromRGB(255,0,0)
end

else

if h then
h:Destroy()
end

end

end

end

end

end)

-------------------------------------------------
-- TARGET
-------------------------------------------------

local function GetTarget()

local closest=nil
local dist=Settings.FOV

for _,p in pairs(Players:GetPlayers()) do

if p~=LP and p.Character and p.Character:FindFirstChild("Head") then

local pos,vis=Camera:WorldToViewportPoint(p.Character.Head.Position)

if vis then

local diff=(Vector2.new(pos.X,pos.Y)-
Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude

if diff<dist then
dist=diff
closest=p.Character.Head
end

end

end

end

return closest

end

-------------------------------------------------
-- AIMBOT
-------------------------------------------------

RunService.RenderStepped:Connect(function()

if Settings.Aimbot then

local t=GetTarget()

if t then
Camera.CFrame=CFrame.new(Camera.CFrame.Position,t.Position)
end

end

end)

-------------------------------------------------
-- SILENT AIM
-------------------------------------------------

local mt=getrawmetatable(game)
local old=mt.__index
setreadonly(mt,false)

mt.__index=newcclosure(function(self,key)

if self==Mouse and key=="Hit" and Settings.SilentAim then

local t=GetTarget()

if t then
return CFrame.new(t.Position)
end

end

return old(self,key)

end)

setreadonly(mt,true)

-------------------------------------------------
-- BUTTONS
-------------------------------------------------

Toggle("Fly","Fly")
Toggle("Noclip","Noclip")
Toggle("ESP","ESP")
Toggle("Aimbot","Aimbot")
Toggle("Silent Aim","SilentAim")

Button("Fly Speed +",function()
Settings.FlySpeed+=20
end)

Button("Fly Speed -",function()
Settings.FlySpeed=math.max(20,Settings.FlySpeed-20)
end)

Button("FOV +",function()
Settings.FOV+=20
end)

Button("FOV -",function()
Settings.FOV=math.max(50,Settings.FOV-20)
end)
