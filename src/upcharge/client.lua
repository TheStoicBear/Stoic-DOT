-- Function to open upcharge alert dialog for the specified player
function openUpchargeAlertDialog(upchargeData)
    print("Opening upcharge alert dialog for player with ID:", upchargeData.targetId)

    local alertDialogData = {
        header = "Confirm Upcharge",
        content = "Reason: " .. upchargeData.reason .. "\nAmount: $" .. upchargeData.amount .. "\nTarget ID: " .. upchargeData.targetId,
        size = "md",
        labels = {
            confirm = "Confirm",
            cancel = "Cancel"
        }
    }

    -- Open upcharge alert dialog for the target player
    local alert = lib.alertDialog(alertDialogData, function(action)
        if action == "confirm" then

        else
            -- If canceled, close the dialog
            lib.closeAlertDialog()
        end
    end)
    print(alert)
	            -- Trigger the server event to confirm the upcharge for the target player
            TriggerServerEvent("confirmUpcharge", upchargeData)
end


-- Register command to trigger upcharge input dialog for a specific player
RegisterCommand("upcharge", function(source, args, rawCommand)
    -- Check if the target player ID is provided as an argument
    if #args ~= 1 then
        print("Usage: /upcharge [targetId]")
        return
    end

    -- Extract the target player ID from the command arguments
    local targetId = tonumber(args[1])

    print("Received command to initiate upcharge for target player with ID:", targetId)

    -- Open input dialog for upcharge details for the specified target player
    openUpchargeInputDialog(targetId)
end, false)

-- Function to open upcharge input dialog for the specified player
function openUpchargeInputDialog(targetId)
    print("Opening upcharge input dialog for target player with ID:", targetId)

    local dialogHeading = "Upcharge Details"
    local dialogRows = {
        {type = 'input', label = 'Reason', description = 'Enter the reason for the upcharge', required = true},
        {type = 'number', label = 'Amount', description = 'Enter the amount of the upcharge', required = true},
    }
    local dialogOptions = {
        allowCancel = true
    }

    -- Display input dialog
    local input = lib.inputDialog(dialogHeading, dialogRows, dialogOptions)

    -- Check if input is received
    if input then
        print("Received input for upcharge details:", input[1], input[2])

        -- Construct upcharge data including the target player ID
        local upchargeData = {
            reason = input[1],
            amount = input[2],
            targetId = targetId
        }

        -- Open upcharge alert dialog for the specified player
        openUpchargeAlertDialog(upchargeData)
    else
        print("Invalid input received for upcharge details.")
    end
end
