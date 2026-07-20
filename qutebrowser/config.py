# ---------------------
# 1. AUTO-CONFIGURATION
# ---------------------

# Disable loading of the autoconfig file, ensuring manual settings (config.py) take precedence.
# config.load_autoconfig(False)

# Import external modules (necessary for config.source)
import os
import sys

# sys.path.append(str(config.configdir / "themes"))
config.source('habamax.py')

# Source the external color scheme file (Tokyonight Dark)
# Make sure your themes/tokyonight_dark.py file exists and contains the c.colors settings.
# config.source('themes/tokyonight_dark.py')

#       catppuccin-theme
# import catppuccin

# load your autoconfig, use this, if the rest of your config is empty!
config.load_autoconfig()

# set the flavor you'd like to use
# valid options are 'mocha', 'macchiato', 'frappe', and 'latte'
# last argument (optional, default is False): enable the plain look for the menu rows
# catppuccin.setup(c, 'mocha', True)


# ---------------------
# 2. DARK MODE SETTINGS
# ---------------------

# Enable dark mode rendering for all web content.
config.set('colors.webpage.darkmode.enabled', True)

# Set the preferred color scheme media feature (in case websites support native dark mode).
config.set('colors.webpage.preferred_color_scheme', 'dark')

# Do not invert colors for images (optional, prevents images from looking weird).
config.set('colors.webpage.darkmode.policy.images', 'never')


# -----------------
# 3. FONT SETTINGS 
# -----------------

# Define font size and name variables for easy management
font_size = '13pt'
font_name = 'JetBrains Mono Nerd Font'

# UI Fonts (c.fonts.xxx) - Apply to Qutebrowser's interface (Statusbar, Tabs, etc.)

# Base Font Settings
c.fonts.default_size = font_size
c.fonts.default_family = font_name

# Command Line and Messages Font
c.fonts.completion.category = f'normal {font_size} {font_name}'
c.fonts.completion.entry = f'{font_size} {font_name}'
c.fonts.debug_console = f'{font_size} {font_name}'
c.fonts.messages.info = f'{font_size} {font_name}'
c.fonts.prompts = f'{font_size} {font_name}'

# Hints Font
c.fonts.hints = f'normal {font_size} {font_name}'

# Statusbar Font
c.fonts.statusbar = f'{font_size} {font_name}'

# Tabs Font
c.fonts.tabs.selected = f'normal {font_size} {font_name}'
c.fonts.tabs.unselected = f'{font_size} {font_name}'
