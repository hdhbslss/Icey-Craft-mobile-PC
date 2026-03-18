if getgenv().LiteHub then return end
getgenv().LiteHub=true

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
WallCheck=true,
KillCheck=true,
FlySpeed=80,
FOV=150
}

-------------------------------------------------
-- UI
-------------------------------------------------

local gui=Instance.new("ScreenGui",game.CoreGui)

local frame=Instance.new("Frame",gui)
frame.Size=UDim2.new(0,220,0,320)
frame.Position=UDim2.new(.5,-110,.5,-160)
frame.BackgroundColor3=Color3.fromRGB(25,25,25)
frame.Active=true
frame.Draggable=true
Instance.new("UICorner",frame)

local layout=Instance.new("UIListLayout",frame)
layout.Padding=UDim.new(0,6)

-------------------------------------------------
-- BUTTON
-------------------------------------------------

local function Toggle(name,setting)

local b=Instance.new("TextButton",frame)
b.Size=UDim2.new(1,-10,0,30)
b.BackgroundColor3=Color3.fromRGB(35,35,35)
b.TextColor3=Color3.new(1,1,1)
b.Font=Enum.Font.Gotham
b.TextSize=14
Instance.new("UICorner",b)

local function refresh()

if Settings[setting] then
b.Text=name.." ✔"
else
b.Text=name
end

end

refresh()

b.MouseButton1Click:Connect(function()

Settings[setting]=not Settings[setting]
refresh()

end)

end

local function Button(name,func)

local b=Instance.new("TextButton",frame)
b.Size=UDim2.new(1,-10,0,30)
b.BackgroundColor3=Color3.fromRGB(35,35,35)
b.TextColor3=Color3.new(1,1,1)
b.Font=Enum.Font.Gotham
b.TextSize=14
b.Text=name
Instance.new("UICorner",b)

b.MouseButton1Click:Connect(func)

end

-------------------------------------------------
-- HIDE UI
-------------------------------------------------

local hide=Instance.new("TextButton",gui)
hide.Size=UDim2.new(0,24,0,24)
hide.Position=UDim2.new(0,6,0,6)
hide.BackgroundColor3=Color3.fromRGB(25,25,25)
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
-- FOV
-------------------------------------------------

local circle=Drawing.new("Circle")
circle.Thickness=2
circle.Filled=false
circle.Color=Color3.fromRGB(0,170,255)

-------------------------------------------------
-- TARGET
-------------------------------------------------

local function GetTarget()

local closest=nil
local dist=Settings.FOV

for _,p in pairs(Players:GetPlayers()) do

if p~=LP and p.Character and p.Character:FindFirstChild("Head") then

local hum=p.Character:FindFirstChildOfClass("Humanoid")

if Settings.KillCheck and (not hum or hum.Health<=0) then
continue
end

local head=p.Character.Head

local pos,vis=Camera:WorldToViewportPoint(head.Position)

if vis then

local diff=(Vector2.new(pos.X,pos.Y)
-Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude

if diff<dist then
dist=diff
closest=head
end

end

end

end

return closest

end

-------------------------------------------------
-- MAIN LOOP
-------------------------------------------------

RunService.RenderStepped:Connect(function()

circle.Position=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
circle.Radius=Settings.FOV
circle.Visible=Settings.Aimbot

if Settings.Aimbot then

local t=GetTarget()

if t then
Camera.CFrame=CFrame.new(Camera.CFrame.Position,t.Position)
end

end

end)

-------------------------------------------------
-- FLY
-------------------------------------------------

local BV=nil

RunService.Heartbeat:Connect(function()

if Settings.Fly and LP.Character then

local hrp=LP.Character:FindFirstChild("HumanoidRootPart")
local hum=LP.Character:FindFirstChildOfClass("Humanoid")

if hrp and hum then

if not BV then
BV=Instance.new("BodyVelocity")
BV.MaxForce=Vector3.new(1e9,1e9,1e9)
BV.Parent=hrp
end

BV.Velocity=
(Camera.CFrame.LookVector*hum.MoveDirection.Z+
Camera.CFrame.RightVector*hum.MoveDirection.X)
*Settings.FlySpeed

end

else

if BV then
BV:Destroy()
BV=nil
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
Settings.FlySpeed-=20
end)

Button("FOV +",function()
Settings.FOV+=20
end)

Button("FOV -",function()
Settings.FOV-=20
end)
