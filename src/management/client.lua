RegisterNetEvent('populateManagementMenu')

AddEventHandler('populateManagementMenu', function(departmentData)
    departmentData = json.decode(departmentData)

    -- Retrieve balance and employee IDs
    local balance = departmentData.balance or 0
    local employees = departmentData.employees or ""

    -- Convert employee IDs to a table
    local employeeIDs = {}
    for employee in string.gmatch(employees, "%d+") do
        table.insert(employeeIDs, employee)
    end

    -- Employees submenu options
    local employeesOptions = {}
    for _, employeeID in ipairs(employeeIDs) do
        table.insert(employeesOptions, {
            title = 'Employee ID: ' .. employeeID,
            description = 'View details for employee ID ' .. employeeID,
            onSelect = function()
                -- Handle employee selection
                print("Employee ID " .. employeeID .. " selected!")
            end
        })
    end

    -- Register employees submenu as context menu
    lib.registerContext({
        id = 'employees_menu',
        title = 'Employees Menu',
        options = employeesOptions,
        canClose = true
    })

    -- Balance submenu options
    local balanceOptions = {
        {
            title = 'Add Funds',
            description = 'Add funds to department balance',
            onSelect = function()
                -- Handle adding funds
                print("Add funds selected!")
            end
        },
        {
            title = 'Remove Funds',
            description = 'Remove funds from department balance',
            onSelect = function()
                -- Handle removing funds
                print("Remove funds selected!")
            end
        },
        {
            title = 'Total Balance: ' .. balance,
            description = 'Current department balance',
            disabled = true
        }
    }

    -- Register balance submenu as context menu
    lib.registerContext({
        id = 'balance_menu',
        title = 'Balance Menu',
        options = balanceOptions,
        canClose = true
    })

    -- Main menu options
    local mainMenuOptions = {
        {
            title = 'Employees',
            description = 'View and manage department employees',
            icon = 'users',
            onSelect = function()
                lib.showContext('employees_menu') -- Open employees submenu
            end
        },
        {
            title = 'Balance',
            description = 'View and manage department balance',
            icon = 'dollar-sign',
            onSelect = function()
                lib.showContext('balance_menu') -- Open balance submenu
            end
        }
    }

    -- Register main menu as a menu
    lib.registerMenu({
        id = 'main_menu',
        title = 'Main Menu',
        options = mainMenuOptions,
        canClose = true
    }, function(selected, _, args)
        -- Handle main menu selection
        if selected == 0 then
            -- Close menu
            lib.hideContext(true)
        end
    end)

    -- Show the main menu
    lib.showContext('main_menu')
end)

-- Register command to show main menu
RegisterCommand('management', function()
    -- Show main menu
    lib.showContext('main_menu')
end)
