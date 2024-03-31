-- Function to open investment input dialog
function openInvestmentDialog()
    local dialogHeading = "Investment Details"
    local dialogRows = {
        { type = 'select', label = 'Department', options = {} },
        { type = 'slider', label = 'Investment Amount', description = 'Select the amount to invest:', min = 0, max = 10000, step = 100, default = 0, required = true }
    }
    local dialogOptions = {
        allowCancel = true
    }

    -- Fetch department names from the server
    TriggerServerEvent("aaa:getDepartmentNames")

    -- Wait for department names from server
    Citizen.Wait(500) -- Adjust this delay as needed


    -- Display input dialog with department name options
    lib.inputDialog(dialogHeading, dialogRows, dialogOptions, function(input)
        if input then
            -- Process the investment
            local departmentName = input[1]
            local investmentAmount = tonumber(input[2])
            TriggerServerEvent("processInvestment", departmentName, investmentAmount)
        else
            print("Investment input dialog canceled.")
        end
    end, departmentNameOptions)
end

-- Register command to trigger investment input dialog
RegisterCommand("invest", function(source, args, rawCommand)
    openInvestmentDialog()
end, false)

-- Listen for department names from the server
RegisterNetEvent("receiveDepartmentNames")
AddEventHandler("receiveDepartmentNames", function(departmentNamesFromServer)
    local departmentNameOptions = {}
    for _, name in ipairs(departmentNamesFromServer) do
        table.insert(departmentNameOptions, { label = name, value = name })
    end
    openInvestmentDialog(departmentNameOptions)
end)
