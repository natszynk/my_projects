from geopy.geocoders import Nominatim 
import random
import numpy as np
import pandas as pd

def coordinates_generator(df:pd.DataFrame):

    """The function generates coordinates (stored in two separate columns: latitude and longitude)
    for each restaurant. It takes dataframe as an argument and uses 'geopy' library to obtain the 
    coordinates for the district in which the restaurant is located. For the purpose of creating 
    diversified locations, the coordinates were varied within the district by using the 'random' 
    module."""

    list_districts = list(df["location"].unique()) 

    locator = Nominatim(user_agent='myGeocoder')
    coordinates = {}
    for n in list_districts:
        location = locator.geocode(str(n) + ', Bangalore, India')
        if location is not None:
            coordinates[n]=location.latitude, location.longitude
        else:
            # print(n)
            continue
    
    # Location of the following districts was added manually:
    coordinates["St. Marks Road"] = 12.972310736424824, 77.60116446706141
    coordinates["Rammurthy Nagar"]= 13.016813200078566, 77.6778544108712
    coordinates["Sadashiv Nagar"]= 13.007486725914928, 77.58119028665898

    df[['latitude', 'longitude']] = np.nan

    for x in df.index:
        z = round(random.uniform(-0.005,0.005),6)
        y = round(random.uniform(-0.005,0.005),6)
        district = df.loc[x, "location"]
        if district is not np.nan:
            df.at[x, "latitude"] = coordinates[district][0] + z
            df.at[x, "longitude"] = coordinates[district][1] + y
    