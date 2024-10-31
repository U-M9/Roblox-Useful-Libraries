-- Author: U_M9 (TearikiAriki)
-- Date: 31/10/2024 Recent Update (1/11/2024)

local VoiceChatModule = {}
local VoiceChatService = game:GetService("VoiceChatService")
local Players = game:GetService("Players")

VoiceChatModule.Channels = {}

function VoiceChatModule:InitVoiceChat(player)
    if VoiceChatService:IsVoiceChatEnabledForUserIdAsync(player.UserId) then
        print("Voice Chat enabled for:", player.Name)
        self:connectVoiceChannel(player, "DefaultChannel")
        self:ApplyDefaultVoiceEffects(player)
    else
        print("Voice Chat not enabled for:", player.Name)
    end
end

function VoiceChatModule:createVoiceChannel(channelName)
    if self.Channels[channelName] then
        print("Channel already exists:", channelName)
        return channelName
    else
        self.Channels[channelName] = true
        print("Voice channel created:", channelName)
        return channelName
    end
end

function VoiceChatModule:removeVoiceChannel(channelName)
    if self.Channels[channelName] then
        for _, player in pairs(Players:GetPlayers()) do
            if player.UserId and VoiceChatService:IsPlayerInChannel(player.UserId, channelName) then
                self:leaveVoiceChannel(player, channelName)
            end
        end
        self.Channels[channelName] = nil
        print("Voice channel removed:", channelName)
    else
        warn("Channel does not exist:", channelName)
    end
end

function VoiceChatModule:connectVoiceChannel(player, channelName)
    if self.Channels[channelName] then
        VoiceChatService:JoinByGroupId(player.UserId, channelName)
        print(player.Name, "connected to channel:", channelName)
    else
        warn("Channel does not exist:", channelName)
    end
end

function VoiceChatModule:leaveVoiceChannel(player, channelName)
    if self.Channels[channelName] then
        VoiceChatService:LeaveChannel(player.UserId)
        print(player.Name, "left channel:", channelName)
    else
        warn("Channel does not exist:", channelName)
    end
end

function VoiceChatModule:ApplyDefaultVoiceEffects(player)
    local voiceEffect = VoiceChatService:GetUserVoiceEffect(player.UserId)
    if voiceEffect then
        voiceEffect.Pitch = 1.0
        voiceEffect.Gain = 1.0
        voiceEffect.Reverb = "None"
        voiceEffect.Echo = false
        print("Applied default voice effects for:", player.Name)
    else
        warn("Voice effect not available for:", player.Name)
    end
end

function VoiceChatModule:ApplyMicEffect(player, settings)
    local voiceEffect = VoiceChatService:GetUserVoiceEffect(player.UserId)
    if voiceEffect then
        voiceEffect.Pitch = settings.Pitch or 1.0
        voiceEffect.Gain = settings.Gain or 1.5
        voiceEffect.BassBoost = settings.BassBoost or true
        voiceEffect.Distortion = settings.Distortion or 0.1
        voiceEffect.Reverb = settings.Reverb or "SmallRoom"
        voiceEffect.Echo = settings.Echo or false
        print("Microphone effect applied for:", player.Name)
    else
        warn("Voice effect not available for:", player.Name)
    end
end

function VoiceChatModule:ApplyMuffledEffect(player)
    local voiceEffect = VoiceChatService:GetUserVoiceEffect(player.UserId)
    if voiceEffect then
        voiceEffect.Pitch = 0.9
        voiceEffect.Gain = 0.8
        voiceEffect.BassBoost = true
        voiceEffect.Distortion = 0.05
        voiceEffect.Reverb = "MediumRoom"
        voiceEffect.Echo = false
        print("Muffled effect applied for:", player.Name)
    else
        warn("Voice effect not available for:", player.Name)
    end
end

function VoiceChatModule:SetEffect(player, effectName, value)
    local voiceEffect = VoiceChatService:GetUserVoiceEffect(player.UserId)
    if voiceEffect then
        if effectName == "Pitch" then
            voiceEffect.Pitch = value
        elseif effectName == "Gain" then
            voiceEffect.Gain = value
        elseif effectName == "BassBoost" then
            voiceEffect.BassBoost = value
        elseif effectName == "Distortion" then
            voiceEffect.Distortion = value
        elseif effectName == "Reverb" then
            voiceEffect.Reverb = value
        elseif effectName == "Echo" then
            voiceEffect.Echo = value
        end
        print("Set", effectName, "for", player.Name, "to", value)
    else
        warn("Voice effect not available for:", player.Name)
    end
end

function VoiceChatModule:SetupVoiceChatForPlayer(player)
    player.CharacterAdded:Connect(function()
        self:InitVoiceChat(player)
    end)
end

function VoiceChatModule:DisconnectVoiceChat(player)
    VoiceChatService:LeaveChannel(player.UserId)
    print("Voice Chat disconnected for:", player.Name)
end

function VoiceChatModule:Initialize()
    Players.PlayerAdded:Connect(function(player)
        self:SetupVoiceChatForPlayer(player)
    end)
    Players.PlayerRemoving:Connect(function(player)
        self:DisconnectVoiceChat(player)
    end)
end

return VoiceChatModule
