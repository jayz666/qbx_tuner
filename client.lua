fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'MyHandling Team'
description 'Vehicle Handling Editor with NUI frontend (cleaned package)'
version '1.0.0-cleaned'

ui_page 'web/build/index.html'

client_scripts {
    'client.lua'
}

files {
    'web/build/index.html',
    'web/build/assets/*'
}

exports {
    'openHandlingEditor',
    'closeHandlingEditor',
    'applyHandling',
    'getVehicleHandling'
}
