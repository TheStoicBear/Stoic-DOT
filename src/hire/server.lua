-- Command to hire a player into a department
RegisterCommand("hire", function(source, args, rawCommand)
    -- Check if the command has the required arguments
    if #args < 2 then
        print("Usage: /hire [targetID] [departmentName]")
        return
    end

    local targetID = tonumber(args[1]) -- Get the target player's FiveM server ID
    local departmentName = table.concat(args, " ", 2) -- Concatenate remaining arguments as departmentName

    -- Fetch the player data
    local player = NDCore.getPlayer(targetID)
    if not player then
        print("Player not found.")
        return
    end

    -- Get the player's Steam ID
    local playerSteamID = player.getData("id")
    if not playerSteamID then
        print("Player's Steam ID not found.")
        return
    end

    -- Update the department's employees list in the database
    local success = updateDepartmentEmployees(departmentName, playerSteamID)
    if success then
        print("Player hired successfully into department: " .. departmentName)
    else
        print("Failed to hire player into department: " .. departmentName)
    end
end, false)

-- Function to update department's employees list in the database
function updateDepartmentEmployees(departmentName, playerSteamID)
    local query = "UPDATE department_funds SET employees = CONCAT_WS(',', employees, @playerSteamID) WHERE department_name = @departmentName"
    local params = {
        ['@departmentName'] = departmentName,
        ['@playerSteamID'] = playerSteamID
    }
    
    return MySQL.Sync.execute(query, params) > 0
end