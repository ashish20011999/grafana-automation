#!/bin/bash

# Script for migrating Grafana dashboards from one environment to another

# Source and destination environment details
SOURCE_URL="http://source-grafana.example.com"
SOURCE_API_KEY="source_api_key"
DEST_URL="http://destination-grafana.example.com"
DEST_API_KEY="destination_api_key"

# Get all dashboards from the source environment
SOURCE_DASHBOARDS=$(curl -sS -H "Authorization: Bearer $SOURCE_API_KEY" $SOURCE_URL/api/search\?type\=dash-db)
echo "Retrieved dashboards from the source environment."

# Iterate through each dashboard and migrate it to the destination environment
for DASHBOARD in $(echo "$SOURCE_DASHBOARDS" | jq -r '.[] | @base64'); do
    DASHBOARD_NAME=$(echo "$DASHBOARD" | base64 --decode | jq -r '.title')
    DASHBOARD_UID=$(echo "$DASHBOARD" | base64 --decode | jq -r '.uid')

    # Export the dashboard from the source environment
    EXPORTED_DASHBOARD=$(curl -sS -H "Authorization: Bearer $SOURCE_API_KEY" $SOURCE_URL/api/dashboards/uid/$DASHBOARD_UID | jq -c '.dashboard')
    echo "Exported dashboard '$DASHBOARD_NAME' from the source environment."

    # Modify the exported dashboard if needed (e.g., replace data source)
    # Modify the EXPORTED_DASHBOARD variable as required

    # Import the modified dashboard to the destination environment
    curl -sS -H "Authorization: Bearer $DEST_API_KEY" -H "Content-Type: application/json" -X POST -d "{\"dashboard\": $EXPORTED_DASHBOARD, \"overwrite\": true}" $DEST_URL/api/dashboards/db
    echo "Imported dashboard '$DASHBOARD_NAME' to the destination environment."
done

echo "All dashboards have been migrated."
