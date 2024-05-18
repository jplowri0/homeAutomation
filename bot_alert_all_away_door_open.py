import pandas as pd
import requests
from config import url_import, auth_key_import

# Check the state in the switch_bot_alert_all_away_doors_state.csv file
def check_switch_bot_state():
    try:
        switch_bot_df = pd.read_csv('switch_bot_alert_all_away_doors_state.csv')
        # Assuming the state column is the last column in the DataFrame
        if switch_bot_df.iloc[-1]['state'] == 1:
            execute_alert_script()
    except Exception as e:
        print(f"An error occurred while checking the switch bot state: {e}")

# Function to execute the alert script
def execute_alert_script():
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
                    "content": "Hey guys ... There is a door Open"
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

# Run the check
check_switch_bot_state()

