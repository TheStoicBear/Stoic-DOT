-- Listen for client event to fetch department names
RegisterNetEvent("aaa:getDepartmentNames")
AddEventHandler("aaa:getDepartmentNames", function()
    local departmentNames = fetchDepartmentNamesFromDB() -- Implement this function using NDCore
    TriggerClientEvent("aaa:receiveDepartmentNames", source, departmentNames)
end)

-- Function to process AAA payment
RegisterServerEvent("aaa:processPayment")
AddEventHandler("aaa:processPayment", function(callerName, callerDescription, selectedDepartment, playerCoords, streetName, crossingRoad)
    -- Fetch source player data
    local sourcePlayer = NDCore.getPlayer(source)
    if not sourcePlayer then
        print("Error: Source player data not found.")
        return
    end

    -- Deduct payment amount from source player
    local paymentAmount = 100 -- Example payment amount, adjust as needed
    local success = sourcePlayer.deductMoney("bank", paymentAmount, "AAA Payment")
    if not success then
        print("Error: Insufficient funds to process AAA payment.")
        return
    end

    -- Add payment amount to the selected department's account
    local query = "UPDATE department_funds SET balance = balance + @paymentAmount WHERE department_name = @selectedDepartment"
    local params = {
        ['@paymentAmount'] = paymentAmount,
        ['@selectedDepartment'] = selectedDepartment
    }
    MySQL.Async.execute(query, params, function(rowsAffected)
        if rowsAffected > 0 then
            print("AAA payment processed successfully.")
            -- Send notification to employees in the selected department
            sendNotificationToEmployees(selectedDepartment, callerName, callerDescription, playerCoords, streetName, crossingRoad)
            -- Optionally, you can log the transaction or perform additional actions here
        else
            print("Error: Failed to process AAA payment.")
            -- Rollback the deducted amount from the source player if needed
            sourcePlayer.addMoney("bank", paymentAmount, "AAA Payment Rollback")
        end
    end)
end)


function sendNotificationToEmployees(departmentName, callerName, callerDescription, playerCoords, streetName, crossingRoad)
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
                        -- Include location details in the notification
                        TriggerClientEvent('chat:addMessage', playerSource, {
                            color = { 255, 255, 0 },
                            multiline = true,
                            args = { 'Department Payment', 'Location: ' .. playerCoords.x .. ', ' .. playerCoords.y .. ', ' .. playerCoords.z }
                        })
                        TriggerClientEvent('chat:addMessage', playerSource, {
                            color = { 255, 255, 0 },
                            multiline = true,
                            args = { 'Department Payment', 'Street Name: ' .. streetName }
                        })
                        TriggerClientEvent('chat:addMessage', playerSource, {
                            color = { 255, 255, 0 },
                            multiline = true,
                            args = { 'Department Payment', 'Crossing Road: ' .. crossingRoad }
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
