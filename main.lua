if getgenv().SimpleHub then return end
getgenv().SimpleHub=true

local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")

local LP=Players.LocalPlayer
local Camera=workspace.CurrentCamera

local Settings={
Aimbot=false,
ESP=false,
Fly=false,
Noclip=false,
FlySpeed=80
}

-- UI
local gui=Instance.new("ScreenGui",game.CoreGui)

local frame=Instance.new("Frame",gui)
frame.Size=UDim2.new(0,220,0,320)
frame.Position=UDim2.new(.5,-110,.5,-160)
frame.BackgroundColor3=Color3.fromRGB(25,25,25)
frame.Active=true
frame.Draggable=true
Instance.new("UICorner",frame)

local title=Instance.new("TextLabel",frame)
title.Size=UDim2.new(1,0,0,40)
title.BackgroundTransparency=1
title.Text="Simple Hub"
title.TextColor3=Color3.fromRGB(0,170,255)
title.Font=Enum.Font.GothamBold
title.TextSize=20

-- Hide Button (mobile)
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

-- Hide Key (PC)
UIS.InputBegan:Connect(function(i,g)
if g then return end
if i.KeyCode==Enum.KeyCode.K then
frame.Visible=not frame.Visible
end
end)

-- Button
local function Toggle(text,y,setting)

local b=Instance.new("TextButton",frame)
b.Size=UDim2.new(0,180,0,30)
b.Position=UDim2.new(0,20,0,y)
b.BackgroundColor3=Color3.fromRGB(35,35,35)
b.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",b)

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

-- Fly
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

-- ESP
local function AddESP(p)

if p==LP then return end

p.CharacterAdded:Connect(function(char)

local h=Instance.new("Highlight")
h.Parent=char

RunService.RenderStepped:Connect(function()

if Settings.ESP then

if p.Team==LP.Team then
h.FillColor=Color3.fromRGB(0,255,0)
else
h.FillColor=Color3.fromRGB(255,0,0)
end

h.Enabled=true

else

h.Enabled=false

end

end)

end)

end

for _,p in pairs(Players:GetPlayers()) do
AddESP(p)
end

Players.PlayerAdded:Connect(AddESP)

-- Aimbot
local function GetTarget()

local closest=nil
local dist=200

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

RunService.RenderStepped:Connect(function()

if Settings.Aimbot then

local target=GetTarget()

if target then
Camera.CFrame=CFrame.new(Camera.CFrame.Position,target.Position)
end

end

end)

-- Buttons
Toggle("Fly",60,"Fly")
Toggle("Noclip",100,"Noclip")
Toggle("ESP",140,"ESP")
Toggle("Aimbot",180,"Aimbot")
