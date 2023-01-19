import pandas as pd
from .data_filters import filter_data
from .map_generator import generate_map
from .data_processors import generate_user_location, normalize_data, calculate_distance_and_walk_time, calculate_euclidian_distance

def run_application(preferences:dict, df:pd.DataFrame):
    
    user_location = generate_user_location(df)
    filtered_data = filter_data(preferences,df)
    calculate_distance_and_walk_time(filtered_data,user_location)
    normalized_data = normalize_data(filtered_data,['rate','cost','distance', 'votes'])
    calculate_euclidian_distance(normalized_data)
    top_restaurants = normalized_data.sort_values(by="euclidian_dist",ascending=True)[:10]
    top_restaurants.reset_index(drop=True,inplace=True)
    generate_map(top_restaurants,user_location)

    
