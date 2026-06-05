#!/usr/bin/env python3
"""
Step 2: Fetch real road-following polylines for every consecutive station pair
        using OSRM (free, no API key, uses OpenStreetMap road data).

Requires: assets/data/stations.json  (run 1_geocode_stations.py first)
Output:   assets/data/route_segments.json
  { "StationA|StationB": [[lat, lng], ...], ... }
  Keys are always alphabetically sorted so lookup works both ways.

Run:
  python scripts/2_fetch_road_segments.py

Resumable: already-fetched segments are skipped on re-run.
Rate limit: ~1 req/sec (OSRM public server) — ~522 pairs ≈ 10 minutes.
"""

import json, time, urllib.request, os

ROOT          = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BUS_JSON      = os.path.join(ROOT, "lib", "datas", "good-json-data", "bus-data.json")
STATIONS_JSON = os.path.join(ROOT, "assets", "data", "stations.json")
OUT_JSON      = os.path.join(ROOT, "assets", "data", "route_segments.json")
DELAY_S       = 1.1
MAX_RETRIES   = 2

OSRM_URL = "https://router.project-osrm.org/route/v1/driving/{lng1},{lat1};{lng2},{lat2}?overview=full&geometries=geojson"


def segment_key(a, b):
    return "|".join(sorted([a, b]))


def all_pairs(bus_json_path, known_stations):
    data = json.load(open(bus_json_path, encoding="utf-8"))
    seen = set()
    pairs = []
    for bus in data["data"]:
        stops = [s.strip() for s in bus.get("routes", [])]
        for i in range(len(stops) - 1):
            a, b = stops[i], stops[i + 1]
            if a not in known_stations or b not in known_stations:
                continue
            key = segment_key(a, b)
            if key not in seen:
                seen.add(key)
                pairs.append((a, b))
    return pairs


def fetch_segment(lat1, lng1, lat2, lng2):
    url = OSRM_URL.format(lat1=lat1, lng1=lng1, lat2=lat2, lng2=lng2)
    req = urllib.request.Request(
        url,
        headers={"User-Agent": "DhakaLocalBus/1.0 (github.com/sakibahmed/DhakaLocalBus)"},
    )
    for attempt in range(MAX_RETRIES + 1):
        try:
            with urllib.request.urlopen(req, timeout=10) as resp:
                data = json.loads(resp.read())
            if data.get("code") != "Ok" or not data.get("routes"):
                return None
            # GeoJSON coords are [lng, lat] — swap to [lat, lng]
            coords = data["routes"][0]["geometry"]["coordinates"]
            return [[round(lat, 7), round(lng, 7)] for lng, lat in coords]
        except Exception as e:
            if attempt < MAX_RETRIES:
                time.sleep(2)
            else:
                raise e


def main():
    if not os.path.exists(STATIONS_JSON):
        print("ERROR: stations.json not found. Run 1_geocode_stations.py first.")
        return

    stations = json.load(open(STATIONS_JSON, encoding="utf-8"))
    pairs = all_pairs(BUS_JSON, stations)
    print(f"Total unique segment pairs: {len(pairs)}")

    # Load existing progress
    results = {}
    if os.path.exists(OUT_JSON):
        results = json.load(open(OUT_JSON, encoding="utf-8"))
        print(f"Resuming — {len(results)} already fetched.")

    todo = [(a, b) for a, b in pairs if segment_key(a, b) not in results]
    print(f"Fetching {len(todo)} remaining  (~{len(todo)*DELAY_S/60:.1f} min)...\n")

    failed = []
    for i, (a, b) in enumerate(todo, 1):
        key = segment_key(a, b)
        ca, cb = stations[a], stations[b]
        try:
            points = fetch_segment(ca["lat"], ca["lng"], cb["lat"], cb["lng"])
            if points:
                results[key] = points
                print(f"  [{i}/{len(todo)}] ✓  {a} → {b}  ({len(points)} pts)")
            else:
                failed.append(key)
                print(f"  [{i}/{len(todo)}] ✗  {a} → {b}  (no route)")
        except Exception as e:
            failed.append(key)
            print(f"  [{i}/{len(todo)}] ✗  {a} → {b}  ERROR: {e}")

        # Save after every segment so progress is never lost
        os.makedirs(os.path.dirname(OUT_JSON), exist_ok=True)
        with open(OUT_JSON, "w", encoding="utf-8") as f:
            json.dump(results, f)

        time.sleep(DELAY_S)

    print(f"\nDone. {len(results)} segments fetched, {len(failed)} failed.")
    if failed:
        print("Failed segments:")
        for s in failed:
            print(f"  - {s}")
    print(f"\nOutput: {OUT_JSON}")


if __name__ == "__main__":
    main()
