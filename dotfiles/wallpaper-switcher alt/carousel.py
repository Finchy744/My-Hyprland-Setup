import gi

gi.require_version("Gtk", "4.0")
gi.require_version("Graphene", "1.0")
gi.require_version("Gsk", "4.0")
from gi.repository import Gtk, Gdk, Graphene, Gsk

from thumbnail import get_thumbnail_path
from utils import get_pywal_color

ANIMATION_SPEED = 0.18

BASE_WIDTH = 420
BASE_HEIGHT = 260
SELECTED_WIDTH = 700
CARD_SPACING = 40

SKEW_DEGREES = -10

BORDER_WIDTH = 4
CORNER_RADIUS = 14

GLOW_BLUR_RADIUS = 40
GLOW_SPREAD = 4


def get_border_color():
    color = Gdk.RGBA()
    hex_color = get_pywal_color(1) or "#ff3b3b"
    color.parse(hex_color)
    return color


def get_glow_color():
    color = Gdk.RGBA()
    hex_color = get_pywal_color(1) or "#ff3b3b"
    color.parse(hex_color)
    color.alpha = 0.6
    return color


BORDER_COLOR = get_border_color()
GLOW_COLOR = get_glow_color()


class WallpaperCard:
    def __init__(self, wallpaper):
        self.wallpaper = wallpaper

        picture = Gtk.Picture.new_for_filename(str(get_thumbnail_path(wallpaper)))
        self.paintable = picture.get_paintable()

        self.current_x = 0.0
        self.current_scale = 1.0
        self.current_opacity = 1.0

        self.target_x = 0.0
        self.target_scale = 1.0
        self.target_opacity = 1.0

    def update(self):
        self.current_x += (self.target_x - self.current_x) * ANIMATION_SPEED
        self.current_scale += (self.target_scale - self.current_scale) * ANIMATION_SPEED
        self.current_opacity += (self.target_opacity - self.current_opacity) * ANIMATION_SPEED

    def settled(self):
        return (
            abs(self.current_x - self.target_x) < 0.5
            and abs(self.current_scale - self.target_scale) < 0.005
            and abs(self.current_opacity - self.target_opacity) < 0.005
        )

    def set_target(self, distance, is_selected):
        abs_distance = abs(distance)
        spacing = BASE_WIDTH + CARD_SPACING
        self.target_x = distance * spacing

        if is_selected:
            self.target_scale = SELECTED_WIDTH / BASE_WIDTH
            self.target_opacity = 1.0
        else:
            self.target_scale = max(1.0 - (abs_distance * 0.12), 0.55)
            self.target_opacity = max(1.0 - (abs_distance * 0.18), 0.35)


class WallpaperCarousel(Gtk.Widget):

    def __init__(self, wallpapers, initial_index=0, on_apply=None, on_escape=None):
        super().__init__()

        self.wallpapers = wallpapers
        self.cards = [WallpaperCard(w) for w in wallpapers]
        self.selected_index = initial_index
        self.on_apply = on_apply
        self.on_escape = on_escape
        self.animating = False

        self.set_focusable(True)
        self.connect("realize", lambda *_: self.grab_focus())

        controller = Gtk.EventControllerKey()
        controller.connect("key-pressed", self.on_key_pressed)
        self.add_controller(controller)

        scroll_controller = Gtk.EventControllerScroll.new(
            Gtk.EventControllerScrollFlags.BOTH_AXES
        )
        scroll_controller.connect("scroll", self.on_scroll)
        self.add_controller(scroll_controller)

        click_controller = Gtk.GestureClick.new()
        click_controller.connect("released", self.on_click)
        self.add_controller(click_controller)

        self.update_targets(instant=True)

    def do_measure(self, orientation, for_size):
        if orientation == Gtk.Orientation.HORIZONTAL:
            return (-1, 1400, -1, -1)
        return (-1, 700, -1, -1)

    def do_snapshot(self, snapshot):
        width = self.get_width()
        height = self.get_height()

        center_x = width / 2
        center_y = height / 2

        for i, card in enumerate(self.cards):
            w = BASE_WIDTH * card.current_scale
            h = BASE_HEIGHT * card.current_scale

            x = center_x + card.current_x - (w / 2)
            y = center_y - (h / 2)

            snapshot.save()

            pivot_x = x + (w / 2)
            pivot_y = y + (h / 2)

            snapshot.translate(Graphene.Point().init(pivot_x, pivot_y))

            transform = Gsk.Transform.new()
            transform = transform.skew(SKEW_DEGREES, 0)
            snapshot.transform(transform)

            snapshot.translate(Graphene.Point().init(-w / 2, -h / 2))

            bounds = Graphene.Rect()
            bounds.init(0, 0, w, h)

            rounded = Gsk.RoundedRect()
            rounded.init_from_rect(bounds, CORNER_RADIUS)

            if i == self.selected_index:
                snapshot.append_outset_shadow(
                    rounded,
                    GLOW_COLOR,
                    0, 0,
                    GLOW_SPREAD,
                    GLOW_BLUR_RADIUS,
                )

            snapshot.push_opacity(card.current_opacity)
            snapshot.push_rounded_clip(rounded)
            card.paintable.snapshot(snapshot, w, h)
            snapshot.pop()
            snapshot.pop()

            if i == self.selected_index:
                widths = [BORDER_WIDTH, BORDER_WIDTH, BORDER_WIDTH, BORDER_WIDTH]
                colors = [BORDER_COLOR, BORDER_COLOR, BORDER_COLOR, BORDER_COLOR]

                snapshot.append_border(rounded, widths, colors)

            snapshot.restore()

    def start_animation_loop(self):
        if self.animating:
            return
        self.animating = True
        self.add_tick_callback(self.animate)

    def animate(self, widget, frame_clock):
        all_settled = True

        for card in self.cards:
            card.update()
            if not card.settled():
                all_settled = False

        self.queue_draw()

        if all_settled:
            self.animating = False
            return False

        return True

    def update_targets(self, instant=False):
        for i, card in enumerate(self.cards):
            distance = i - self.selected_index
            card.set_target(distance, i == self.selected_index)

            if instant:
                card.current_x = card.target_x
                card.current_scale = card.target_scale
                card.current_opacity = card.target_opacity

        self.queue_draw()
        self.start_animation_loop()

    def on_key_pressed(self, controller, keyval, keycode, state):
        if keyval == Gdk.KEY_Escape:
            if self.on_escape:
                self.on_escape()
        elif keyval == Gdk.KEY_Right:
            if self.selected_index < len(self.cards) - 1:
                self.selected_index += 1
                self.update_targets()
        elif keyval == Gdk.KEY_Left:
            if self.selected_index > 0:
                self.selected_index -= 1
                self.update_targets()
        elif keyval in (Gdk.KEY_Return, Gdk.KEY_KP_Enter):
            self.apply_current()

    def on_scroll(self, controller, dx, dy):
        # Treat either axis as a "step" so both trackpads and mouse wheels work
        delta = dx if abs(dx) > abs(dy) else dy

        if delta > 0:
            if self.selected_index < len(self.cards) - 1:
                self.selected_index += 1
                self.update_targets()
        elif delta < 0:
            if self.selected_index > 0:
                self.selected_index -= 1
                self.update_targets()

        return True

    def on_click(self, gesture, n_press, x, y):
        width = self.get_width()
        center_x = width / 2

        # Find whichever card's un-skewed center is closest to the click x position
        closest_index = None
        closest_distance = None

        for i, card in enumerate(self.cards):
            card_center_x = center_x + card.current_x
            distance = abs(x - card_center_x)

            if closest_distance is None or distance < closest_distance:
                closest_distance = distance
                closest_index = i

        if closest_index is None:
            return

        if closest_index == self.selected_index:
            self.apply_current()
        else:
            self.selected_index = closest_index
            self.update_targets()

    def apply_current(self):
        wallpaper = self.cards[self.selected_index].wallpaper
        if self.on_apply:
            self.on_apply(wallpaper)