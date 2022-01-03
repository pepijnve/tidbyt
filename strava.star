load("render.star", "render")
load("encoding/base64.star", "base64")
load("encoding/json.star", "json")
load("http.star", "http")
load("cache.star", "cache")
load("time.star", "time")

ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAAXNSR0IArs4c6QAA
AKRlWElmTU0AKgAAAAgABQESAAMAAAABAAEAAAEaAAUAAAABAAAASgEbAAUAAAAB
AAAAUgExAAIAAAAgAAAAWodpAAQAAAABAAAAegAAAAAAAABIAAAAAQAAAEgAAAAB
QWRvYmUgUGhvdG9zaG9wIENTNiAoTWFjaW50b3NoKQAAA6ABAAMAAAABAAEAAKAC
AAQAAAABAAAAFqADAAQAAAABAAAAFgAAAAA/7+fnAAAACXBIWXMAAAsTAAALEwEA
mpwYAAAEdWlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxu
czp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNi4wLjAiPgog
ICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIv
MjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjph
Ym91dD0iIgogICAgICAgICAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUu
Y29tL3RpZmYvMS4wLyIKICAgICAgICAgICAgeG1sbnM6eG1wTU09Imh0dHA6Ly9u
cy5hZG9iZS5jb20veGFwLzEuMC9tbS8iCiAgICAgICAgICAgIHhtbG5zOnN0UmVm
PSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYj
IgogICAgICAgICAgICB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFw
LzEuMC8iPgogICAgICAgICA8dGlmZjpZUmVzb2x1dGlvbj43MjwvdGlmZjpZUmVz
b2x1dGlvbj4KICAgICAgICAgPHRpZmY6WFJlc29sdXRpb24+NzI8L3RpZmY6WFJl
c29sdXRpb24+CiAgICAgICAgIDx0aWZmOk9yaWVudGF0aW9uPjE8L3RpZmY6T3Jp
ZW50YXRpb24+CiAgICAgICAgIDx4bXBNTTpEZXJpdmVkRnJvbSByZGY6cGFyc2VU
eXBlPSJSZXNvdXJjZSI+CiAgICAgICAgICAgIDxzdFJlZjppbnN0YW5jZUlEPnht
cC5paWQ6OUJDRTMwODE5QTUwMTFFNDgzMURERkExREVDRDZFOTU8L3N0UmVmOmlu
c3RhbmNlSUQ+CiAgICAgICAgICAgIDxzdFJlZjpkb2N1bWVudElEPnhtcC5kaWQ6
OUJDRTMwODI5QTUwMTFFNDgzMURERkExREVDRDZFOTU8L3N0UmVmOmRvY3VtZW50
SUQ+CiAgICAgICAgIDwveG1wTU06RGVyaXZlZEZyb20+CiAgICAgICAgIDx4bXBN
TTpEb2N1bWVudElEPnhtcC5kaWQ6OUJDRTMwODQ5QTUwMTFFNDgzMURERkExREVD
RDZFOTU8L3htcE1NOkRvY3VtZW50SUQ+CiAgICAgICAgIDx4bXBNTTpJbnN0YW5j
ZUlEPnhtcC5paWQ6OUJDRTMwODM5QTUwMTFFNDgzMURERkExREVDRDZFOTU8L3ht
cE1NOkluc3RhbmNlSUQ+CiAgICAgICAgIDx4bXA6Q3JlYXRvclRvb2w+QWRvYmUg
UGhvdG9zaG9wIENTNiAoTWFjaW50b3NoKTwveG1wOkNyZWF0b3JUb29sPgogICAg
ICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4K
C1YpCAAAAzZJREFUOBGVlN9LVEEUx79z9+666VLGaiCRSeVD2J/ggz1WlIq5lUSp
gSilhBWVEk30UEmSFRX2EhZFrdJDRPVQ2VsQvSYiUkSpWaGV5v68ns7M7tWr6+I2
cO/MnHPP55z5zswFlmkECPsT59i2/XfvhFA1GqgKGxSEx55MYEbaj2SiUqrARrjQ
zbNq/e30/ArSxrIjPdiOcqEZXp4I7KdK+MVzRKgBbtudrl8STBKGkJilPVytwGFM
w4KJLfwc1KAhkFOqpeBLgjHKi1fNwilkMQ6YAZO4NVMNVos3iKMs+Y02p75SwFQG
U9xGjDermKutR0QH+ThJmLetCFEc0pYyXpHjxCxGp4CRn9RdoJ2VVP44vwVXbPJI
tVbe0FwlFZIbrK2LXgvAtA1ZohdRrraEUTVJkMmIDp4P6lgPCjhFkx5/YGuatgAM
X1JJ4CQHu3WYwJDo4znhnlY1qknHaAdr3QsrnRxzYKqFV1dbic0MrECMVVX1zOKy
RuWX9oHWjMHFZ8+AHyvQqO2X6n3UL9UGpzZ1vGwr36wXnIToAD9VGLDtqqcc1NA+
5TOJ9nrUkctb4Kd5aRKZkloxVInxhM/tawjDDTP3FTABeiBL4fMFEIp48PZlB4b7
R1l/F24cPUKF6/IQs77D6+0SouUPBYMuEQhYGmxrxf00V3AzUcUsdxOJoS9nBHGr
DsWFPqysPCO6+q8qBzWu/YmCPD++fnsotjNUSgMDA/rEz0nAcmqD2gwlDfcGBatd
6hG7TnyCEOfxm/OGQ2cpKH30+GIr/Kv8+DI+yUnP6QrWwyOkVBXNa6sd9kvqJCQC
vRZQkriFRqwHv6Y+Ii+Xz0v2dU7UBIvdAo/E7rZBTuYRdTJsI+Yqtg2qcvvRtoCM
6aDy9nFO14O/HGu6amGamzA5FYKwOu1YZ58CdjrV2JZI2+PxWwhHRvRlNnkhhLui
/PQwPbuWJQIyccKTgGXBGs5BdEd6RaDtB1+JbmRnsdbRCMi4oDnvJliThS0jsA4p
Sl5wT6gT02Hiau+LquOf6X23mzcs8RdxsDMGi60yrrXeKWf4OrawSFc05+lYSrUO
fuZDIrW3ieYc2za7/weGdiGEKu4hggAAAABJRU5ErkJggg==
""")

def get_strava_token(config):
    token = None

    strava_client_id = config.get("strava_client_id")
    strava_client_secret = config.get("strava_client_secret")
    strava_code = config.get("strava_code")
    strava_refresh = config.get("strava_refresh_token")

    token_data = cache.get("strava_token")

    if token_data != None:
        token = json.decode(token_data)
        if token["expires_at"] - 3600 < time.now().unix:
            print("Token expiring soon")
            strava_refresh = token["refresh_token"]
            token_data = None

    if token == None:
        if strava_client_id == None:
            fail("Please specify the Strava client ID using the `strava_client_id` parameter")

        if strava_code == None and strava_refresh == None:
            fail("Please navigate to the following URL in a browser: https://www.strava.com/oauth/authorize?client_id=%s&redirect_uri=http://localhost/exchange_token&response_type=code&scope=read,activity:read_all" % strava_client_id)

        if strava_client_secret == None:
            fail("Please specify the Strava client secret using the `strava_client_secret` parameter")

        if strava_refresh == None:
            auth_result = http.post(
                "https://www.strava.com/api/v3/oauth/token",
                form_body = {
                    "client_id": strava_client_id,
                    "client_secret": strava_client_secret,
                    "grant_type": "authorization_code",
                    "code": strava_code
                }
            )
        else:
            auth_result = http.post(
                "https://www.strava.com/api/v3/oauth/token",
                form_body = {
                    "client_id": strava_client_id,
                    "client_secret": strava_client_secret,
                    "grant_type": "refresh_token",
                    "refresh_token": strava_refresh
                }
            )

        if auth_result.status_code != 200:
            fail("Strava authentication failed with status code %d" % auth_result.status_code)

        token_data = auth_result.body()
        cache.set("strava_token", token_data, 31536000)
        token = json.decode(token_data)

    print("strava_refresh_token=%s" % token["refresh_token"])

    return token["access_token"]

def main(config):
    strava_token = get_strava_token(config)

    activities_result = http.get(
        "https://www.strava.com/api/v3/athlete/activities",
        headers = {
            "Authorization": "Bearer %s" % strava_token
        },
        params = {
            "per_page": "1"
        }
    )
    if activities_result.status_code != 200:
        fail("Strava activity retrieval failed with status code %d" % activities_result.status_code)

    activity_data = activities_result.json()
    activity = activity_data[0]

    name = activity["name"]
    elapsed_time_s = activity["elapsed_time"]
    kudos = activity["kudos_count"]

    return render.Root(
        child = render.Row(
            expanded = True,
            main_align = "start",
            cross_align = "center",
            children = [
                render.Image(src=ICON),
                render.Column(
                    expanded = True,
                    main_align = "space_evenly",
                    children=[
                        render.Text(name),
                        render.Text("%ds" % elapsed_time_s),
                        render.Text("%d kudos" % kudos),
                    ],
                ),
            ]
        )
    )

