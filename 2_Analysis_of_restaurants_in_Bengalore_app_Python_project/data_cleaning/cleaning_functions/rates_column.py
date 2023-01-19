import pandas as pd
import numpy as np

def clean_rates(df):

    """ The function takes data frame as an argument and converts the data format
    and type in column contaning rate of each restaurant: from 'rate/5' format to float(rate).
    Additionally it replaces "-" and "NEW strings with Nan values. """

    df["rate"].replace(["NEW","-"],[np.nan,np.nan],inplace=True)

    for x in df.index:
        if df.loc[x, "rate"] is not np.NAN:
            df.loc[x, "rate"] = str(df.loc[x, "rate"]).split("/")[0].strip()

    df["rate"].astype(float)
    