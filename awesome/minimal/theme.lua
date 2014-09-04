--[[
                                             
     Minimal Awesome WM config 2.0 
     github.com/cornhelius              
                                             
--]]

theme                               = {}

themes_dir                          = os.getenv("HOME") .. "/.config/awesome/themes/minimal"
theme.wallpaper                     = themes_dir .. "/wall.png"

theme.font                          = "Monospace 9"
theme.fg_normal                     = "#FFFFFF" -- scritte non in evidenza
theme.fg_focus                      = "#000000" --"#F0DFAF" scritte in evidenza
theme.fg_urgent                     = "#6495ED" -- scritte tag "urgente"
theme.bg_normal                     = "#000000" --"#1A1A1A" sfondo un-selezione menu rapido/barre awesome
theme.bg_focus                      = "#6495ED" --"#313131" sfondo selezione menu rapido
theme.bg_urgent                     = "#FF000000" -- sfondo tag "urgente"
theme.border_width                  = "1"
theme.border_normal                 = "#000000" -- "#3F3F3F"
theme.border_focus                  = "#ADD8E6" -- "#7F7F7F
theme.border_marked                 = "#6495ED"
theme.titlebar_bg_focus             = "#000000"
theme.titlebar_bg_normal            = "#000000"
theme.taglist_fg_focus              = "#ADD8E6" --"#F4A460" --"#46A8C3" colore focus taglist, scritte
theme.taglist_bg_focus		    = "#FF000000" --"#C0C0C0" colore back focus taglist
theme.tasklist_bg_focus             = "#161616" -- sfondo barra finestra attiva
theme.tasklist_fg_focus             = "#FFFFFF" --"#CC9393" scritta finestra in focus
theme.textbox_widget_margin_top     = 1
theme.notify_fg                     = theme.fg_normal
theme.notify_bg                     = theme.bg_normal
theme.notify_border                 = theme.border_focus
theme.awful_widget_height           = 14
theme.awful_widget_margin_top       = 2
theme.mouse_finder_color            = "#FFFFFF" -- white
theme.menu_height                   = "16"
theme.menu_width                    = "140"
theme.menu_bg_normal		        = "#000000"

-- Colorazioni widget
theme.indicator_low		    = "#ADD8E6" -- lightblue
theme.indicator_low2		    = "#000000"
theme.indicator_high		    = "#6495ED" -- cornflawerblue

theme.menu_submenu_icon             = themes_dir .. "/icons/submenu.png"
theme.taglist_squares_sel           = themes_dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel         = themes_dir .. "/icons/square_unsel.png"

theme.layout_tile                   = themes_dir .. "/icons/tile.png"
theme.layout_tilegaps               = themes_dir .. "/icons/tilegaps.png"
theme.layout_tileleft               = themes_dir .. "/icons/tileleft.png"
theme.layout_tilebottom             = themes_dir .. "/icons/tilebottom.png"
theme.layout_tiletop                = themes_dir .. "/icons/tiletop.png"
theme.layout_fairv                  = themes_dir .. "/icons/fairv.png"
theme.layout_fairh                  = themes_dir .. "/icons/fairh.png"
theme.layout_spiral                 = themes_dir .. "/icons/spiral.png"
theme.layout_dwindle                = themes_dir .. "/icons/dwindle.png"
theme.layout_max                    = themes_dir .. "/icons/max.png"
theme.layout_fullscreen             = themes_dir .. "/icons/fullscreen.png"
theme.layout_magnifier              = themes_dir .. "/icons/magnifier.png"
theme.layout_floating               = themes_dir .. "/icons/floating.png"

theme.tasklist_disable_icon         = true
theme.tasklist_floating             = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical   = ""

theme.useless_gap_width = 10

return theme
