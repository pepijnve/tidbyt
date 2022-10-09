load("render.star", "render")
load("re.star", "re")
load("http.star", "http")
load("time.star", "time")

def sort_key(tuple):
    return tuple[0]

def sort_data(data):
    return sorted(data, key=sort_key)

def main(config):
    ha_address = config.get("ha_address")
    if (ha_address == None):
        fail("Home Assistant server address not specified")

    ha_port = config.get("ha_port")
    if (ha_port == None):
        ha_port = 8123
    else:
        ha_port = int(ha_port)

    ha_token = config.get("ha_token")
    if (ha_token == None):
        fail("Home Assistant API token not specified")

    period = config.get("period")
    if (period == None):
        period = "24h"

    entity = config.get("ha_entity")
    if (entity == None):
        fail("Home Assistant entity id not specified")

    now = time.now()
    start_time = (now - time.parse_duration(period))
    expand_day = False

    history_result = http.get(
        "http://%s:%d/api/history/period/%s" % (ha_address, ha_port, start_time.format("2006-01-02T15:04:05Z07:00")),
        params = {
            "filter_entity_id": entity
        },
        headers = {
            "Authorization": "Bearer %s" % ha_token,
            "Content-Type": "application/json"
        }
    )

    if history_result.status_code != 200:
        fail("Data retrieval failed with status code %d" % history_result.status_code)

    history = history_result.json()

    states = history[0]
    title = states[0]["attributes"]["friendly_name"]
    unit = states[0]["attributes"]["unit_of_measurement"]

    data = []
    for state in states:
        values = re.findall("-?[0-9]+\\.[0-9]+", state["state"])
        if (len(values) == 0):
            continue

        value = float(values[0])
        update_time = time.parse_time(state["last_updated"], "2006-01-02T15:04:05Z07:00")

        key = (update_time - start_time).seconds
        if (key < 0):
            continue

        entry = (key, value)
        data.append(entry)

    data = sort_data(data)

    if expand_day:
        if len(data) == 0 or data[0][0] > 0.0:
            data.insert(0, (0.0, 0.0))

        if len(data) == 0 or data[-1][0] < 86400.0:
            data.append((86400.0, 0.0))

    last_value = data[-1][1]
    sign = "-" if last_value < 0 else ""
    units = int(abs(last_value))
    tenths = int(abs(last_value * 10) % 10)
    hundredths = int(abs(last_value * 100) % 10)

    return render.Root(
        child = render.Stack(
            children = [
                render.Plot(
                    height = 32,
                    width = 64,
                    fill = True,
                    color = "#0f0",
                    color_inverted = "#f00",
                    data = data
                ),
                render.Row(
                    main_align = "end",
                    expanded = True,
                    children = [
                        render.Padding(
                            pad = (1, 0, 0, 1),
                            child = render.Text(
                                content = "%s%d.%d%d%s" % (sign, units, tenths, hundredths, unit)
                            )
                        )
                    ]
                )
            ]
        )
    )