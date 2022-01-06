load("render.star", "render")
load("http.star", "http")
load("time.star", "time")

def sort_key(tuple):
    return tuple[0]

def sort_data(data):
    return sorted(data, key=sort_key)

def main(config):
    date = time.now().format("2.1.2006")
    channel = "PowerReal_PAC_Sum"
    expand_day = False

    archive_result = http.get(
        "http://%s/solar_api/v1/GetArchiveData.cgi" % config.get("datamanager_address"),
        params = {
            "Scope": "System",
            "StartDate": date,
            "EndDate": date,
            "Channel": channel
        }
    )
    if archive_result.status_code != 200:
        fail("Data retrieval failed with status code %d" % archive_result.status_code)

    archive = archive_result.json()
    devices = archive["Body"]["Data"]
    channel = devices[devices.keys()[0]]["Data"][channel]
    unit = devices[devices.keys()[0]]["Data"][channel]["Unit"]
    values = devices[devices.keys()[0]]["Data"][channel]["Values"]
    data = []
    for t in values:
        value = values[t]
        entry = (float(t), value)
        data.append(entry)

    data = sort_data(data)

    if expand_day:
        if len(data) == 0 or data[0][0] > 0.0:
            data.insert(0, (0.0, 0.0))

        if len(data) == 0 or data[-1][0] < 86400.0:
            data.append((86400.0, 0.0))

    return render.Root(
        child = render.Stack(
            children = [
                render.Plot(
                    height = 32,
                    width = 64,
                    fill = True,
                    color = "#f8cc33",
                    data = data
                ),
                render.Padding(
                    pad = (1, 0, 0, 0),
                    child = render.Text(
                        content = "%d%s" % (data[-1][1], unit)
                    )
                )
            ]
        )
    )

