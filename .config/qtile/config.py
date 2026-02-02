# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess
from libqtile import bar, hook, layout, qtile
from libqtile.backend.wayland.inputs import InputConfig
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from qtile_extras import widget
from qtile_extras.widget.decorations import BorderDecoration

IS_WAYLAND = qtile.core.name == "wayland"
IS_X11 = qtile.core.name == "x11"

mod = "mod4"
myTerminal = "alacritty"
myFileManager = "thunar"
myBrowser = "firefox"
myEmacs = "emacsclient -c -a 'emacs' "
myLogout = "wlogout" if IS_WAYLAND else "rofi -show p -modi p:rofi-power-menu"

colors = [
    ["#282c34", "#282c34"],  # bg
    ["#bbc2cf", "#bbc2cf"],  # fg
    ["#1c1f24", "#1c1f24"],  # color01
    ["#ff6c6b", "#ff6c6b"],  # color02
    ["#98be65", "#98be65"],  # color03
    ["#da8548", "#da8548"],  # color04
    ["#51afef", "#51afef"],  # color05
    ["#c678dd", "#c678dd"],  # color06
    ["#46d9ff", "#46d9ff"],  # color15
]

keys = [
    Key([mod], "Return", lazy.spawn(myTerminal), desc="Terminal"),
    Key([mod, "shift"], "Return", lazy.spawn(myFileManager), desc="File manager"),
    Key(
        [mod], "space", lazy.spawn("rofi -show combi -show-icons"), desc="Run launcher"
    ),
    Key([mod], "w", lazy.spawn(myBrowser), desc="Browser"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod], "x", lazy.spawn(myLogout), desc="Logout menu"),
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window left"),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows
    Key(
        [mod],
        "equal",
        lazy.layout.grow_left().when(layout=["bsp", "columns"]),
        lazy.layout.grow().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left",
    ),
    Key(
        [mod],
        "minus",
        lazy.layout.grow_right().when(layout=["bsp", "columns"]),
        lazy.layout.shrink().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left",
    ),
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between different layouts as defined below
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod],
        "t",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    # Switch between monitors
    Key(
        [mod],
        "period",
        lazy.next_screen(),
        desc="Move focus to next monitor",
    ),
    Key(
        [mod],
        "comma",
        lazy.prev_screen(),
        desc="Move focus to previous monitor",
    ),
    KeyChord(
        [mod],
        "e",
        [
            Key([], "e", lazy.spawn(myEmacs), desc="Emacs Dashboard"),
            Key(
                [],
                "b",
                lazy.spawn(myEmacs + "--eval '(ibuffer)'"),
                desc="Emacs Ibuffer",
            ),
            Key(
                [],
                "d",
                lazy.spawn(myEmacs + "--eval '(dired nil)'"),
                desc="Emacs Dired",
            ),
            Key([], "m", lazy.spawn(myEmacs + "--eval '(=mu4e)'"), desc="Emacs MU4E"),
            Key([], "v", lazy.spawn(myEmacs + "--eval '(vterm)'"), desc="Emacs VTerm"),
            Key(
                [],
                "w",
                lazy.spawn(myEmacs + "--eval '(eww \"start.duckduckgo.com\")'"),
                desc="Emacs EWW",
            ),
            Key(
                [],
                "F4",
                lazy.spawn("killall emacs"),
                lazy.spawn("/usr/bin/emacs --daemon"),
                desc="Kill/restart the Emacs daemon",
            ),
        ],
    ),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


groups = [
    Group(i) for i in ["DEV", "WWW", "GAME", "DOC", "VIRT", "CHAT", "MUS", "VID", "GFX"]
]

for i, g in enumerate(groups, start=1):
    keys.extend(
        [
            # mod1 + group number = switch to group
            Key(
                [mod],
                str(i),
                lazy.group[g.name].toscreen(),
                desc="Switch to group {}".format(g.name),
            ),
            # mod1 + shift + group number = move focused window to group
            Key(
                [mod, "shift"],
                str(i),
                lazy.window.togroup(g.name, switch_group=False),
                desc="Switch to & move focused window to group {}".format(g.name),
            ),
        ]
    )

layout_theme = {
    "border_width": 2,
    "margin": 8,
    "border_focus": colors[8],
    "border_normal": colors[0],
}

layouts = [
    # layout.Bsp(**layout_theme),
    # layout.Columns(**layout_theme),
    # layout.Matrix(**layout_theme),
    layout.MonadTall(**layout_theme),
    # layout.MonadWide(**layout_theme),
    layout.Max(**layout_theme),
    # layout.RatioTile(**layout_theme),
    # layout.Stack(num_stacks=2),
    # layout.Tile(**layout_theme),
    # layout.TreeTab(**layout_theme),
    # layout.VerticalTile(**layout_theme),
    # layout.Zoomy(**layout_theme),
]

widget_defaults = dict(
    font="Ubuntu Bold",
    fontsize=12,
    padding=0,
    background=colors[0],
)
extension_defaults = widget_defaults.copy()


def init_widgets():
    return [
        widget.Image(
            filename="~/.config/qtile/logo.png",
            scale="False",
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(myTerminal)},
        ),
        widget.GroupBox(
            fontsize=11,
            margin_y=5,
            margin_x=5,
            padding_y=0,
            padding_x=1,
            borderwidth=3,
            active=colors[7],
            inactive=colors[1],
            rounded=False,
            highlight_color=colors[2],
            highlight_method="line",
            this_current_screen_border=colors[6],
            this_screen_border=colors[4],
            other_current_screen_border=colors[6],
            other_screen_border=colors[4],
        ),
        widget.TextBox(
            text="|", font="Ubuntu Mono", foreground=colors[1], padding=2, fontsize=14
        ),
        widget.CurrentLayoutIcon(
            # custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
            foreground=colors[1],
            padding=4,
            scale=0.6,
        ),
        widget.CurrentLayout(foreground=colors[1], padding=5),
        widget.TextBox(
            text="|", font="Ubuntu Mono", foreground=colors[1], padding=2, fontsize=14
        ),
        widget.WindowName(foreground=colors[6], max_chars=40),
        widget.GenPollText(
            update_interval=300,
            func=lambda: subprocess.check_output(
                "printf $(uname -r)", shell=True, text=True
            ),
            foreground=colors[3],
            fmt="  {}",
            decorations=[
                BorderDecoration(
                    colour=colors[3],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.CPU(
            format="▓  Cpu: {load_percent}%",
            foreground=colors[4],
            decorations=[
                BorderDecoration(
                    colour=colors[4],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.Memory(
            foreground=colors[8],
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(myTerminal + " -e htop")
            },
            format="{MemUsed: .0f}{mm}",
            fmt="🖥  Mem: {} used",
            decorations=[
                BorderDecoration(
                    colour=colors[8],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.DF(
            update_interval=60,
            foreground=colors[5],
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(myTerminal + " -e df")},
            partition="/",
            # format="[{p}] {uf}{m} ({r:.0f}%)",
            format="{uf}{m} free",
            fmt="🖴  Disk: {}",
            visible_on_warn=False,
            decorations=[
                BorderDecoration(
                    colour=colors[5],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.PulseVolume(
            foreground=colors[7],
            fmt="🕫  Vol: {}",
            step=5,
            decorations=[
                BorderDecoration(
                    colour=colors[7],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.Clock(
            foreground=colors[8],
            format="⏱  %a, %b %d - %H:%M",
            decorations=[
                BorderDecoration(
                    colour=colors[8],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.StatusNotifier(padding=3),
        widget.Spacer(length=8),
    ]


def init_screens():
    return [
        Screen(top=bar.Bar(widgets=init_widgets(), size=26)),
        Screen(top=bar.Bar(widgets=init_widgets(), size=26)),
    ]


screens = init_screens()

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = True
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = {
    "*": InputConfig(accel_profile="flat", pointer_accel=0),
    "type:keyboard": InputConfig(
        kb_options="caps:escape_shifted_capslock",
        kb_repeat_delay=250,
        kb_repeat_rate=75,
    ),
}


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/autostart.sh"])


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
