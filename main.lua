if getgenv().StableModernHub then return end
getgenv().StableModernHub=true

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

local gui=Instance.new("ScreenGui")
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
title.Text="Stable Hub"
title.TextColor3=Color3.fromRGB(0,170,255)
title.Font=Enum.Font.GothamBold
title.TextSize=20

-------------------------------------------------
-- MOBILE BUTTON
-------------------------------------------------

local mobile=Instance.new("TextButton",gui)
mobile.Size=UDim2.new(0,40,0,40)
mobile.Position=UDim2.new(.5,-20,0,10)
mobile.Text="-"
mobile.BackgroundColor3=Color3.fromRGB(35,35,35)

mobile.MouseButton1Click:Connect(function()
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
-- BUTTON SYSTEM
-------------------------------------------------

local function Toggle(text,y,setting)

local b=Instance.new("TextButton",frame)
b.Size=UDim2.new(0,210,0,32)
b.Position=UDim2.new(0,25,0,y)
b.BackgroundColor3=Color3.fromRGB(35,35,35)
b.Text=text
b.TextColor3=Color3.new(1,1,1)

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

local function Button(text,y,func)

local b=Instance.new("TextButton",frame)
b.Size=UDim2.new(0,210,0,32)
b.Position=UDim2.new(0,25,0,y)
b.BackgroundColor3=Color3.fromRGB(35,35,35)
b.Text=text
b.TextColor3=Color3.new(1,1,1)

Instance.new("UICorner",b)

b.MouseButton1Click:Connect(func)

end

-------------------------------------------------
-- FLY
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
-- BUTTONS
-------------------------------------------------

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
