load("http.star", "http")
load("render.star", "render")
load("encoding/base64.star", "base64")
load("animation.star", "animation")
load("schema.star", "schema")
load("frames.star", "KIRBY_FRAMES", "SKY_FRAMES")
load("time.star", "time")
load("math.star", "math")

def slow_frames(frames, slow_factor):
    new_frames = []
    for frame in frames:
        new_frames += [frame] * slow_factor
    return new_frames

def create_kirby_oscillation_key_frames(curve, oscillation_height, n_oscillations_per_sky_cycle):
    top = int((oscillation_height + 1) / 2) # Lean towards going up on odd oscillation height
    bottom = -1 * (oscillation_height - top)
    keyframes = [
        animation.Keyframe(
            percentage = 0.0,
            transforms = [animation.Translate(0, top)],
            curve = curve,
        )
    ]
    percentage = 0.0
    percentage_step = (1.0 / n_oscillations_per_sky_cycle) / 2
    for _ in range(n_oscillations_per_sky_cycle):
        percentage += percentage_step
        keyframes.append(
            animation.Keyframe(
                percentage = percentage,
                transforms = [animation.Translate(0, bottom)],
                curve = curve,
            )
        )
        percentage += percentage_step
        if percentage > 1.0:
            percentage = 1.0
        keyframes.append(
            animation.Keyframe(
                percentage = percentage,
                transforms = [animation.Translate(0, top)],
                curve = curve,
            )
        )
    return keyframes

def kirby_float_curve(x):
    if x < 0.125:
        return 0.0
    if x > 0.875:
        return 1.0
    return (x - 0.125) * (1.0 / 0.75)

def main():
    kirby_slow_factor = 2
    kirby_animation = render.Animation(
        children = slow_frames(KIRBY_FRAMES, kirby_slow_factor)
    )

    n_sky_frames = len(SKY_FRAMES)
    sky_slow_factor = 12
    sky_animation = render.Animation(
        children = slow_frames(SKY_FRAMES, sky_slow_factor)
    )

    night_time_animation = render.Stack(  
            children = [
                sky_animation,
                animation.Transformation( # This animation only replays once the other animations in this stack are done. Check README for workaround.
                    child = kirby_animation,
                    duration = n_sky_frames * sky_slow_factor, # Duration is in units of frames. Frames are 50 ms long.
                    delay = 0,
                    origin = animation.Origin(0, 0),
                    direction = "alternate",
                    fill_mode = "forwards",
                    keyframes = create_kirby_oscillation_key_frames(kirby_float_curve, 3, 5),
                ),
                render.Text()
            ]
        )

    return render.Root(
        child = night_time_animation,
        show_full_animation = True
    )

# def get_schema():
#     return schema.Schema(
#         version = "1",
#         fields = [
#             schema.Location(
#                 id = "location",
#                 name = "Location",
#                 desc = "Location for which to display time.",
#                 icon = "locationDot",
#             ),
#         ],
#     )