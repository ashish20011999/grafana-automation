import requests
import json

# Script for migrating Grafana dashboards from one environment to another

# Source and destination environment details
SOURCE_URL = "http://source-grafana.example.com"
SOURCE_API_KEY = "source_api_key"
DEST_URL = "http://destination-grafana.example.com"
DEST_API_KEY = "destination_api_key"

# Get all dashboards from the source environment
source_dashboards = requests.get(f"{SOURCE_URL}/api/search?type=dash-db", headers={"Authorization": f"Bearer {SOURCE_API_KEY}"})
source_dashboards = source_dashboards.json()
print("Retrieved dashboards from the source environment.")

# Iterate through each dashboard and migrate it to the destination environments
for dashboard in source_dashboards:
    dashboard_name = dashboard["title"]
    dashboard_uid = dashboard["uid"]

    # Export the dashboard from the source environments
    exported_dashboard = requests.get(f"{SOURCE_URL}/api/dashboards/uid/{dashboard_uid}", headers={"Authorization": f"Bearer {SOURCE_API_KEY}"})
    exported_dashboard = exported_dashboard.json()["dashboard"]
    print(f"Exported dashboard '{dashboard_name}' from the source environment.")

    # Modify the exported dashboard if needed (e.g., replace data source)
    # Modify the exported_dashboard variable as required

    # Import the modified dashboard to the destination environment
    headers = {"Authorization": f"Bearer {DEST_API_KEY}", "Content-Type": "application/json"}
    payload = json.dumps({"dashboard": exported_dashboard, "overwrite": True})
    response = requests.post(f"{DEST_URL}/api/dashboards/db", headers=headers, data=payload)
    print(f"Imported dashboard '{dashboard_name}' to the destination environment.")

print("All dashboards have been migrated.")
