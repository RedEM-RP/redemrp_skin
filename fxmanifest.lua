fx_version "adamant"

games { 'rdr3', 'gta5' }

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

-- UI
ui_page "ui/index.html"
files {
	"ui/index.html",
	"ui/assets/*.png",
	"ui/assets/heritage/*.png",
	"ui/fonts/*.ttf",
	"ui/front.js",
	"ui/script.js",
	"ui/style.css",
	'ui/debounce.min.js'
}

-- Client Scripts
client_scripts {
    'client/cl_main.lua',
   	'cloth_hash_names.lua',
	'overlays.lua',
}

-- Server Scripts
server_scripts {
    '@mysql-async/lib/MySQL.lua',     -- MySQL init
    'server/sv_main.lua',
}
export 'GetOverlayData'
export 'GetTorso'
export 'GetLegs'
export 'GetComponentId'
export 'GetBodyComponents'