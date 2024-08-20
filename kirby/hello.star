load("render.star", "render")

def main():
    print(10)
    return render.Root(
        child = render.Text("Hello, World!"),
    )