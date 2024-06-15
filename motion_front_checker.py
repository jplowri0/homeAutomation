import pandas as pd
from datetime import datetime, timedelta
import subprocess

# Function to check the time difference
def check_time_difference(time1, time2, threshold_minutes=5):
    diff = abs((time1 - time2).total_seconds())
    return diff > threshold_minutes * 60

# Load CSV files into pandas DataFrames
df_front_door_open = pd.read_csv('log_front_door.csv')
df_motion_front_door = pd.read_csv('log_motion_front_door.csv')

# Assuming 'Date' and 'Time' are separate columns, combine into a datetime column
df_front_door_open['DateTime'] = pd.to_datetime(df_front_door_open['Date'] + ' ' + df_front_door_open['Time'])
df_motion_front_door['DateTime'] = pd.to_datetime(df_motion_front_door['Date'] + ' ' + df_motion_front_door['Time'])

# Get the last records from each DataFrame
last_record_front_door_open = df_front_door_open.iloc[-1]['DateTime']
last_record_motion_front_door = df_motion_front_door.iloc[-1]['DateTime']

# Check if the time difference is more than 5 minutes
if check_time_difference(last_record_front_door_open, last_record_motion_front_door):
    # Execute the shell script
    subprocess.run(['./front_door_motion_sensor_failure.sh'])
else:
    print("No action taken as time difference is within threshold.")


