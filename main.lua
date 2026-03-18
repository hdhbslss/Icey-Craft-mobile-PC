if getgenv().FinalCombatHub then return end
getgenv().FinalCombatHub=true

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
frame.Size=UDim2.new(0,240,0,360)
frame.Position=UDim2.new(.5,-120,.5,-180)
frame.BackgroundColor3=Color3.fromRGB(30,30,30)
frame.Active=true
frame.Draggable=true

local layout=Instance.new("UIListLayout",frame)
layout.Padding=UDim.new(0,6)

-------------------------------------------------
-- BUTTON SYSTEM
-------------------------------------------------

local function Toggle(name,setting)

local b=Instance.new("TextButton",frame)
b.Size=UDim2.new(1,-10,0,30)
b.BackgroundColor3=Color3.fromRGB(40,40,40)
b.TextColor3=Color3.new(1,1,1)
b.Font=Enum.Font.SourceSans
b.TextSize=16

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
b.BackgroundColor3=Color3.fromRGB(40,40,40)
b.TextColor3=Color3.new(1,1,1)
b.Font=Enum.Font.SourceSans
b.TextSize=16
b.Text=name

b.MouseButton1Click:Connect(func)

end

-------------------------------------------------
-- HIDE UI
-------------------------------------------------

local hide=Instance.new("TextButton",gui)
hide.Size=UDim2.new(0,24,0,24)
hide.Position=UDim2.new(0,6,0,6)
hide.BackgroundColor3=Color3.fromRGB(30,30,30)
hide.Text="-"

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
circle.Thickness=2
circle.Filled=false
circle.Color=Color3.fromRGB(0,170,255)

RunService.RenderStepped:Connect(function()

circle.Position=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
circle.Radius=Settings.FOV
circle.Visible=Settings.Aimbot

end)

-------------------------------------------------
-- TARGET SYSTEM
-------------------------------------------------

local function GetTarget()

local closest=nil
local shortest=Settings.FOV

for _,p in pairs(Players:GetPlayers()) do

if p~=LP and p.Character and p.Character:FindFirstChild("Head") then

local hum=p.Character:FindFirstChildOfClass("Humanoid")

-- Kill Check
if Settings.KillCheck then
if not hum or hum.Health<=0 then
continue
end
end

local head=p.Character.Head

-- Wall Check
if Settings.WallCheck then

local rayParams=RaycastParams.new()
rayParams.FilterType=Enum.RaycastFilterType.Blacklist
rayParams.FilterDescendantsInstances={LP.Character}

local ray=workspace:Raycast(
Camera.CFrame.Position,
(head.Position-Camera.CFrame.Position).Unit*500,
rayParams
)

if ray and ray.Instance and not head:IsDescendantOf(ray.Instance.Parent) then
continue
end

end

local pos,visible=Camera:WorldToViewportPoint(head.Position)

if visible then

local dist=(Vector2.new(pos.X,pos.Y)
-Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude

if dist<shortest then
shortest=dist
closest=head
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
-- ESP
-------------------------------------------------

local function AddESP(plr)

if plr==LP then return end

plr.CharacterAdded:Connect(function(char)

if Settings.ESP then

local h=Instance.new("Highlight")
h.Parent=char

if plr.Team==LP.Team then
h.FillColor=Color3.fromRGB(0,255,0)
else
h.FillColor=Color3.fromRGB(255,0,0)
end

end

end)

end

for _,p in pairs(Players:GetPlayers()) do
AddESP(p)
end

Players.PlayerAdded:Connect(AddESP)

-------------------------------------------------
-- BUTTONS
-------------------------------------------------

Toggle("Fly","Fly")
Toggle("Noclip","Noclip")
Toggle("ESP","ESP")
Toggle("Aimbot","Aimbot")
Toggle("Silent Aim","SilentAim")
Toggle("Wall Check","WallCheck")
Toggle("Kill Check","KillCheck")

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
