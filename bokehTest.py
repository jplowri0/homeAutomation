from bokeh.io import curdoc
from bokeh.models import ColumnDataSource, Div
from bokeh.layouts import column
import pandas as pd

# Create a ColumnDataSource
source = ColumnDataSource(data=dict(timestamp=[], status=[]))

# Function to update the data
def update():
    # Load the CSV file
    df = pd.read_csv('log_front_door.csv')
    
    # Get the most recent row
    latest_row = df.iloc[-1]
    
    # Determine door status
    door_status = "Open" if latest_row['State'] == 1 else "Closed"
    
    # Update the ColumnDataSource
    source.data = dict(timestamp=[latest_row['Date']], status=[door_status])
    
    # Update the Div text
    status_div.text = f"<h1>Door is currently: {door_status}</h1>"

# Create a Div element to display the door status
status_div = Div(text="<h1>Loading...</h1>", width=200, height=100)

# Create a layout and add it to the current document
layout = column(status_div)
curdoc().add_root(layout)
curdoc().title = "Door Status Dashboard"

# Add periodic callback to update the data every 1000 milliseconds (1 second)
curdoc().add_periodic_callback(update, 1000)

# To run the server: Save this script as main.py and run `bokeh serve --show main.py`

