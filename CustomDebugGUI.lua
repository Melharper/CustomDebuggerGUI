-- Debugging Script with GUI Display (Clears Logs on New Run)
local remote = game:GetService("ReplicatedStorage"):WaitForChild("ClientModules"):WaitForChild("Network"):WaitForChild("RemoteFunction")

-- Clear any existing debug GUI
if game.Players.LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("DebugOutputGUI") then
    game.Players.LocalPlayer.PlayerGui.DebugOutputGUI:Destroy()
end

local output = {} -- Table to store all logs

-- Function to log environment details
local function logEnvironment()
    table.insert(output, "Current Environment:")
    for i, v in pairs(getfenv(0)) do
        table.insert(output, tostring(i) .. " = " .. tostring(v))
    end
end

-- Attempt to invoke the remote and log results
local success, result = pcall(function()
    logEnvironment() -- Log the environment before invocation
    return remote:InvokeServer("Activate", nil, nil, nil)
end)

if success then
    table.insert(output, "Woman's Mace activated successfully!")
else
    table.insert(output, "Failed to activate Woman's Mace: " .. tostring(result))
end

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DebugOutputGUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.5, 0, 0.5, 0)
frame.Position = UDim2.new(0.25, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Debug Output"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = frame

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 0.8, 0)
scrollingFrame.Position = UDim2.new(0, 0, 0.1, 0)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.Parent = frame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = scrollingFrame

local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(1, 0, 0.1, 0)
copyButton.Position = UDim2.new(0, 0, 0.9, 0)
copyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.TextScaled = true
copyButton.Text = "Copy Debug Output"
copyButton.Font = Enum.Font.SourceSansBold
copyButton.Parent = frame

-- Display output in the GUI
local function displayOutput()
    -- Clear any existing text labels in the scrolling frame
    for _, child in ipairs(scrollingFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    for _, line in ipairs(output) do
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -10, 0, 30)
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextScaled = true
        textLabel.BackgroundTransparency = 1
        textLabel.Text = line
        textLabel.Parent = scrollingFrame
    end

    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #output * 30)
end

-- Copy output to clipboard
copyButton.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(table.concat(output, "\n"))
        print("Debug output copied to clipboard!")
    else
        print("Clipboard copying is not supported.")
    end
end)

-- Initialize the GUI with the captured output
displayOutput()
