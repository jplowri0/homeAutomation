import pandas as pd
import requests
from config import url_import, auth_key_import

# Define the list of CSV files to be processed
csv_files = [
    'log_back_door_right_state.csv',
	'log_back_garage_door_state.csv',
	'log_front_door.csv',
	'log_main_garage_door.csv',
	'log_motion_front_door.csv',
	'log_motion_inside_garage.csv',
    'log_side_door_state.csv'

    # Add more file paths as needed
]

# Loop through each CSV file
for csv_file in csv_files:
    try:
        # Read the CSV file into a DataFrame
        df = pd.read_csv(csv_file)
        
        # Check if the last record's 'State' column has a value of 0
        if df.iloc[-1]['State'] == 0:
            # Prepare the payload and headers for the POST request
            payload = {
                "content": "Front Door is Open"
            }
            headers = {
                "Authorization": auth_key_import
            }
            
            # Execute the POST request
            res = requests.post(url_import, json=payload, headers=headers)
            
            # Check the response status
            if res.status_code == 200:
                print(f"Notification sent successfully for {csv_file}")
            else:
                print(f"Failed to send notification for {csv_file}, status code: {res.status_code}")
    except Exception as e:
        print(f"An error occurred while processing {csv_file}: {e}")

