-- Function to check if a department with the given name already exists
local function departmentExists(departmentName, callback)
    local query = "SELECT * FROM department_funds WHERE department_name = @name"
    local params = {['@name'] = departmentName}

    MySQL.Async.fetchAll(query, params, function(result)
        if result and #result > 0 then
            -- Department with the same name exists
            callback(true)
        else
            -- Department with the same name does not exist
            callback(false)
        end
    end)
end

-- Function to open DOT department using input dialog
function openDOTDepartment(departmentName, ownerName, investment)
    -- Fetch player data from source
    local player = NDCore.getPlayer(source)
    local playerID = player.getData("id")

    if departmentName and ownerName and playerID and investment then
        print("Received command to open DOT department.")
        print("Department name:", departmentName)
        print("Owner name:", ownerName)
        print("Player ID:", playerID)
        print("Investment:", investment)

        -- Check if the department name already exists
        departmentExists(departmentName, function(exists)
            if exists then
                -- Department name already exists, send error message
                TriggerClientEvent("chat:addMessage", source, { args = {"^1Error:", "A department with the same name already exists."} })
            else
                -- Proceed with department opening process
                -- Deduct department opening fee from player
                local openingFee = 5000

                local success = player.deductMoney("bank", openingFee, "Department opening fee")

                if success then
                    print("Department opening fee deducted successfully from the owner.")
                    -- Deduct investment amount from player's account
                    success = player.deductMoney("bank", investment, "Department investment")

                    if success then
                        print("Investment amount deducted successfully from the owner.")
                        -- Create department fund account
                        createDepartmentFundAccount(departmentName, ownerName, playerID, investment)

                        -- Send success message to the player
                        TriggerClientEvent("chat:addMessage", source, { args = {"^2Success:", "You have successfully opened the DOT department."} })
                    else
                        print("Failed to deduct investment amount from the owner.")
                        -- Refund the department opening fee
                        player.addMoney("bank", openingFee, "Refund for failed department opening")

                        -- Send error message to the player
                        TriggerClientEvent("chat:addMessage", source, { args = {"^1Error:", "Failed to deduct investment amount from your account."} })
                    end
                else
                    print("Failed to deduct department opening fee from the owner")
                    -- You can add additional logic here if needed

                    -- Send error message to the player
                    TriggerClientEvent("chat:addMessage", source, { args = {"^1Error:", "Failed to deduct department opening fee from your account."} })
                end
            end
        end)
    else
        print("Invalid input received for opening DOT department.")

        -- Send warning message to the player
        TriggerClientEvent("chat:addMessage", source, { args = {"^3Warning:", "Please provide all required information to open the DOT department."} })
    end
end

-- Function to create department fund account
function createDepartmentFundAccount(departmentName, ownerName, playerID, investment)
    local query = "INSERT INTO department_funds (department_name, owner_name, steam_id, balance) VALUES (@name, @owner, @steamID, @balance)"
    local params = {
        ['@name'] = departmentName,
        ['@owner'] = ownerName,
        ['@steamID'] = playerID,
        ['@balance'] = investment -- Use the provided investment amount
    }

    MySQL.Async.execute(query, params, function(rowsAffected)
        if rowsAffected > 0 then
            print("Department fund account created successfully for " .. departmentName)
        else
            print("Failed to create department fund account for " .. departmentName)
        end
    end)
end

RegisterNetEvent("openDOTDepartment")
AddEventHandler("openDOTDepartment", function(departmentName, ownerName, investment)
    -- Call the function to open DOT department
    openDOTDepartment(departmentName, ownerName, investment)
end)
