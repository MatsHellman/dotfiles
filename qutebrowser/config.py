c.colors.webpage.darkmode.enabled = True
# :config-cycle colors.webpage.darkmode.enabled
c.aliases['darkmode'] = "config-cycle colors.webpage.darkmode.enabled"

# -----------------------
# UI FONTS (Fira Code)
# -----------------------
c.fonts.default_family = "Fira Code"
c.fonts.default_size = "12pt"   # change to "16pt" if you want bigger UI

c.fonts.statusbar = "12pt Fira Code"
c.fonts.tabs.selected = "12pt Fira Code"
c.fonts.tabs.unselected = "12pt Fira Code"
c.fonts.prompts = "12pt Fira Code"
c.fonts.completion.entry = "12pt Fira Code"
c.fonts.completion.category = "bold 12pt Fira Code"
c.fonts.debug_console = "12pt Fira Code"
c.fonts.keyhint = "12pt Fira Code"

# -----------------------
# WEB FONTS (Readable)
# -----------------------
c.fonts.web.family.standard = "Inter"
c.fonts.web.family.sans_serif = "Inter"
c.fonts.web.family.serif = "Noto Serif"
c.fonts.web.family.fixed = "Fira Code"

# Web font sizes
c.fonts.web.size.default = 16
c.fonts.web.size.default_fixed = 15



import catppuccin

# load your autoconfig, use this, if the rest of your config is empty!
config.load_autoconfig()

# set the flavor you'd like to use
# valid options are 'mocha', 'macchiato', 'frappe', and 'latte'
# last argument (optional, default is False): enable the plain look for the menu rows
catppuccin.setup(c, 'mocha', True)

# ------------------------
# Keybinds
# ------------------------

# unbind default quickmark key
config.unbind("m")
# open current page in mpv
config.bind("m", "spawn -d mpv {url}")
