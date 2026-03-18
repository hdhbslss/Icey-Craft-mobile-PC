if getgenv().StableHubESP then return end
getgenv().StableHubESP=true

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

-------------------------------------------------
-- UI
-------------------------------------------------

local gui=Instance.new("ScreenGui",game.CoreGui)

local frame=Instance.new("Frame",gui)
frame.Size=UDim2.new(0,230,0,440)
frame.Position=UDim2.new(.5,-115,.5,-220)
frame.BackgroundColor3=Color3.fromRGB(25,25,25)
frame.Active=true
frame.Draggable=true
Instance.new("UICorner",frame)

local title=Instance.new("TextLabel",frame)
title.Size=UDim2.new(1,0,0,40)
title.BackgroundTransparency=1
title.Text="Stable Hub"
title.TextColor3=Color3.fromRGB(0,170,255)
title.Font=Enum.Font.GothamBold
title.TextSize=20

-- mobile hide
local mobile=Instance.new("TextButton",gui)
mobile.Size=UDim2.new(0,40,0,40)
mobile.Position=UDim2.new(.5,-20,0,10)
mobile.Text="-"

mobile.MouseButton1Click:Connect(function()
frame.Visible=not frame.Visible
end)

-- pc hide
UIS.InputBegan:Connect(function(i,g)
if g then return end
if i.KeyCode==Enum.KeyCode.K then
frame.Visible=not frame.Visible
end
end)

-------------------------------------------------
-- BUTTON SYSTEM
-------------------------------------------------

local function Button(text,y,func)

local b=Instance.new("TextButton",frame)
b.Size=UDim2.new(0,190,0,30)
b.Position=UDim2.new(0,20,0,y)
b.Text=text
b.BackgroundColor3=Color3.fromRGB(35,35,35)
b.TextColor3=Color3.new(1,1,1)

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
end)

end

-------------------------------------------------
-- ESP SYSTEM
-------------------------------------------------

local ESPFolder=Instance.new("Folder")
ESPFolder.Name="ESP"
ESPFolder.Parent=game.CoreGui

local function CreateESP(player)

if player==LP then return end

local function add(char)

local old=ESPFolder:FindFirstChild(player.Name)
if old then old:Destroy() end

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

-- ESP update
RunService.RenderStepped:Connect(function()

for _,h in pairs(ESPFolder:GetChildren()) do

local player=Players:FindFirstChild(h.Name)

if player and player.Character then

if Settings.ESP then

if player.Team==LP.Team then
h.FillColor=Color3.fromRGB(0,255,0)
else
h.FillColor=Color3.fromRGB(255,0,0)
end

h.Enabled=true

else
h.Enabled=false
end

end

end

end)

-------------------------------------------------
-- WALL CHECK
-------------------------------------------------

local function WallCheck(part)

local origin=Camera.CFrame.Position
local dir=(part.Position-origin)

local params=RaycastParams.new()
params.FilterType=Enum.RaycastFilterType.Blacklist
params.FilterDescendantsInstances={LP.Character}

local ray=workspace:Raycast(origin,dir,params)

if ray then
return ray.Instance:IsDescendantOf(part.Parent)
end

return true

end

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

Button("FOV +",420,function()
Settings.FOV+=10
end)

Button("FOV -",460,function()
Settings.FOV=math.max(50,Settings.FOV-10)
end)
