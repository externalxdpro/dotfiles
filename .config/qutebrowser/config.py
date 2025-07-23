import theme

config.load_autoconfig(False)

theme.setup(c, {
    "spacing": {
        "vertical": 5,
        "horizontal": 5
    }
})

# Setting dark mode
c.colors.webpage.preferred_color_scheme = "dark"

# Enabling Brave adblock
#config.set("content.blocking.method", "adblock");
c.content.blocking.method = "both"      # Need to install python-adblock or adblock package on system

# Auto restore session
c.auto_save.session = True

# Don't autoplay videos
c.content.autoplay = False

# Keybindings
config.bind('m', 'spawn mpv {url}')
config.bind('M', 'hint links spawn mpv {hint-url}')
config.bind('Z', 'hint links spawn alacritty -e yt-dlp {hint-url}')
config.bind('xb', 'config-cycle statusbar.show always never')
config.bind('xt', 'config-cycle tabs.show always never')
config.bind('xx', 'config-cycle statusbar.show always never;; config-cycle tabs.show always never')
