#!/usr/bin/env python3
"""
Step 1: Geocode all unique bus stations using OpenStreetMap Nominatim (free, no API key).

Output: assets/data/stations.json
  { "Station Name": { "lat": 23.xxx, "lng": 90.xxx }, ... }

Run:
  python scripts/1_geocode_stations.py

Resumable: already-geocoded stations are skipped on re-run.
Rate limit: 1 req/sec (Nominatim policy) — ~301 stations ≈ 6 minutes.
"""

import json, time, urllib.request, urllib.parse, os

ROOT          = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BUS_JSON      = os.path.join(ROOT, "lib", "datas", "good-json-data", "bus-data.json")
OUT_JSON      = os.path.join(ROOT, "assets", "data", "stations.json")
DELAY_S       = 1.5   # Nominatim requires ≥1s between requests; 1.5s to be safe

NOMINATIM_URL = "https://nominatim.openstreetmap.org/search"
HEADERS       = {"User-Agent": "DhakaLocalBus/1.0 (github.com/sakibahmed/DhakaLocalBus)"}


def all_stations(bus_json_path):
    data = json.load(open(bus_json_path, encoding="utf-8"))
    stations = set()
    for bus in data["data"]:
        for stop in bus.get("routes", []):
            stations.add(stop.strip())
    return sorted(stations)


def _search(query):
    """Single Nominatim call. Returns (lat, lng) or None. Raises on 429."""
    params = urllib.parse.urlencode({
        "q":              query,
        "format":         "jsonv2",
        "limit":          1,
        "countrycodes":   "bd",
        "addressdetails": 0,
    })
    req = urllib.request.Request(f"{NOMINATIM_URL}?{params}", headers=HEADERS)
    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            results = json.loads(resp.read())
        if results:
            r = results[0]
            return {"lat": round(float(r["lat"]), 7), "lng": round(float(r["lon"]), 7)}
        return None
    except urllib.error.HTTPError as e:
        if e.code == 429:
            raise   # caller will back off and retry
        return None


def geocode(name):
    """Try progressively broader queries until something matches."""
    queries = [
        f"{name}, Dhaka, Bangladesh",
        f"{name}, Dhaka",
        f"{name}, Bangladesh",
    ]
    for q in queries:
        for attempt in range(3):
            try:
                result = _search(q)
                time.sleep(DELAY_S)
                if result:
                    return result
                break          # no result for this query — try next
            except urllib.error.HTTPError:
                wait = 10 * (attempt + 1)
                print(f"      429 — waiting {wait}s...")
                time.sleep(wait)
    return None


def main():
    stations = all_stations(BUS_JSON)
    print(f"Found {len(stations)} unique stations.")

    # Load existing progress
    results = {}
    if os.path.exists(OUT_JSON):
        results = json.load(open(OUT_JSON, encoding="utf-8"))
        print(f"Resuming — {len(results)} already done.")

    todo = [s for s in stations if s not in results]
    print(f"Fetching {len(todo)} remaining  (~{len(todo)*DELAY_S/60:.1f} min)...\n")

    failed = []
    for i, name in enumerate(todo, 1):
        try:
            coords = geocode(name)
            if coords:
                results[name] = coords
                print(f"  [{i}/{len(todo)}] ✓  {name}  →  {coords['lat']}, {coords['lng']}")
            else:
                failed.append(name)
                print(f"  [{i}/{len(todo)}] ✗  {name}  (no result — fix manually)")
        except Exception as e:
            failed.append(name)
            print(f"  [{i}/{len(todo)}] ✗  {name}  ERROR: {e}")

        # Save after every station so progress is never lost
        os.makedirs(os.path.dirname(OUT_JSON), exist_ok=True)
        with open(OUT_JSON, "w", encoding="utf-8") as f:
            json.dump(results, f, ensure_ascii=False, indent=2)

    print(f"\nDone. {len(results)} geocoded, {len(failed)} failed.")
    if failed:
        print("\nFailed stations (add coordinates manually in stations.json):")
        for s in failed:
            print(f'  "{s}": {{ "lat": 0.0, "lng": 0.0 }}')
    print(f"\nOutput: {OUT_JSON}")


if __name__ == "__main__":
    main()
