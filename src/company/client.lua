-- Command to open DOT department using input dialog
RegisterCommand("opendot", function(source, args, rawCommand)
    local dialogHeading = "Open DOT Department"
    local dialogRows = {
        {type = 'input', label = 'Department Name', description = 'Enter the department name', required = true},
        {type = 'input', label = 'Owner Name', description = 'Enter the owner name', required = true},
        {type = 'number', label = 'Investment', description = 'Enter the investment amount', required = true}
    }
    local dialogOptions = {
        allowCancel = true
    }

    -- Display input dialog
    local input = lib.inputDialog(dialogHeading, dialogRows, dialogOptions)

    if input then
        -- Extract input data
        local departmentName = input[1]
        local ownerName = input[2]
        local investment = tonumber(input[3])
            print(ownerName)
            print(departmentName)
            print(investment)
        -- Trigger server event to open DOT department
        TriggerServerEvent("openDOTDepartment", departmentName, ownerName, investment)
    else
        print("Invalid input received for opening DOT department.")
    end
end, false)
