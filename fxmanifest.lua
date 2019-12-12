fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
client_scripts {
	'config.lua',
	'client/cl_main.lua',
	'mp_female.lua',
	'mp_male.lua',
}

server_scripts {
	'server/sv_main.lua',
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
}

files{
'html/creator.html',
'html/crock.ttf',
'html/style.css',
'html/js/jquery-1.4.1.min.js',
'html/js/jquery-func.js',
'html/js/jquery.jcarousel.pack.js',
'html/js/listener.js',
'html/images/bgPanel.png',
'html/images/eye1.png',
'html/images/eye2.png',
'html/images/eye3.png',
'html/images/eye4.png',
'html/images/eye5.png',
'html/images/skin1.png',
'html/images/skin2.png',
'html/images/skin3.png',
'html/images/skin4.png',
'html/images/skin5.png',
'html/images/skin6.png',

}

ui_page "html/creator.html"