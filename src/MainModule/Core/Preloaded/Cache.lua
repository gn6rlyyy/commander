local Cache = {}

local RunService = game:GetService("RunService")

function Cache.new(expireInterval)
    local self = setmetatable({
        Data = {},
        Status = "Live",
        ExpireInterval = expireInterval or (60*10) -- Default: 10 minutes
    }, Cache)

    self.new = nil

    coroutine.wrap(function()
        while self.Status == "Live" do
            for _, dataset in pairs(self.Data) do
                if (tick() - dataset.Time) >= self.ExpireInterval and dataset.Value ~= nil then
                    dataset.Status = "Expired"
                    dataset.Value = nil
                end
            end
            RunService.Heartbeat:Wait()
        end
    end)()

    return self
end

function Cache:AssignData(name, value)
    if self then
        self.Data[name] = {
            Time = tick(),
            Status = "Live",
            Value = value
        }
    end
end

function Cache:DeleteData(name, value)
    if self then
        self.Data[name] = nil
    end
end

function Cache:GetData(name)
    if self and self.Data[name] then
        return self.Data[name].Value
    end
end

function Cache:GetDataStatus(name)
    if self and self.Data[name] then
        return self.Data[name].Status
    end
end

function Cache:Clear()
    if self then
        self.Data = {}
    end
end

Cache.__index = Cache
return Cache