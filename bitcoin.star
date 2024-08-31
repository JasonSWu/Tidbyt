load("http.star", "http")
load("render.star", "render")
load("encoding/base64.star", "base64")

COINDESK_PRICE_URL = "https://api.coindesk.com/v1/bpi/currentprice.json"

BTC_ICON = base64.decode("""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""")

def main():
    rep = http.get(COINDESK_PRICE_URL, ttl_seconds = 10)
    if rep.status_code != 200:
        fail("Coindesk request failed with status %d", rep.status_code)
    rate = rep.json()["bpi"]["USD"]["rate_float"]

    return render.Root(
        child = render.Box(
            render.Row(
                expanded = True,
                main_align = "space_evenly",
                cross_align = "center",
                children = [
                    render.Image(src = BTC_ICON),
                    render.Text("$%d" % rate),
                ],
            ),
        ),
    )