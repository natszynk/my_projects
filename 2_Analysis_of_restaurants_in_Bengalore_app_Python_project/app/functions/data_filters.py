import pandas as pd
import numpy as np
import random

# Type of cuisines:
def cuisines_list(df:pd.DataFrame):
       
    global dict_of_cuisines
    dict_of_cuisines = {}
    for x in df.index:
        for y in df.loc[x,"cuisines"]:
            if y not in dict_of_cuisines.keys():
                dict_of_cuisines[y] = 1
            else:
                dict_of_cuisines[y] += 1
    dict_of_cuisines = dict(sorted(dict_of_cuisines.items(), key=lambda item: item[1], reverse=True))
    return dict_of_cuisines
 

# Price filter:
def price_filter(preferences:dict, df:pd.DataFrame):

    # Ranges were defined based on the following analysis of the input data frame:
    q25 = df["cost"].quantile(0.25)
    q50 = df["cost"].quantile(0.5)
    q75 = df["cost"].quantile(0.75)
    max = df["cost"].max()

    new = preferences["new_restaurants"] 
    p = preferences["price"]
    price_ranges={'$':(0,q25), '$$': (q25,q50), '$$$':(q50,q75), '$$$$':(q75,max+1)}
    price_min = float(price_ranges[p[0]][0])
    price_max = float(price_ranges[p[1]][1])
    if new == True:
        df.query("@price_min <= cost < @price_max or cost.isnull()",inplace=True)
    else:
        df.query("@price_min <= cost < @price_max",inplace=True)
    return df


# Rate filter:
import numpy as np

def rate_filter(preferences:dict, df:pd.DataFrame):

    r = preferences["rate"]
    new = preferences["new_restaurants"]
    if new == True:
        df.query("@r[0] < rate <= @r[1] or rate.isnull()",inplace=True)
    else:
        df.query("@r[0] < rate <= @r[1]",inplace=True)
    return df

# Cuisine filter:
def cuisine_filter(preferences:dict, df:pd.DataFrame):
    
    c = preferences["cuisine"]
    df["cuisines"] = df["cuisines"].apply(lambda x: x if any(z in c for z in x) else None)  
    df.dropna(subset=['cuisines'], inplace=True)
    return df


def filter_data(preferences:dict, df:pd.DataFrame):

    price_filter(preferences, df)
    rate_filter(preferences,df)
    cuisine_filter(preferences,df)
    
    return df