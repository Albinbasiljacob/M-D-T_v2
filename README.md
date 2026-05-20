# M-D-T_v2
🛠️ How to Use


    Install Dependencies:

    bash

 Copy

sudo apt update
sudo apt install curl jq


Get Google Geolocation API Key:

    Go to Google Cloud Console.
    Enable the Geolocation API.
    Create an API Key.


Find Cell Tower Info (MCC, MNC, LAC, CID): You can get this from:

    Your phone’s Field Test Mode (e.g., dial *#0011# on Android).
    Using a network scanner app like Cellular-Z.
    From your carrier if you have legal authority.


Run the Script:

bash

     Copy

    chmod +x M-D-T_v2.sh
    ./M-D-T_v2.sh YOUR_GOOGLE_API_KEY 310 410 12345 67890 gsm



📊 How It Works


    MCC (Mobile Country Code): Identifies the country (e.g., 310 = USA).

    MNC (Mobile Network Code): Identifies the carrier (e.g., 410 = T-Mobile).

    LAC (Location Area Code): Identifies a group of cell towers.

    CID (Cell ID): Unique identifier for a specific cell tower.

    The script sends this data to Google’s Geolocation API, which returns the approximate latitude and longitude based on its global cell tower database.


⚠️ Limitations & Accuracy


    Accuracy: Typically ±50–200 meters in urban areas. Less accurate in rural areas.

    Requires Internet: The device doesn’t need GPS, but the API must be accessible.

    Legal Use Only: Ensure you have permission to trace the device (e.g., for your own phone or via carrier).


Let me know if you want a version that uses Wi-Fi BSSID tracing instead! 📡
