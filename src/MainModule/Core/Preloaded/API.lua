local API = {}

local CollectionService = game:GetService("CollectionService")

local function initializePlayer(player)

end

function API.checkUserAdmin(player)
    if CollectionService:HasTag(player, "Commander_Admin") then
        return true
    elseif not CollectionService:HasTag(player, "Commander_Loaded") then
        -- User was not previously loaded by Commander, a rank check is necessary

    end

    return false
end

function API.getRank(player)

end

return API