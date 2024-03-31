-- Function to open AAA payment input dialog
function openAAAPaymentDialog()
    local dialogHeading = "AAA Payment"
    local dialogRows = {
        {type = 'input', label = 'Caller Name', description = 'Enter your name', required = true},
        {type = 'textarea', label = 'Caller Description', description = 'Describe the reason for your call', required = true},
        {type = 'select', label = 'Department', options = {}},
        {type = 'input', label = 'Caller Name', description = 'Enter your name', required = true},
    }
    local dialogOptions = {
        allowCancel = true
    }

    -- Fetch department names from the server
    TriggerServerEvent("aaa:getDepartmentNames")

    -- Wait for department names from server
    Citizen.Wait(500) -- Adjust this delay as needed

    -- Retrieve the player's location
    local ped = PlayerPedId()
	
    -- Display input dialog
    lib.inputDialog(dialogHeading, dialogRows, dialogOptions, function(input)
        if input then
            local callerName = input[1]
            local callerDescription = input[2]
            local selectedDepartment = input[3]
            local playerLocation = input[4]
            -- Trigger server event to process AAA payment with location data
            TriggerServerEvent("aaa:processPayment", callerName, callerDescription, selectedDepartment, playerLocation, streetName, crossingRoad)
        else
            print("Invalid input received for AAA payment.")
        end
    end)
end


-- Command to open AAA payment input dialog
RegisterCommand("aaa", function(source, args, rawCommand)
    -- Open input dialog for AAA payment details
    openAAAPaymentDialog()
end, false)


-- Register event to receive department names from the server
RegisterNetEvent("aaa:receiveDepartmentNames")
AddEventHandler("aaa:receiveDepartmentNames", function(departmentNames)
    -- Update dropdown options with received department names
    updateDepartmentDropdown(departmentNames)
end)

-- Function to update department dropdown options
function updateDepartmentDropdown(departmentNames)
    local dialogRows = {
        {type = 'input', label = 'Caller Name', description = 'Enter your name', required = true},
        {type = 'textarea', label = 'Caller Description', description = 'Describe the reason for your call', required = true},
        {type = 'select', label = 'Department', options = {}}
    }

    -- Add received department names to dropdown options
    for _, name in ipairs(departmentNames) do
        table.insert(dialogRows[3].options, {label = name, value = name})
    end

    -- Display input dialog
    local input = lib.inputDialog("AAA Payment", dialogRows, {allowCancel = true})

    if input then
        -- Handle input data
        local callerName = input[1]
        local callerDescription = input[2]
        local selectedDepartment = input[3]

	-- Trigger server event to process AAA payment with location data
	TriggerServerEvent("aaa:processPayment", callerName, callerDescription, selectedDepartment)


    else
        print("Invalid input received for AAA payment.")
    end
end
