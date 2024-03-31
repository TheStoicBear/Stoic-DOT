-- Register server event to handle confirmation of upcharge payment
RegisterServerEvent("confirmUpcharge")
AddEventHandler("confirmUpcharge", function(upchargeData)
    -- Retrieve the target player's identifier
    local targetPlayerId = tonumber(upchargeData.targetId)

    -- Retrieve upcharge data
    local reason = upchargeData.reason
    local amount = tonumber(upchargeData.amount)

    -- Deduct money from the target player's bank account
    local targetPlayer = NDCore.getPlayer(targetPlayerId)
    if targetPlayer then
        local success = targetPlayer.deductMoney("bank", amount, reason)
        
        -- Notify the target player about the transaction result
        local notificationData = {
            title = "Upcharge Confirmation",
            description = success and ("You have been charged $" .. amount .. " for: " .. reason)
                                    or "Failed to charge for the upcharge.",
            duration = 5000,  -- Display duration in milliseconds (5 seconds)
            position = "top",  -- Display position on the screen
            type = success and "success" or "error"  -- Type of notification (success or error)
        }
        TriggerClientEvent("ox_lib:notify", targetPlayerId, notificationData)
    else
        print("Target player not found.")
    end
end)


-- Function to send notification to employees in the selected department
function sendNotificationToEmployees(departmentName, callerName, callerDescription)
    local query = "SELECT employees FROM department_funds WHERE department_name = @departmentName"
    local params = {
        ['@departmentName'] = departmentName
    }

    MySQL.Async.fetchScalar(query, params, function(employees)
        if employees then
            local employeeIDs = splitString(employees, ",") -- Split employee IDs
            print("Employee IDs in department " .. departmentName .. ":")
            for _, employeeID in ipairs(employeeIDs) do
                print(employeeID)
                local employee = NDCore.getPlayers('id', tonumber(employeeID), false)
                if employee then
                    for playerSource, playerData in pairs(employee) do
                        TriggerClientEvent('chat:addMessage', playerSource, {
                            color = { 255, 255, 0 },
                            multiline = true,
                            args = { 'Department Payment', 'You have received a payment from ' .. callerName .. ' for: ' .. callerDescription }
                        })
                    end
                else
                    print("Error: Player with ID " .. employeeID .. " not found.")
                end
            end
        else
            print("Error: No employees found for department " .. departmentName)
        end
    end)
end