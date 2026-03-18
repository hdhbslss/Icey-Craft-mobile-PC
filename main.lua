if getgenv().ModernStableHub then return end
getgenv().ModernStableHub=true

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
-- UI SYSTEM
-------------------------------------------------

local gui=Instance.new("ScreenGui")
gui.Name="ModernHub"
gui.Parent=game.CoreGui

local frame=Instance.new("Frame",gui)
frame.Size=UDim2.new(0,260,0,420)
frame.Position=UDim2.new(.5,-130,.5,-210)
frame.BackgroundColor3=Color3.fromRGB(20,20,20)
frame.Active=true
frame.Draggable=true
Instance.new("UICorner",frame)

local stroke=Instance.new("UIStroke",frame)
stroke.Color=Color3.fromRGB(0,170,255)

local title=Instance.new("TextLabel",frame)
title.Size=UDim2.new(1,0,0,40)
title.BackgroundTransparency=1
title.Text="Modern Script Hub"
title.TextColor3=Color3.fromRGB(0,170,255)
title.Font=Enum.Font.GothamBold
title.TextSize=20

-------------------------------------------------
-- BUTTON CONTAINER
-------------------------------------------------

local container=Instance.new("Frame",frame)
container.Size=UDim2.new(1,-20,1,-50)
container.Position=UDim2.new(0,10,0,45)
container.BackgroundTransparency=1

local layout=Instance.new("UIListLayout",container)
layout.Padding=UDim.new(0,8)

-------------------------------------------------
-- TOGGLE BUTTON
-------------------------------------------------

local function Toggle(text,setting)

local b=Instance.new("TextButton",container)
b.Size=UDim2.new(1,0,0,32)
b.BackgroundColor3=Color3.fromRGB(35,35,35)
b.TextColor3=Color3.new(1,1,1)
b.Font=Enum.Font.Gotham
b.TextSize=14
b.Text=text

Instance.new("UICorner",b)

local function update()

if Settings[setting] then
b.Text=text.." ✔"
b.TextColor3=Color3.fromRGB(0,255,120)
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

local function Button(text,func)

local b=Instance.new("TextButton",container)
b.Size=UDim2.new(1,0,0,32)
b.BackgroundColor3=Color3.fromRGB(35,35,35)
b.TextColor3=Color3.new(1,1,1)
b.Font=Enum.Font.Gotham
b.TextSize=14
b.Text=text

Instance.new("UICorner",b)

b.MouseButton1Click:Connect(func)

end

-------------------------------------------------
-- MOBILE HIDE BUTTON
-------------------------------------------------

local hide=Instance.new("TextButton",gui)
hide.Size=UDim2.new(0,26,0,26)
hide.Position=UDim2.new(0,8,0,8)

hide.BackgroundColor3=Color3.fromRGB(30,30,30)
hide.BackgroundTransparency=0.35

hide.Text="-"
hide.TextColor3=Color3.fromRGB(200,200,200)
hide.Font=Enum.Font.GothamBold
hide.TextSize=18

Instance.new("UICorner",hide)

hide.MouseButton1Click:Connect(function()
frame.Visible=not frame.Visible
end)

-------------------------------------------------
-- PC HIDE
-------------------------------------------------

UIS.InputBegan:Connect(function(i,g)

if g then return end

if i.KeyCode==Enum.KeyCode.K then
frame.Visible=not frame.Visible
end

end)

-------------------------------------------------
-- FLY SYSTEM
-------------------------------------------------

local control={F=0,B=0,L=0,R=0,U=0,D=0}
local flyBV=nil

UIS.InputBegan:Connect(function(i,g)
if g then return end

if i.KeyCode==Enum.KeyCode.W then control.F=1 end
if i.KeyCode==Enum.KeyCode.S then control.B=-1 end
if i.KeyCode==Enum.KeyCode.A then control.L=-1 end
if i.KeyCode==Enum.KeyCode.D then control.R=1 end
if i.KeyCode==Enum.KeyCode.Space then control.U=1 end
if i.KeyCode==Enum.KeyCode.LeftShift then control.D=-1 end

end)

UIS.InputEnded:Connect(function(i)

if i.KeyCode==Enum.KeyCode.W then control.F=0 end
if i.KeyCode==Enum.KeyCode.S then control.B=0 end
if i.KeyCode==Enum.KeyCode.A then control.L=0 end
if i.KeyCode==Enum.KeyCode.D then control.R=0 end
if i.KeyCode==Enum.KeyCode.Space then control.U=0 end
if i.KeyCode==Enum.KeyCode.LeftShift then control.D=0 end

end)

RunService.Heartbeat:Connect(function()

if Settings.Fly and LP.Character then

local hrp=LP.Character:FindFirstChild("HumanoidRootPart")

if hrp then

if not flyBV then
flyBV=Instance.new("BodyVelocity")
flyBV.MaxForce=Vector3.new(1e9,1e9,1e9)
flyBV.Parent=hrp
end

local cam=Camera.CFrame

local move=
(cam.LookVector*(control.F+control.B))+
(cam.RightVector*(control.R+control.L))+
(Vector3.new(0,1,0)*(control.U+control.D))

flyBV.Velocity=move*Settings.FlySpeed

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

local ESPFolder=Instance.new("Folder",game.CoreGui)

local function CreateESP(player)

if player==LP then return end

local function add(char)

local h=Instance.new("Highlight")
h.Name=player.Name
h.Parent=ESPFolder
h.Adornee=char

end

if player.Character then
add(player.Character)
end

player.CharacterAdded:Connect(add)

end

for _,p in pairs(Players:GetPlayers()) do
CreateESP(p)
end

Players.PlayerAdded:Connect(CreateESP)

RunService.RenderStepped:Connect(function()

for _,h in pairs(ESPFolder:GetChildren()) do

local p=Players:FindFirstChild(h.Name)

if p and Settings.ESP then

if p.Team==LP.Team then
h.FillColor=Color3.fromRGB(0,255,0)
else
h.FillColor=Color3.fromRGB(255,0,0)
end

h.Enabled=true

else
h.Enabled=false
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

local hum=p.Character:FindFirstChildOfClass("Humanoid")

if Settings.KillCheck and (not hum or hum.Health<=0) then
continue
end

local head=p.Character.Head

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

-------------------------------------------------
-- AIMBOT
-------------------------------------------------

RunService.RenderStepped:Connect(function()

if Settings.Aimbot then

local target=GetTarget()

if target then
Camera.CFrame=CFrame.new(Camera.CFrame.Position,target.Position)
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
Toggle("Wall Check","WallCheck")
Toggle("Kill Check","KillCheck")

Button("Fly Speed +",function()
Settings.FlySpeed+=20
end)

Button("Fly Speed -",function()
Settings.FlySpeed=math.max(20,Settings.FlySpeed-20)
end)

Button("FOV +",function()
Settings.FOV+=10
end)

Button("FOV -",function()
Settings.FOV=math.max(50,Settings.FOV-10)
end)
