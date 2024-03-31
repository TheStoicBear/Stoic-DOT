-- Function to fetch department names from the database using SQL
function fetchDepartmentNamesFromDB()
    local departmentNames = {}

    -- Execute SQL query to fetch department names
    local query = "SELECT department_name FROM department_funds"
    MySQL.Async.fetchAll(query, {}, function(result)
        if result then
            for _, row in ipairs(result) do
                table.insert(departmentNames, row.department_name)
            end
            -- Send department names to the client
            TriggerClientEvent("aaa:receiveDepartmentNames", -1, departmentNames)
        else
            print("Error fetching department names from the database")
        end
    end)
end



-- Function to split string into table using separator
function splitString(inputstr, sep)
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

-- Register server event to fetch department names
RegisterServerEvent("fetchDepartmentNames")
AddEventHandler("fetchDepartmentNames", fetchDepartmentNamesFromDB)

