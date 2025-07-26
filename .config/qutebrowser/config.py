import theme

config.load_autoconfig(False)

theme.setup(c, {"spacing": {"vertical": 5, "horizontal": 5}})

# Setting dark mode
c.colors.webpage.preferred_color_scheme = "dark"

# Enabling Brave adblock
# Need to install python-adblock or adblock package on system
c.content.blocking.method = "both"

# Auto restore session
c.auto_save.session = True

# Don't autoplay videos
c.content.autoplay = False

# Set default search engine and new tab page
c.url.searchengines = {"DEFAULT": "https://www.startpage.com/sp/search?query={}"}
c.url.default_page = "https://www.startpage.com/"
c.url.start_pages = "https://www.startpage.com/"

# Keybindings
config.bind("m", "spawn mpv {url}")
config.bind("M", "hint links spawn mpv {hint-url}")
config.bind("Z", "hint links spawn alacritty -e yt-dlp {hint-url}")
config.bind("xb", "config-cycle statusbar.show always never")
config.bind("xt", "config-cycle tabs.show always never")
config.bind(
    "xx",
    "config-cycle statusbar.show always never;; config-cycle tabs.show always never",
)
config.bind("<Ctrl-Shift-r>", "config-source")
config.bind("<Ctrl-j>", "completion-item-focus --history next", mode="command")
config.bind("<Ctrl-k>", "completion-item-focus --history prev", mode="command")
config.bind("J", "tab-prev")
config.bind("K", "tab-next")
config.bind("gJ", "tab-move -")
config.bind("gK", "tab-move +")
config.bind("<Ctrl-1>", "tab-focus 1")
config.bind("<Ctrl-2>", "tab-focus 2")
config.bind("<Ctrl-3>", "tab-focus 3")
config.bind("<Ctrl-4>", "tab-focus 4")
config.bind("<Ctrl-5>", "tab-focus 5")
config.bind("<Ctrl-6>", "tab-focus 6")
config.bind("<Ctrl-7>", "tab-focus 7")
config.bind("<Ctrl-8>", "tab-focus 8")
config.bind("<Ctrl-9>", "tab-focus 9")
