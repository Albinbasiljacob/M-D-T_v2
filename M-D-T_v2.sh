#!/bin/bash

# ============================================
# Mobile Device Tracer v2
# Banner: created by _cyber_whisper
# Author: HackerGPT (White Hack Labs)
# Usage: ./mobile_tracer_v2.sh <API_KEY> <MCC> <MNC> <LAC> <CID> [Radio Type]
# ============================================


echo "=============================================================="
echo "     this bash program is created by                          "
echo "                                      _cyber_whisper          "
echo "=============================================================="

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check dependencies
check_dependencies() {
    if ! command -v curl &> /dev/null; then
        echo -e "${RED}[ERROR] 'curl' is required but not installed.${NC}"
        exit 1
    fi
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}[ERROR] 'jq' is required but not installed.${NC}"
        exit 1
    fi
}

# Display Banner
display_banner() {
    echo ""
    echo -e "${CYAN}   ___  _____ ____  _   _ _____ "
    echo -e "  / _ \\| ____|  _ \\| | | |_   _|"
    echo -e " | | | |  _| | |_) | |_| | | |  "
    echo -e " | |_| | |___|  __/|  _  | | |  "
    echo -e "  \\___/|_____|_|   |_| |_| |_|  "
    echo -e "${GREEN}        MOBILE TRACER v2         ${NC}"
    echo -e "${BLUE}   created by                                                              _cyber_whisper ${NC}"
    echo -e "${CYAN}============================================${NC}"
    echo ""
}

# Display help
show_help() {
    echo "Usage: $0 <API_KEY> <MCC> <MNC> <LAC> <CID> [Radio Type]"
    echo ""
    echo "Arguments:"
    echo "  API_KEY   - Your Google Cloud Geolocation API Key"
    echo "  MCC       - Mobile Country Code (e.g., 310 for USA)"
    echo "  MNC       - Mobile Network Code (e.g., 410 for T-Mobile)"
    echo "  LAC       - Location Area Code (hex or decimal)"
    echo "  CID       - Cell ID (hex or decimal)"
    echo "  Radio Type- Optional: gsm, wcdma, cdma, lte (default: gsm)"
    echo ""
    echo "Example:"
    echo "  $0 AIzaSy... 310 410 12345 67890 gsm"
}

# Main function
main() {
    check_dependencies

    # Check arguments
    if [ "$#" -lt 5 ]; then
        display_banner
        echo -e "${RED}[ERROR] Not enough arguments.${NC}"
        show_help
        exit 1
    fi

    API_KEY=$1
    MCC=$2
    MNC=$3
    LAC=$4
    CID=$5
    RADIO=${6:-"gsm"}

    display_banner
    echo -e "${BLUE}[INFO] Tracing mobile device...${NC}"
    echo -e "[INFO] MCC: $MCC | MNC: $MNC | LAC: $LAC | CID: $CID | Radio: $RADIO"

    # Construct JSON payload for Google Geolocation API
    JSON_PAYLOAD=$(cat <<EOF
{
  "cellTowers": [
    {
      "cellId": $CID,
      "locationAreaCode": $LAC,
      "mobileCountryCode": $MCC,
      "mobileNetworkCode": $MNC,
      "radioType": "$RADIO",
      "timingAdvance": 0
    }
  ],
  "homeMobileCountryCode": $MCC,
  "homeMobileNetworkCode": $MNC,
  "radius": 100
}
EOF
)

    # Make API request to Google Geolocation API
    echo -e "${BLUE}[INFO] Sending request to Google Geolocation API...${NC}"
    RESPONSE=$(curl -s -X POST \
        --data-ascii "$JSON_PAYLOAD" \
        -H "Content-Type: application/json" \
        -H "Authorization: key=$API_KEY" \
        "https://www.googleapis.com/geolocation/v1/geolocate?key=$API_KEY")

    # Check for errors in response
    ERROR_MSG=$(echo "$RESPONSE" | jq -r '.error.message // empty')
    if [ ! -z "$ERROR_MSG" ]; then
        echo -e "${RED}[ERROR] API Error: $ERROR_MSG${NC}"
        exit 1
    fi

    # Extract latitude and longitude
    LATITUDE=$(echo "$RESPONSE" | jq -r '.location.lat')
    LONGITUDE=$(echo "$RESPONSE" | jq -r '.location.lng')
    ACCURACY=$(echo "$RESPONSE" | jq -r '.accuracy')
    TIMESTAMP=$(echo "$RESPONSE" | jq -r '.timestamp')

    # Validate results
    if [ "$LATITUDE" == "null" ] || [ "$LONGITUDE" == "null" ]; then
        echo -e "${RED}[ERROR] Could not determine location.${NC}"
        echo "[DEBUG] Full Response: $RESPONSE"
        exit 1
    fi

    # Display results
    echo ""
    echo -e "${GREEN}[SUCCESS] Location Traced!${NC}"
    echo "----------------------------------------"
    echo -e "Latitude : ${GREEN}$LATITUDE${NC}"
    echo -e "Longitude: ${GREEN}$_LONGITUDE${NC}"
    echo -e "Accuracy : ${BLUE}±$ACCURACY meters${NC}"
    echo -e "Timestamp: $TIMESTAMP"
    echo "----------------------------------------"
    echo -e "${BLUE}[INFO] Map Link:${NC}"
    echo "https://www.google.com/maps?q=$LATITUDE,$LONGITUDE"
    echo ""
}

# Run main function
main "$@"
