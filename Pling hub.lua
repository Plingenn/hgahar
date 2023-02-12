local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Encounters ⚔️ Fighting", "DarkTheme")

--MAIN
local Main = Window:NewTab("Main")
local MainSection = Main:NewSection("Main")

MainSection:NewToggle("AutoBlock", "just AutoBlock", function(state)
    if state then
        _G.AutoBlock = true
    else
        _G.AutoBlock = false
    end
end)

MainSection:NewToggle("InfEnergy", "just InfEnergy", function(state)
    if state then
        _G.InfEnergy = true
    else
        _G.InfEnergy = false
    end
end)

MainSection:NewToggle("NoCooldown", "Gives you NoCooldown", function(state)
    if state then
        _G.NoCooldown = true
    else
        _G.NoCooldown = false
    end
end)

MainSection:NewButton("ESP", "Red box around players", function()
    local Player = game:GetService("Players").LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local Mouse = Player:GetMouse()
 
local function Dist(pointA, pointB) -- magnitude errors for some reason : (
return math.sqrt(math.pow(pointA.X - pointB.X, 2) + math.pow(pointA.Y - pointB.Y, 2))
end
 
local function GetClosest(points, dest)
local min = math.huge
local closest = nil
for _,v in pairs(points) do
local dist = Dist(v, dest)
if dist < min then
min = dist
closest = v
end
end
return closest
end
 
local function DrawESP(plr)
local Box = Drawing.new("Quad")
Box.Visible = true
Box.PointA = Vector2.new(0, 0)
Box.PointB = Vector2.new(0, 0)
Box.PointC = Vector2.new(0, 0)
Box.PointD = Vector2.new(0, 0)
Box.Color = Color3.fromRGB(255, 0, 47)
Box.Thickness = 2
Box.Transparency = 1
 
local function Update()
local c
c = game:GetService("RunService").RenderStepped:Connect(function()
if plr.Character ~= nil and plr.Character:FindFirstChildOfClass("Humanoid") ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 and plr.Character:FindFirstChild("Head") ~= nil then
local pos, vis = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
if vis then
local points = {}
local c = 0
for _,v in pairs(plr.Character:GetChildren()) do
if v:IsA("BasePart") then
c = c + 1
local p = Camera:WorldToViewportPoint(v.Position)
if v.Name == "HumanoidRootPart" then
p = Camera:WorldToViewportPoint((v.CFrame * CFrame.new(0, 0, -v.Size.Z)).p)
elseif v.Name == "Head" then
p = Camera:WorldToViewportPoint((v.CFrame * CFrame.new(0, v.Size.Y/2, v.Size.Z/1.25)).p)
elseif string.match(v.Name, "Left") then
p = Camera:WorldToViewportPoint((v.CFrame * CFrame.new(-v.Size.X/2, 0, 0)).p)
elseif string.match(v.Name, "Right") then
p = Camera:WorldToViewportPoint((v.CFrame * CFrame.new(v.Size.X/2, 0, 0)).p)
end
points[c] = p
end
end
local Left = GetClosest(points, Vector2.new(0, pos.Y))
local Right = GetClosest(points, Vector2.new(Camera.ViewportSize.X, pos.Y))
local Top = GetClosest(points, Vector2.new(pos.X, 0))
local Bottom = GetClosest(points, Vector2.new(pos.X, Camera.ViewportSize.Y))
 
if Left ~= nil and Right ~= nil and Top ~= nil and Bottom ~= nil then
Box.PointA = Vector2.new(Right.X, Top.Y)
Box.PointB = Vector2.new(Left.X, Top.Y)
Box.PointC = Vector2.new(Left.X, Bottom.Y)
Box.PointD = Vector2.new(Right.X, Bottom.Y)
 
Box.Visible = true
else
Box.Visible = false
end
else
Box.Visible = false
end
else
Box.Visible = false
if game.Players:FindFirstChild(plr.Name) == nil then
c:Disconnect()
end
end
end)
end
coroutine.wrap(Update)()
end
 
for _,v in pairs(game:GetService("Players"):GetChildren()) do
if v.Name ~= Player.Name then
DrawESP(v)
end
end
 
game:GetService("Players").PlayerAdded:Connect(function(v)
DrawESP(v)
end)
end)

MainSection:NewToggle("Aimbot!", "you already know what this is", function(state)
    if state then
        local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Holding = false

_G.AimbotEnabled = true
_G.TeamCheck = false -- If set to true then the script would only lock your aim at enemy team members.
_G.AimPart = "Head" -- Where the aimbot script would lock at.
_G.Sensitivity = 0 -- How many seconds it takes for the aimbot script to officially lock onto the target's aimpart.

_G.CircleSides = 64 -- How many sides the FOV circle would have.
_G.CircleColor = Color3.fromRGB(255, 255, 255) -- (RGB) Color that the FOV circle would appear as.
_G.CircleTransparency = 0.7 -- Transparency of the circle.
_G.CircleRadius = 120 -- The radius of the circle / FOV.
_G.CircleFilled = false -- Determines whether or not the circle is filled.
_G.CircleVisible = true -- Determines whether or not the circle is visible.
_G.CircleThickness = 0 -- The thickness of the circle.

local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = _G.CircleRadius
FOVCircle.Filled = _G.CircleFilled
FOVCircle.Color = _G.CircleColor
FOVCircle.Visible = _G.CircleVisible
FOVCircle.Radius = _G.CircleRadius
FOVCircle.Transparency = _G.CircleTransparency
FOVCircle.NumSides = _G.CircleSides
FOVCircle.Thickness = _G.CircleThickness

local function GetClosestPlayer()
	local MaximumDistance = _G.CircleRadius
	local Target = nil

	for _, v in next, Players:GetPlayers() do
		if v.Name ~= LocalPlayer.Name then
			if _G.TeamCheck == true then
				if v.Team ~= LocalPlayer.Team then
					if v.Character ~= nil then
						if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
							if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
								local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
								local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
								
								if VectorDistance < MaximumDistance then
									Target = v
								end
							end
						end
					end
				end
			else
				if v.Character ~= nil then
					if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
						if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
							local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
							local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
							
							if VectorDistance < MaximumDistance then
								Target = v
							end
						end
					end
				end
			end
		end
	end

	return Target
end

UserInputService.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = true
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = false
    end
end)

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    FOVCircle.Radius = _G.CircleRadius
    FOVCircle.Filled = _G.CircleFilled
    FOVCircle.Color = _G.CircleColor
    FOVCircle.Visible = _G.CircleVisible
    FOVCircle.Radius = _G.CircleRadius
    FOVCircle.Transparency = _G.CircleTransparency
    FOVCircle.NumSides = _G.CircleSides
    FOVCircle.Thickness = _G.CircleThickness

    if Holding == true and _G.AimbotEnabled == true then
        TweenService:Create(Camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, GetClosestPlayer().Character[_G.AimPart].Position)}):Play()
    end
end)
    else
        local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Holding = false

_G.AimbotEnabled = false
_G.TeamCheck = false -- If set to false then the script would only lock your aim at enemy team members.
_G.AimPart = "Head" -- Where the aimbot script would lock at.
_G.Sensitivity = 0 -- How many seconds it takes for the aimbot script to officially lock onto the target's aimpart.

_G.CircleSides = 64 -- How many sides the FOV circle would have.
_G.CircleColor = Color3.fromRGB(255, 255, 255) -- (RGB) Color that the FOV circle would appear as.
_G.CircleTransparency = 0.7 -- Transparency of the circle.
_G.CircleRadius = 80 -- The radius of the circle / FOV.
_G.CircleFilled = false -- Determines whether or not the circle is filled.
_G.CircleVisible = false -- Determines whether or not the circle is visible.
_G.CircleThickness = 0 -- The thickness of the circle.

local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = _G.CircleRadius
FOVCircle.Filled = _G.CircleFilled
FOVCircle.Color = _G.CircleColor
FOVCircle.Visible = _G.CircleVisible
FOVCircle.Radius = _G.CircleRadius
FOVCircle.Transparency = _G.CircleTransparency
FOVCircle.NumSides = _G.CircleSides
FOVCircle.Thickness = _G.CircleThickness

local function GetClosestPlayer()
	local MaximumDistance = _G.CircleRadius
	local Target = nil

	for _, v in next, Players:GetPlayers() do
		if v.Name ~= LocalPlayer.Name then
			if _G.TeamCheck == false then
				if v.Team ~= LocalPlayer.Team then
					if v.Character ~= nil then
						if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
							if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
								local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
								local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
								
								if VectorDistance < MaximumDistance then
									Target = v
								end
							end
						end
					end
				end
			else
				if v.Character ~= nil then
					if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
						if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
							local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
							local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
							
							if VectorDistance < MaximumDistance then
								Target = v
							end
						end
					end
				end
			end
		end
	end

	return Target
end

UserInputService.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = false
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = false
    end
end)

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    FOVCircle.Radius = _G.CircleRadius
    FOVCircle.Filled = _G.CircleFilled
    FOVCircle.Color = _G.CircleColor
    FOVCircle.Visible = _G.CircleVisible
    FOVCircle.Radius = _G.CircleRadius
    FOVCircle.Transparency = _G.CircleTransparency
    FOVCircle.NumSides = _G.CircleSides
    FOVCircle.Thickness = _G.CircleThickness

    if Holding == false and _G.AimbotEnabled == false then
        TweenService:Create(Camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, GetClosestPlayer().Character[_G.AimPart].Position)}):Play()
    end
end)
    end
end)




spawn(function()
a = hookfunction(wait, function(b) if b ~= 0 and tostring(getcallingscript(a)) ~= "nil" and tonumber(b) < 2.5 and _G.NoCooldown == true then return a() end return a(b) end)
end)

spawn(function()
local function CreateInstance(cls,props)
local inst = Instance.new(cls)
for i,v in pairs(props) do
	inst[i] = v
end
return inst
end

spawn(function()
wait(0.2)
if _G.AutoBlock then AutoBlock.Text = "Toggle Auto Block (On)" else AutoBlock.Text = "Toggle Auto Block (Off)" end
if _G.InfEnergy then InfEnergy.Text = "Toggle Infinite Energy (On)" else InfEnergy.Text = "Toggle Infinite Energy (Off)" end
if _G.NoCooldown then NoCooldown.Text = "Toggle No Cooldown (On)" else NoCooldown.Text = "Toggle No Cooldown (Off)" end
end)

AutoBlock.MouseButton1Click:Connect(function()
if _G.AutoBlock == true then _G.AutoBlock = false AutoBlock.Text = "Toggle Auto Block (Off)" elseif _G.AutoBlock == false then _G.AutoBlock = true AutoBlock.Text = "Toggle Auto Block (On)" end
end)

InfEnergy.MouseButton1Click:Connect(function()
if _G.InfEnergy == true then _G.InfEnergy = false InfEnergy.Text = "Toggle Infinite Energy (Off)" elseif _G.InfEnergy == false then _G.InfEnergy = true InfEnergy.Text = "Toggle Infinite Energy (On)" end
end)

NoCooldown.MouseButton1Click:Connect(function()
if _G.NoCooldown == true then _G.NoCooldown = false NoCooldown.Text = "Toggle No Cooldown (Off)" elseif _G.NoCooldown == false then _G.NoCooldown = true NoCooldown.Text = "Toggle No Cooldown (On)" end
end)
end)

name = tostring(game.Players.LocalPlayer.Name)
game:GetService("RunService").Heartbeat:Connect(function()
spawn(function()
if _G.AutoBlock == true then
wait()
game:GetService("ReplicatedStorage").RemoteEvents.ReplicateGuardOn:FireServer()
game:GetService("Workspace")[name].Guarding.Value = false
wait()
game:GetService("ReplicatedStorage").RemoteEvents.ReplicateGuardOff:FireServer()
end
end)

spawn(function()
if _G.InfEnergy then
game:GetService("Workspace")[name].Energy.Value = 97
end
end)
end)

--UI
local UI = Window:NewTab("UI")
local UISection = UI:NewSection("UI")

UISection:NewKeybind("Toggle UI", "Close and open the gui", Enum.KeyCode.RightShift, function()
	Library:ToggleUI()
end)

--Credits
local Credits = Window:NewTab("Credits")
local CreditsSection = Credits:NewSection("Credits")

CreditsSection:NewLabel("Made by Plingenn#9518")