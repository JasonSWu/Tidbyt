load("http.star", "http")
load("render.star", "render")
load("encoding/base64.star", "base64")

COINDESK_PRICE_URL = "https://api.coindesk.com/v1/bpi/currentprice.json"

BTC_ICON = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAAEAAAAAgCAYAAACinX6EAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAAFiUAABYlAUlSJPAAAAMESURBVGhD5Zg/aBRBFMZnL/GC2oiFcIHV6lBIpYI2YiNikUJsAlYqmuLAQjurFKkkjXZXKIggCmmsLETS2FmoVUA5EMQjCxZipXgmrvtNdo7n3Jvdmd3Z3ag/GObt3P6Z75s3f7hg19SNWPzHtNK6Ekabd9Jo51KpAe3pm2nEU9YgHwY7G+BzVPMMysPleVO/va8BP7fuphFP8r002hlMGACnXEcGzwRBIONLrzdkDfYc6Ihvn6P0apuHx2dlXaURLhq8ZABGnQrnuH2sk0ZC3HoT1WKEDaUXQYiPYt5DZIAqFJgBw1DypkzVlMoAdL73KTamuQumTCgyJbPQ3+d1G4RwlDjJCJeShU/xQH9frgFwjEMffSrcFTzT1FRwngK0ozCgH26v/pxwtTNkgecuJ4ui4vGJlTRyo+hUcTIA4pVQKo5rA5tLq7L+dfSQrCmttx9lffX8KXGms1vGZzv75A5R1ARbqFmFDRgOhyIMQ3mthK9fWxaHZ4/ImBPNsXgwHG+RL6KvYi36XrkBFOdFEMJRFBAP4aOnr0R3/pwUTsW3L5wcFwrX1gSl1oD1pMwlBamuj/jg2XMh7i/JuJuYwzFIDVghhyib0fe5NWYakPUhGJFlgAmI5gxBNjy6vlfGV/qLsq4D5wxQKAOAqwkmYMLWy/3iyeqP2kyQa8Bo0JcXHNxvD3r3ZEchHAW833g3XtkpmApo139T7RwXF2bkN8piOsNQJjIAgtvd3rjWQcfQQZ2p01/+2AUATJlL1wEO/f7p5QVpLOCywOfcV1hNAWWGSbwCJugoQRz6/fTeuqZBi6a4KeYygQMC9JKF6V4b8TbpbYPTIpiXAWWBcFDnLjBxEKIjD+g1OqY66RO8U416HeJp9owzAEJtU52u0HpGQIhLlijhTRHEH2ZiTjhnCNemb1cQ4zJVGjfAtA3qMcUmW2xMaFo8mDgIUWHUCAra9Tb9GsIgEIUjS7yvFd4Gp13AFj1D9GkCmh55RWkDip7OqjjVFXlnJRnwN+H8h8i/hRC/AbW/7q3mEu96AAAAAElFTkSuQmCC""")

def main():
    rep = http.get(COINDESK_PRICE_URL, ttl_seconds = 240)
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