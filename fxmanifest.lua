fx_version "cerulean"
game "gta5"
lua54 "yes"

author 'TheStoicBear'
description 'Stoic DOT | Company | Account | System'
version '1.0.0'

client_scripts {
    'src/aaa/client.lua',
    'src/commands/client.lua',
    'src/company/client.lua',
    'src/hire/client.lua',
    'src/invest/client.lua',
    'src/upcharge/client.lua',
    'src/management/client.lua',
}

server_scripts {
    'src/aaa/server.lua',
    'src/commands/server.lua',
    'src/company/server.lua',
    'src/hire/server.lua',
    'src/invest/server.lua',
    'src/upcharge/server.lua',
    'src/management/server.lua',
	'src/functions.lua',
    '@oxmysql/lib/MySQL.lua'
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
	'@ND_Core/init.lua'
}

dependencies {
    'ox_lib',
    'oxmysql',
    'ND_Core'
}