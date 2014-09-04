--[[
                                             
     Minimal Awesome WM config 0.1 
     github.com/cornhelius           
                                             
--]]

-- {{{ Required libraries
local gears     = require("gears")
local awful     = require("awful")
awful.rules     = require("awful.rules")
require("awful.autofocus")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local drop      = require("scratch.drop")
local lain      = require("lain")
local redshift  = require("redshift")
local revelation = require("revelation")
-- }}}

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Autostart applications
function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
     findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

run_once("xcompmgr")
run_once("caffeine")
run_once("mpd")
-- }}}

-- {{{ Redshift
redshift.redshift = "/usr/bin/redshift"
redshift.options = "-c ~/.config/redshift.conf"
-- 1 for dim, 0 for not dimmed
redshift.init(1)
-- }}}

-- {{{ Variable definitions
-- localization
os.setlocale(os.getenv("LANG"))

-- beautiful init
beautiful.init(awful.util.getdir("config") .. "/themes/minimal/theme.lua")

-- revelation init
revelation.init()

-- common
modkey     = "Mod4"
altkey     = "Mod1"
terminal   = "urxvt"
editor     = "nano"
editor_cmd = terminal .. " -e " .. editor
cad	   = "draftsight"

-- user defined
browser    = "lynx"
browser2   = "firefox"
browser3   = "luakit"
anonimous  = "torify luakit"
gui_editor = "kkedit"
graphics   = "gimp"
mail       = terminal .. " -e mutt"
mailview   = terminal .. " -e mutt -R"
iptraf     = terminal .. " -g 180x54-20+34 -e sudo iptraf-ng -i all "
musicplr   = terminal .. " -e ncmpcpp"
audiostream = terminal .. " -e pms"
torrent	   = terminal .. " -e rtorrent"
file	   = terminal .. " -e ranger"

local layouts = {
    awful.layout.suit.floating,			--1 
    awful.layout.suit.tile,			--2 
    awful.layout.suit.tile.bottom,		--3 
    awful.layout.suit.fair,			--4 
    awful.layout.suit.fair.horizontal,		--5 
    lain.layout.termfair,			--6
    lain.layout.uselesstile,			--7
    lain.layout.centerwork,			--8
    awful.layout.suit.max,			--9
}
-- }}}

-- {{{ Tags
tags = {
   names = { "m", "i", "n", "i", "m", "a", "l"  },
   layout = { layouts[2], layouts[4], layouts[2], layouts[2], layouts[9], layouts[4], layouts[1] }
}

for s = 1, screen.count() do
   tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " /home/nemo/.config/awesome/rc.lua" },
   { "edit theme", editor_cmd .. " /home/nemo/.config/awesome/themes/minimal/theme.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit },
   { "down", "oblogout" }
}

myinternetmenu = {
   { "firefox", browser2 },
   { "luakit", browser3 },
   { "anonimous", anonimous },
   { "transmission", "transmission-gtk" },
   { "dukto", "dukto" },
   { "skype", "skype"}
}

myeditormenu = {
   { "kkedit", gui_editor },
   { "geany", "geany" },
   { "meld", "meld" }
}

mytilemenu = {
   { "web", browser },
   { "mail", mail },
   { "torrent", torrent },
   { "audio", musicplr },
   { "audio_streaming", audiostream },
   { "video", "mplayer" },
   { "file", file }
}

mysystemmenu = {
   { "file-manager", "thunar" },
   { "look", "lxappearance" },
   { "office", "libreoffice" }
}

mymediamenu = {
   { "vlc", "vlc" },
}

mygraphicsmenu = {
   { "gimp", "gimp" },
   { "inkscape", "inkscape" },
   { "scribus", "scribus" },
   { "darktable", "darktable" },
   { "cad", cad },
   { "blender", "blender" },
   { "luxrender", "luxrender" }
}

mymainmenu = awful.menu.new({ items = { { "tile", mytilemenu },
					{ "web", myinternetmenu },
					{ "editor", myeditormenu },
					{ "media", mymediamenu },
					{ "graphics", mygraphicsmenu },
					{ "system", mysystemmenu },
					{ "awesome", myawesomemenu },                              
					{ "console", terminal }
                                      }
                            })

-- }}}

-- {{{ Wibox
markup = lain.util.markup
gray   = "#94928F"

-- Textclock
mytextclock = awful.widget.textclock("▫%d%b ▫%H%M")

-- Update
pkg = wibox.widget.textbox()

-- Pulsanti ---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Power
off = wibox.widget.textbox()
off:set_markup(markup(theme.indicator_high, "exit"))

off:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("oblogout") end)
))

-- Shell
shell = wibox.widget.textbox()
shell:set_markup(markup(theme.fg_normal, "shell"))

shell:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("urxvt") end)
))

-- Blender
model = wibox.widget.textbox()
model:set_markup(markup(theme.fg_normal, "model"))

model:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("blender") end)
))

-- Ftp
ftp = wibox.widget.textbox()
ftp:set_markup(markup(theme.fg_normal, "ftp"))

ftp:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("filezilla") end)
))

-- Torrent
torrent = wibox.widget.textbox()
torrent:set_markup(markup(theme.fg_normal, "torrent"))

torrent:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("transmission-gtk") end)
))

-- Skype
voip = wibox.widget.textbox()
voip:set_markup(markup(theme.fg_normal, "voip"))

voip:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("skype") end)
))

-- Browser
browser = wibox.widget.textbox()
browser:set_markup(markup(theme.fg_normal, "browser"))

browser:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("firefox") end)
))

-- Scribus
scribus = wibox.widget.textbox()
scribus:set_markup(markup(theme.fg_normal, "scribus"))

scribus:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("scribus") end)
))

-- Thunar
file = wibox.widget.textbox()
file:set_markup(markup(theme.fg_normal, "file"))

file:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("thunar") end)
))

-- KKedit
editor = wibox.widget.textbox()
editor:set_markup(markup(theme.fg_normal, "editor"))

editor:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("kkedit") end)
))

-- Widgets a scomparsa ----------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

vtor = lain.widgets.base({
    cmd = "ps cax | grep transmission | wc -l",
    timeout = 1,
    settings = function()
        if tonumber(output) > 0 then
            widget:set_markup(markup(theme.fg_normal, "|") .. markup(theme.indicator_high, "↓↑ "))
        else
            widget:set_markup(markup(theme.fg_normal, "|") .. markup(theme.indicator_low, "↓↑ "))
        end
    end
})

vcaf = lain.widgets.base({
    cmd = "ps cax | grep caffeine | wc -l",
    timeout = 10,
    settings = function()
        if tonumber(output) > 0 then
            widget:set_markup(markup(theme.fg_normal, "|") .. markup(theme.indicator_high, "caffeine "))
        else
            widget:set_markup(markup(theme.fg_normal, "|") .. markup(theme.indicator_low, "caffeine "))
        end
    end
})

-- Widgets-----------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Mail IMAP check
mailwork = lain.widgets.imap({
    timeout  = 120,
    server   = "imap.gmail.com",
    mail     = "andrea.calzavacca@gmail.com",
    password = "@ntisg@mo",
    is_plain = true,
    settings = function()
        if mailcount > 0 then
            widget:set_markup(markup(theme.fg_normal, "▫") .. markup(theme.indicator_high, mailcount))
        else
            widget:set_markup(markup(theme.fg_normal, "▫") .. markup(theme.indicator_low, "0"))
        end
	mail_notification_preset = { position = "top_right" }
    end

})

mailwork:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn(mail) end)
))

-- MPD
mpd = lain.widgets.mpd({    
    settings = function()
        if mpd_now.state == "play" then
            artist = "▫"
            title  = mpd_now.artist .. " " .. mpd_now.title
        elseif mpd_now.state == "pause" then
            artist = "▫"
            title  = "paused " .. mpd_now.title
        else
            artist = "▫"
            title  = "mpd off"
        end
	mpd_notification_preset = { title   = "Now playing", 
				    timeout = 6, 
				    text	= string.format("%s (%s) - %s\n%s", mpd_now.artist, mpd_now.album, mpd_now.date, mpd_now.title), 
				    position = "bottom_left" 
				  }
        widget:set_markup(markup("#FFFFFF", artist) .. markup(theme.indicator_high, title))
    end
})

mpd:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn(musicplr) end)
))

-- MEM
mem = lain.widgets.mem({
    settings = function()
	if mem_now.used < 2048 then
            widget:set_markup(markup(theme.fg_normal, "▫") .. markup(theme.indicator_low, mem_now.used .. "mb"))
	else
	    widget:set_markup(markup(theme.fg_normal, "▫") .. markup(theme.indicator_high, mem_now.used .. "mb"))
	end
    end
})

-- CPU
cpu = lain.widgets.cpu({
    settings = function()
            widget:set_markup(markup(theme.fg_normal, "▫") .. markup(theme.indicator_low, cpu_now.usage .. "%"))
    end
})

cpu:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn(terminal .. " -e htop") end)
))

-- Coretemp
temp = lain.widgets.temp({
    settings = function()
	if coretemp_now < 60 then
	   widget:set_markup(markup(theme.fg_normal, "▫") .. markup(theme.indicator_low, coretemp_now .. "°"))
	else
           widget:set_markup(markup(theme.fg_normal, "▫") .. markup(theme.indicator_high, coretemp_now .. "°"))
	end
    end
})

-- / fs
fs = lain.widgets.fs({
    partition = "/home",
    settings  = function()
	if fs_now.used < 80 then
           widget:set_markup(markup(theme.fg_normal, "▫") .. markup(theme.indicator_low, fs_now.used .. "u"))
	else
	   widget:set_markup(markup(theme.fg_normal, "▫") .. markup(theme.indicator_high, fs_now.used .. "u"))
	end
	fs_notification_preset = { position = "bottom_right" }
    end
})

fs:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn(file) end)
))

-- ALSA volume
volume = lain.widgets.alsa({
    settings = function()
        if volume_now.status == "off" then
	    widget:set_markup(markup("#FF4040", "Off"))
	elseif tonumber(volume_now.level) == 0 then
	    widget:set_markup(markup("#FF4040", "Mute"))
	elseif tonumber(volume_now.level) <= 80 then
	    widget:set_markup(markup(theme.fg_normal, "▫") .. markup(theme.indicator_low, volume_now.level .. "♪"))
	else
	    widget:set_markup(markup(theme.fg_normal, "▫") .. markup(theme.indicator_high, volume_now.level .. "♪"))
        end
    end
})

volume:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn(terminal .. " -e alsamixer") end)
))

-- Net
net = lain.widgets.net({
    settings = function()
	if net_now.state == "up" then
	   widget:set_markup(markup(theme.fg_normal, "▫") .. markup(theme.indicator_low, "on"))
	else
	   widget:set_markup(markup(theme.fg_normal, "▫") .. markup(theme.indicator_high, "off"))
	end
	net_notification_preset = { position = "bottom_right" }
    end
})

net:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn(terminal .. " -e wicd-curses") end)
))

-- Separators -------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

spr = wibox.widget.textbox(' ')
spr_h = wibox.widget.textbox('  ')
spr_l = wibox.widget.textbox('[')
spr_r = wibox.widget.textbox(']')
spr_c = wibox.widget.textbox(' | ')
spr_q = wibox.widget.textbox(' ▫ ')

-- Create a wibox for each screen and add it ------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do

    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()

    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                            awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                            awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                            awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                            awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 18 })

    -- Widgets that are aligned to the upper left
    local left_up = wibox.layout.fixed.horizontal()
    left_up:add(spr)
    left_up:add(mytaglist[s])
    left_up:add(mypromptbox[s])
    --left_up:add(mylayoutbox[s])
    left_up:add(spr)

    local right_up = wibox.layout.fixed.horizontal()
    --if s == 1 then right_up:add(wibox.widget.systray()) end
    right_up:add(spr)
    right_up:add(mailwork)
    right_up:add(spr)
    right_up:add(net)
    right_up:add(spr)
    right_up:add(volume)
    right_up:add(spr)
    right_up:add(mytextclock)
    right_up:add(spr)
      
    -- Now bring it all together
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_up)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_up)
    mywibox[s]:set_widget(layout)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "bottom", screen = s, align = center, height = 18 })

    -- Widgets that are aligned to the bottom left
    local left_down = wibox.layout.fixed.horizontal()
    left_down:add(cpu)
    left_down:add(spr)
    left_down:add(temp)
    left_down:add(spr)
    left_down:add(mem)
    left_down:add(spr)
    left_down:add(fs)
    left_down:add(spr)
    left_down:add(mpd)

    -- Widgets that are aligned to the bottom right
    local right_down = wibox.layout.fixed.horizontal()
    right_down:add(shell)
    right_down:add(spr_h)
    right_down:add(browser)
    right_down:add(spr_h)
    right_down:add(editor)
    right_down:add(spr_h)
    right_down:add(file)
    right_down:add(spr_h)
    right_down:add(torrent)
    right_down:add(spr_h)
    right_down:add(ftp)
    right_down:add(spr_h)
    right_down:add(model)
    right_down:add(spr_h)
    right_down:add(voip)
    right_down:add(spr_q)
    right_down:add(off)
    right_down:add(spr)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_down)
    layout:set_right(right_down)
    mywibox[s]:set_widget(layout)

end
-- }}}

-- {{{ Mouse Bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- Take a screenshot
    -- https://github.com/copycat-killer/dots/blob/master/bin/screenshot
    awful.key({ altkey }, "p", function() os.execute("scrot") end),

    -- Tag browsing
    awful.key({ modkey }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey }, "Escape", awful.tag.history.restore),
    
    -- Revelation
    awful.key({ modkey}, "e", revelation),

    -- Non-empty tag browsing
    awful.key({ altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end),
    awful.key({ altkey }, "Right", function () lain.util.tag_view_nonempty(1) end),

    -- Default client focus
    awful.key({ altkey }, "k",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ altkey }, "j",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),

    -- Show Menu
    awful.key({ modkey }, "w",
        function ()
            mymainmenu:show({ keygrabber = true })
        end),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
        mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
    end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),
    awful.key({ altkey, "Shift"   }, "l",      function () awful.tag.incmwfact( 0.05)     end),
    awful.key({ altkey, "Shift"   }, "h",      function () awful.tag.incmwfact(-0.05)     end),
    awful.key({ modkey, "Shift"   }, "l",      function () awful.tag.incnmaster(-1)       end),
    awful.key({ modkey, "Shift"   }, "h",      function () awful.tag.incnmaster( 1)       end),
    awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol(-1)          end),
    awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol( 1)          end),
    awful.key({ modkey,           }, "space",  function () awful.layout.inc(layouts,  1)  end),
    awful.key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(layouts, -1)  end),
    awful.key({ modkey, "Control" }, "n",      awful.client.restore),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r",      awesome.restart),
    awful.key({ modkey, "Shift"   }, "q",      awesome.quit),

    -- Dropdown terminal
    awful.key({ modkey,	          }, "z",      function () drop(terminal) end),

    -- Widgets popups
    awful.key({ altkey,           }, "c",      function () lain.widgets.calendar:show(7) end),
    awful.key({ altkey,           }, "h",      function () fswidget.show(7) end),

    -- ALSA volume control
    awful.key({ altkey }, "Up",
        function ()
            awful.util.spawn("amixer -q set Master 1%+")
            volume.update()
        end),
    awful.key({ altkey }, "Down",
        function ()
            awful.util.spawn("amixer -q set Master 1%-")
            volume.update()
        end),
    awful.key({ altkey }, "m",
        function ()
            awful.util.spawn("amixer -q set Master playback toggle")
            volume.update()
        end),
    awful.key({ altkey, "Control" }, "m",
        function ()
            awful.util.spawn("amixer -q set Master playback 100%")
            volume.update()
        end),

    -- MPD control
    awful.key({ altkey, "Control" }, "p",
        function ()
            awful.util.spawn_with_shell("mpc play || ncmpcpp play || ncmpc play || pms play")
            mpd.update()
        end),

    awful.key({ altkey, "Control" }, "Up",
        function ()
            awful.util.spawn_with_shell("mpc toggle || ncmpcpp toggle || ncmpc toggle || pms toggle")
            mpd.update()
        end),
    awful.key({ altkey, "Control" }, "Down",
        function ()
            awful.util.spawn_with_shell("mpc stop || ncmpcpp stop || ncmpc stop || pms stop")
            mpd.update()
        end),
    awful.key({ altkey, "Control" }, "Left",
        function ()
            awful.util.spawn_with_shell("mpc prev || ncmpcpp prev || ncmpc prev || pms prev")
            mpd.update()
        end),
    awful.key({ altkey, "Control" }, "Right",
        function ()
            awful.util.spawn_with_shell("mpc next || ncmpcpp next || ncmpc next || pms next")
            mpd.update()
        end),

    -- Copy to clipboard
    awful.key({ modkey }, "c", function () os.execute("xsel -p -o | xsel -i -b") end),

    -- User programs
    awful.key({ modkey }, "q", function () awful.util.spawn(browser) end),
    awful.key({ modkey }, "s", function () awful.util.spawn(browser3) end),
    awful.key({ modkey }, "i", function () awful.util.spawn(browser2) end),
    awful.key({ modkey }, "g", function () awful.util.spawn(gui_editor) end),
    awful.key({ modkey }, "m", function () awful.util.spawn(mail) end),

    -- Prompt
    awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end)
    --[[awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)--]]
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons,
	                   size_hints_honor = false } },
    { rule = { class = "URxvt" },
          properties = { --floating = true,
			 tag = tags[1][1] } },

    { rule = { class = "Oblogout" },
	  properties = { floating = true } },

    { rule = { class = "MPlayer" },
          properties = { floating = true,
			 tag = tags[1][5] } },

    { rule = { class = "Vlc" },
	  properties = { tag = tags[1][5] } },

    { rule = { class = "Firefox" },
          properties = { tag = tags[1][2] } },

    { rule = { class = "Chromium" },
	  properties = { tag = tags[1][2] } },

    { rule = { instance = "luakit" },
	  properties = { tag = tags[1][2] } },

    { rule = { class = "Xfce4-terminal" },
          properties = { tag = tags[1][1] } },

    { rule = { instance = "plugin-container" },
          properties = { tag = tags[1][2] } },

    { rule = { instance = "kkedit" },
	  properties = { tag = tags[1][3] } },

    { rule = { class = "Meld" },
	  properties = { tag = tags[1][3] } },

    { rule = { class = "Gimp" },
          properties = { tag = tags[1][4] } },

    { rule = { class = "Blender" },
	  properties = { tag = tags[1][4] } },

    { rule = { class = "Luxrender" },
	  properties = { tag = tags[1][4] } },

    { rule = { class = "Ristretto" },
	  properties = { tag = tags[1][4] } },

    --{ rule = { class = "Gimp", role = "gimp-image-window" },
    --      properties = { maximized_horizontal = true,
    --                     maximized_vertical = true } },

    { rule = { class = "Inkscape" },
	  properties = { tag = tags[1][4] } },

    { rule = { class = "Scribus" },
	  properties = { tag = tags[1][4] } },

    { rule = { class = "Darktable" },
	  properties = { tag = tags[1][4] } },

    { rule = { class = "Thunar" },
	  properties = { tag = tags[1][6] } },

    { rule = { class = "Epsxe" },
	  properties = { floating = true,
			 tag = tags[1][5] } },

    { rule = { class = "Steam" },
	  properties = { tag = tags[1][7] } },

    { rule = { class = "Draftsight" },
	  properties = { tag = tags[1][4] } },

    { rule = { class = "Filezilla" },
          properties = { tag = tags[1][5] } },

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup and not c.size_hints.user_position
       and not c.size_hints.program_position then
        awful.placement.no_overlap(c)
        awful.placement.no_offscreen(c)
    end

--[[    local titlebars_enabled = true
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Title in the middle
        local right_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("right")
        right_layout:add(title)
        right_layout:buttons(buttons)

        local layout = wibox.layout.align.horizontal()
        layout:set_right(right_layout)

        awful.titlebar(c,{position="left", size=16}):set_widget(layout)
    end 
--]]
end)

-- No border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized_horizontal == true and c.maximized_vertical == true then
            c.border_width = 0
            c.border_color = beautiful.border_normal
        else
            c.border_width = beautiful.border_width
            c.border_color = beautiful.border_focus
        end
    end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
        local clients = awful.client.visible(s)
        local layout  = awful.layout.getname(awful.layout.get(s))

        if #clients > 0 then -- Fine grained borders and floaters control
            for _, c in pairs(clients) do -- Floaters always have borders
                if awful.client.floating.get(c) or layout == "floating" then
                    c.border_width = beautiful.border_width

                -- No borders with only one visible client
                elseif #clients == 1 or layout == "max" then
                    clients[1].border_width = 0
                    awful.client.moveresize(0, 0, 2, 2, clients[1])
                else
                    c.border_width = beautiful.border_width
                end
            end
        end
      end)
end
-- }}}
