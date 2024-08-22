# Tidbyt
App(s) for Tidbyt clock

Run the parent folder of the main starlark file, not the file itself
For a folder "a", the main file must be "a.star"\

Animate kirby moving up and down with the animation transformation. I think ease in is the best one or maybe in and out

A frame is 50 ms

animation.Transformation duration is in units of frames

When stacking an animation.Transformation with a render.Animation, the animation.Transformation doesn't start again until the render.Animation
is finished. The solution here is to make the animation.Transformation duration the same as the number of frames in the render.Animation,
then just generate a crap ton of intermediate key frames which make kirby oscillate.