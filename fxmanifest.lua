fx_version 'adamant'
game 'gta5'

lua54 'yes'

author 'Redhood'
description 'gift xp box'

client_scripts {
    'client/client.lua'
}
server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}