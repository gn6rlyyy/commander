local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = {
	Event = ReplicatedStorage:WaitForChild("Commander Remotes"):WaitForChild("RemoteEvent"),
	Function = ReplicatedStorage:WaitForChild("Commander Remotes"):WaitForChild("RemoteFunction"),
}
local Elements = script.Parent.Parent.Elements
local Library = script.Parent.Library
local Message = require(Library.Components.Message)
local Hint = require(Library.Components.Hint)
local Notification = require(Library.Components.Notification)
local ExpandedNotification = require(Library.Components.ExpandedNotification)
local ReplyBox = require(Library.Components.ReplyBox)
local activeElements = {}

local function playAudio(Id: number|string, Volume: number?, Parent: instance): sound
	local audio = Instance.new("Sound")
	audio.SoundId = "rbxassetid://" .. Id
	audio.Volume = Volume or 1
	audio.Parent = Parent
	audio.Ended:Connect(function()
		audio:Destroy()
	end)
	
	audio:Play()
	return audio
end

Remotes.Event.OnClientEvent:Connect(function(Type, Protocol, Attachment)
	coroutine.wrap(function()
		if Type == "newNotify" or Type == "newNotifyWithAction" then
			if activeElements.Audio == nil then
				activeElements.Audio = true
				playAudio(6518811702, nil, Elements).Ended:Wait()
				wait(2.5)
				activeElements.Audio = nil
			end
		end
	end)()
	
	if Type == "newMessage" then
		if activeElements.Message then
			activeElements.Message:dismiss()
		end
		
		activeElements.Message = Message.new(Attachment.From, Attachment.Content, Attachment.Duration, Elements)
		activeElements.Message:deploy()
	elseif Type == "newHint" then
		if activeElements.Hint then
			activeElements.Hint:dismiss()
		end

		activeElements.Hint = Hint.new(Attachment.From, Attachment.Content, Attachment.Duration, Elements)
		activeElements.Hint:deploy()
	elseif Type == "newNotify" then
		local notification = Notification.new(Attachment.From, Attachment.Content, Elements.List)
		notification:deploy()
		
		local interacted = notification.onDismiss.Event:Wait()
		if interacted then
			local expanded = ExpandedNotification.new(Attachment.From, Attachment.Content, Elements)
			expanded._object.Bottom.Primary.Content.Text = "Okay"
			expanded:deploy()
		end
	elseif Type == "newNotifyWithAction" then
		local notification = Notification.new(Attachment.From, Attachment.Content, Elements.List)
		notification:deploy()
		
		local interacted = notification.onDismiss.Event:Wait()
		if interacted then		
			local expanded = ExpandedNotification.new(Attachment.From, Attachment.Content, Elements)
			expanded._object.Bottom.Primary.Content.Text = Protocol.Type
			expanded:deploy()
			
			local response = expanded.onDismiss.Event:Wait()
			Remotes.Function:InvokeServer("notifyCallback", Protocol.GUID, response)
		end
	end
end)