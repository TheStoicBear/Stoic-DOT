RegisterNetEvent('fetchDepartmentData')

AddEventHandler('fetchDepartmentData', function()
    local player = NDCore.getPlayer(source)
    local steamId = player.getData("id")

    MySQL.Async.fetchAll('SELECT * FROM department_funds WHERE steam_id = @steamId', {
        ['@steamId'] = steamId
    }, function(departmentData)
        if departmentData and #departmentData > 0 then
            local firstDepartmentData = departmentData[1]
            TriggerClientEvent('populateManagementMenu', source, json.encode(firstDepartmentData))
        else
            print("No department data found")
            TriggerClientEvent('populateManagementMenu', source, "{}")
        end
    end)
end)

