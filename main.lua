if getgenv().TabHub then return end
getgenv().TabHub=true

local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")

local LP=Players.LocalPlayer
local Camera=workspace.CurrentCamera

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
-- UI BASE
-------------------------------------------------

local gui=Instance.new("ScreenGui",game.CoreGui)

local frame=Instance.new("Frame",gui)
frame.Size=UDim2.new(0,420,0,300)
frame.Position=UDim2.new(.5,-210,.5,-150)
frame.BackgroundColor3=Color3.fromRGB(18,18,18)
frame.Active=true
frame.Draggable=true
Instance.new("UICorner",frame)

local stroke=Instance.new("UIStroke",frame)
stroke.Color=Color3.fromRGB(0,170,255)

local title=Instance.new("TextLabel",frame)
title.Size=UDim2.new(1,0,0,40)
title.BackgroundTransparency=1
title.Text="Script Hub"
title.TextColor3=Color3.fromRGB(0,170,255)
title.Font=Enum.Font.GothamBold
title.TextSize=20

-------------------------------------------------
-- SIDEBAR
-------------------------------------------------

local sidebar=Instance.new("Frame",frame)
sidebar.Size=UDim2.new(0,120,1,-40)
sidebar.Position=UDim2.new(0,0,0,40)
sidebar.BackgroundColor3=Color3.fromRGB(25,25,25)

local pages=Instance.new("Frame",frame)
pages.Size=UDim2.new(1,-120,1,-40)
pages.Position=UDim2.new(0,120,0,40)
pages.BackgroundTransparency=1

-------------------------------------------------
-- PAGE SYSTEM
-------------------------------------------------

local function CreatePage(name)

local page=Instance.new("Frame",pages)
page.Size=UDim2.new(1,0,1,0)
page.Visible=false
page.BackgroundTransparency=1

local btn=Instance.new("TextButton",sidebar)
btn.Size=UDim2.new(1,0,0,40)
btn.Text=name
btn.BackgroundColor3=Color3.fromRGB(35,35,35)
btn.TextColor3=Color3.new(1,1,1)

btn.MouseButton1Click:Connect(function()

for _,p in pairs(pages:GetChildren()) do
p.Visible=false
end

page.Visible=true

end)

return page
end

local Combat=CreatePage("Combat")
local Visual=CreatePage("Visual")
local Move=CreatePage("Movement")
local Misc=CreatePage("Misc")

Combat.Visible=true

-------------------------------------------------
-- BUTTON SYSTEM
-------------------------------------------------

local function Toggle(parent,text,y,setting)

local b=Instance.new("TextButton",parent)
b.Size=UDim2.new(0,200,0,30)
b.Position=UDim2.new(0,20,0,y)
b.BackgroundColor3=Color3.fromRGB(40,40,40)
b.TextColor3=Color3.new(1,1,1)
b.Text=text

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

-------------------------------------------------
-- COMBAT PAGE
-------------------------------------------------

Toggle(Combat,"Aimbot",20,"Aimbot")
Toggle(Combat,"Silent Aim",60,"SilentAim")
Toggle(Combat,"Wall Check",100,"WallCheck")
Toggle(Combat,"Kill Check",140,"KillCheck")

-------------------------------------------------
-- VISUAL PAGE
-------------------------------------------------

Toggle(Visual,"ESP",20,"ESP")

-------------------------------------------------
-- MOVE PAGE
-------------------------------------------------

Toggle(Move,"Fly",20,"Fly")

-------------------------------------------------
-- MISC PAGE
-------------------------------------------------

Toggle(Misc,"Noclip",20,"Noclip")

-------------------------------------------------
-- HIDE UI
-------------------------------------------------

UIS.InputBegan:Connect(function(i,g)

if g then return end

if i.KeyCode==Enum.KeyCode.K then
frame.Visible=not frame.Visible
end

end)
