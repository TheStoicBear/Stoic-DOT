-- Function to process the investment
function processInvestment(departmentName, amount)
    -- Fetch player data from the source
    local player = NDCore.getPlayer(source)
    if not player then
        print("Error: Player data not found.")
        return
    end

    -- Check if the player has sufficient funds
    local success = player.deductMoney("bank", amount, "Investment")
    if success then
        -- Add the investment amount to the department's funds
        updateDepartmentFunds(departmentName, amount)

        -- Send notification to the player about successful investment
        local notificationData = {
            title = "Investment Successful",
            description = "You have invested $" .. amount .. " in the department " .. departmentName .. ".",
            duration = 5000, -- 5 seconds
            position = "top-right",
            type = "success",
            alignIcon = "center",
            icon = "check-circle"
        }
        TriggerClientEvent("ox_lib:notify", player.source, notificationData)
    else
        -- Send notification to the player about insufficient funds
        local notificationData = {
            title = "Insufficient Funds",
            description = "You do not have enough money to invest $" .. amount .. ".",
            duration = 5000, -- 5 seconds
            position = "top-right",
            type = "error",
            alignIcon = "center",
            icon = "times-circle"
        }
        TriggerClientEvent("ox_lib:notify", player.source, notificationData)
    end
end

-- Register server event to process investment
RegisterServerEvent("processInvestment")
AddEventHandler("processInvestment", processInvestment)

-- Function to update department funds in the database
function updateDepartmentFunds(departmentName, amount)
    local query = "UPDATE department_funds SET balance = balance + @amount WHERE department_name = @departmentName"
    local params = {
        ['@amount'] = amount,
        ['@departmentName'] = departmentName
    }
    
    MySQL.Sync.execute(query, params)
end
