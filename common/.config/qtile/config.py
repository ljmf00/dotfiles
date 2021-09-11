# -*- coding: utf-8 -*-
from typing import List  # noqa: F401

import os
import platform
import logging

from libqtile import layout, hook, bar, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.backend.x11.xkeysyms import keysyms

from Xlib import display as xdisplay
import pyudev

# =============================================================================
# LOGGING
# =============================================================================

XDG_DATA_HOME = os.environ.get('XDG_DATA_HOME')
if not XDG_DATA_HOME:
    XDG_DATA_HOME = ".local/share/"

logging.basicConfig(
    filename=os.path.join(XDG_DATA_HOME, "qtile/qtile.log"),
    filemode="a",
    level=logging.INFO,
)

logging.info("Reinitializing config!")

# =============================================================================
# MISCELLANEOUS
# =============================================================================

hostname = platform.node()
logging.info(f"Running on hostname '{hostname}'")

# =============================================================================
# KEYBINDINGS
# =============================================================================


class KeysHolder:
    """
    Key holder helper to alias common keysyms names
    """

    # Arrow keys
    UP: str
    DOWN: str
    LEFT: str
    RIGHT: str

    TAB : str
    SPACE: str

    EXCLAM: str
    QUOTEDBL: str

    def __init__(self):
        # set attribute for every key found in Qtile's keysyms
        for key in keysyms.keys():
            self_key = key.upper()
            if key[0] in range(0, 9):
                # for numbers, prepend K
                self_key = "K" + self_key
            setattr(self, self_key, key)

        # special aliases
        self.ALT = self.MOD1 = "mod1"
        self.HYPER = self.MOD3 = "mod3"
        self.SUPER = self.MOD4 = "mod4"
        self.SHIFT = "shift"
        self.CONTROL = "control"
        self.EXCLAMATION = self.EXCLAM
        self.DOUBLE_QUOTE = self.QUOTEDBL


class MouseButtons:
    """
    A collection of mouse button aliases
    """
    LEFT = BUTTON1 = "Button1"
    MIDDLE = BUTTON2 = "Button2"
    RIGHT = BUTTON3 = "Button3"
    WHEEL_UP = BUTTON4 = "Button4"
    WHEEL_DOWN = BUTTON5 = "Button5"
    WHEEL_LEFT = BUTTON6 = "Button6"
    WHEEL_RIGHT = BUTTON7 = "Button7"
    PREVIOUS = BUTTON8 = "Button8"
    NEXT = BUTTON9 = "Button9"


k = KeysHolder()
m = MouseButtons()

# Used mod key
mod = k.SUPER

terminal = guess_terminal()
keys = [

    Key([mod], "space", lazy.layout.next(),
        desc="Move window focus to other window"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(),
        desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),

    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(),
        desc="Spawn a command using a prompt widget"),

    # Actions for focused windows
    # ---------------------------

    # Close an application
    Key([k.ALT], "F4", lazy.window.kill(), desc="Kill focused window"),

    # Switch between windows
    Key([mod], k.UP, lazy.layout.up(), desc="Move focus to up"),
    Key([mod], k.DOWN, lazy.layout.down(), desc="Move focus to down"),
    Key([mod], k.RIGHT, lazy.layout.right(), desc="Move focus to right"),
    Key([mod], k.LEFT, lazy.layout.left(), desc="Move focus to left"),

    # Vim-like shortcuts
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),


    # Spawn applications
    # ------------------

    # Terminal
    Key(
        [k.ALT, k.CONTROL], "t",
        lazy.spawn(terminal),
        desc="Launch terminal"
    ),

    # File manager
    Key(
        [k.ALT, k.CONTROL], "f",
        lazy.spawn("nautilus -w"),
        desc="Launch file manager"
    ),

    # Rofi
    Key(
        [mod], "d",
        lazy.spawn("rofi -show run -theme menu-bar"),
        desc="Quick command runner"
    ),
    Key(
        [mod, k.SHIFT], "d",
        lazy.spawn("rofi -show drun -show-icons -theme menu-center"),
        desc="Quick application launcher"
    ),
    Key(
        [mod], "e",
        lazy.spawn("rofimoji"),
        desc="Quick emoji picker"
    ),
]

groups = [Group(str(i)) for i in range(1, 21)]

for i in groups:
    n = int(i.name)
    if n == 10:
        i_key = '0'
    elif n > 10:
        # use function keys
        i_key = 'F' + str(n - 10)
    else:
        i_key = i.name

    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i_key, lazy.group[i.name].toscreen(toggle=False),
            desc="Switch to group {}".format(i.name)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i_key, lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
        #     desc="move focused window to group {}".format(i.name)),
    ])

layouts = [
    layout.Columns(border_focus_stack='#d75f5f'),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font='monospace',
    fontsize=12,
    padding=3,
)

extension_defaults = widget_defaults.copy()


# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(title='branchdialog'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass

    # GPG key password entry
    Match(title='pinentry'),
    Match(wm_class='pinentry-gtk-2'),

    # Generic WM classes
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
])
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

# =============================================================================
# SCREEN
# =============================================================================

screens: List[Screen] = []

additional_widgets_right = {
        'deimos': [
            widget.Battery(
                energy_now_file='charge_now',
                energy_full_file='charge_full',
                power_now_file='current_now',
                **widget_defaults
            ),
        ]
    }.get(hostname, [])

# To save time and machine resources instanciate widgets only one time to share
# values across multiple Bar instances
resources_widgets = [
    # Disk IO Usage
    widget.TextBox('\U0001F5B4'),
    widget.HDDBusyGraph(
         width=30,
         border_width=1,
         border_color="#000000",
         line_width=1,
         frequency=5,
         samples=50,
        ),
    # Network Usage
    widget.TextBox('\U0001F310'),
    widget.NetGraph(
         width=30,
         border_width=1,
         border_color="#000000",
         line_width=1,
         frequency=5,
         samples=50,
         fill_color="EEE8AA",
    ),

    # CPU Usage
    widget.CPU(
        format='CPU {load_percent}%',
        update_interval=1.5,
    ),
    widget.CPUGraph(
        width=30,
        border_width=1,
        border_color="#000000",
        frequency=5,
        line_width=1,
        samples=50,
    ),

    # RAM Usage
    widget.Memory(
        format='RAM {MemPercent}%',
        update_interval=1.5,
    ),
    widget.MemoryGraph(
         width=30,
         border_width=1,
         border_color="#000000",
         line_width=1,
         frequency=5,
         samples=50,
         fill_color="F9BC16",
     ),
]

# Shared Clock widget collection
clock_widgets = [
    # Date
    widget.Clock(foreground='8fbcbb', format='\U0001F4C5 %A, %d %b %Y'),
    # Time
    widget.Clock(foreground='b48ead', format='\U0001F551 %H:%M'),
]

def setup_screens(num_screens: int = 1) -> None:
    """
    Setup screens list according to a given number
    """
    screens.clear()
    for _ in range(num_screens):
        bar_instance = bar.Bar(
            [
                # Left
                widget.GroupBox(
                    disable_drag=True,
                    hide_unused=True,
                ),
                widget.Prompt(),

                # Center
                widget.Spacer(),
                widget.WindowName(),
                widget.Spacer(),

                # Right
                *additional_widgets_right,
                *resources_widgets,
                *clock_widgets,
                widget.Systray(),
                widget.KeyboardLayout(
                    #TODO: Add mouse callbacks to switch keyboard layout
                    display_map={
                        'us': '\U0001F1FA\U0001F1F8',
                        'pt': '\U0001F1F5\U0001F1F9',
                    }
                ),
            ],
            18,
        )

        screen_instance = Screen(
            top=bar_instance,
            wallpaper='~/wallpapers/mac_computer.jpg',
            wallpaper_mode='fill',
        )

        screens.append(screen_instance)


def detect_screens(qtile) -> None:
    """
    Detect if a new screen is plugged and reconfigure/restart qtile
    """

    def update_screens_callback(action=None, device=None) -> None:
        """
        Callback to setup monitors
        """

        if action == "change":
            lazy.restart()

        num_screens = len(qtile.conn.pseudoscreens)
        setup_screens(num_screens)

    context = pyudev.Context()
    monitor = pyudev.Monitor.from_netlink(context)
    monitor.filter_by('drm')
    monitor.enable_receiving()

    # observe if the monitors change and reset monitors config
    observer = pyudev.MonitorObserver(monitor, update_screens_callback)
    observer.start()


def get_num_screens() -> int:
    """
    Get number of active screens
    """
    num_monitors = 0
    try:
        display = xdisplay.Display()
        screen = display.screen()
        resources = screen.root.xrandr_get_screen_resources()

        for output in resources.outputs:
            monitor = display.xrandr_get_output_info(output, resources.config_timestamp)
            preferred = False
            if hasattr(monitor, "preferred"):
                preferred = monitor.preferred
            elif hasattr(monitor, "num_preferred"):
                preferred = monitor.num_preferred
            if preferred:
                num_monitors += 1
    except Exception as e:
        # always setup at least one monitor
        logging.error(e)
        return 1
    else:
        return num_monitors

logging.info(f"Number of screens detected: {get_num_screens()}")
setup_screens(max(1, get_num_screens()))

# =============================================================================
# HOOKS
# =============================================================================


# Screen change Hook
@hook.subscribe.screen_change
def restart_on_randr(qtile, ev):
    qtile.cmd_restart()


@hook.subscribe.client_new
def new_client(client):
    if client.window.get_wm_class()[0] == "screenkey":
        client.static(0)

# =============================================================================
# ENTRYPOINT
# =============================================================================


def main(qtile):
    detect_screens(qtile)

# vim: tabstop=4 shiftwidth=4 expandtab
