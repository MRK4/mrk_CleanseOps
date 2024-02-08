lua54 'yes'

fx_version 'cerulean'
game 'gta5'

author 'MRK'
description 'CleanseOps is a unique FiveM script that introduces a thrilling job opportunity for players within the server.'
version '1.0.0'

resource_type 'gametype' { name = 'CleanseOps' }

shared_scripts {
    'config.lua'
}

client_scripts {
    './client/main.lua'
}

server_scripts {
    './server/main.lua'
}
