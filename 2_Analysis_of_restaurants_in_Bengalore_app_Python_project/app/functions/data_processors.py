import pandas as pd
import random
import numpy as np
from geopy import distance as geopy_distance
from scipy.spatial.distance import euclidean

def generate_user_location(df:pd.DataFrame):
    
        lat = random.uniform(df["latitude"].min(), df["latitude"].max())
        long = random.uniform(df["longitude"].min(), df["longitude"].max())
        global user_location
        user_location = lat, long
        return user_location


def normalize_data(df:pd.DataFrame, columns_list:list):
    
    for column_name in columns_list:
        
        new_column_name = "_".join([column_name, "norm"])
        df[new_column_name] = 0
        x_min = df[column_name].min()
        x_max = df[column_name].max()

        for x in df[column_name].index:
            df.at[x,new_column_name] = (df[column_name][x] - x_min)/(x_max-x_min)

        if new_column_name == 'rate':     
            df[new_column_name].fillna(0,inplace=True)
        else:
            df[new_column_name].fillna(1,inplace=True)

    return df



def calculate_euclidian_distance(df:pd.DataFrame):
    df["euclidian_dist"] = 0
    optimal_point = [df["rate_norm"].max(), df["cost_norm"].min(), df["votes_norm"].max(), df["distance_norm"].min()]
    for x in df.index:
        rest_point = [df["rate_norm"][x], df["cost_norm"][x], df["votes_norm"][x], df["distance_norm"][x]]
        df.at[x,"euclidian_dist"] = euclidean(optimal_point,rest_point,w=[1,1,0.5,2])
    
    return df


def calculate_distance_and_walk_time(df:pd.DataFrame,user_location):
    
    df["distance"] = 0
    df["walk_time"] = 0
    kilometers_per_hour = 4.8   #an average speed of walk
    for x in df.index:
        rest_location = (df["latitude"][x],df["longitude"][x])
        df.at[x,"distance"] = round(float(geopy_distance.distance(user_location,rest_location).kilometers),2)
        df.at[x,"walk_time"] = round(df.at[x,"distance"]/kilometers_per_hour*60,0)
        
    return df