import pandas as pd
import numpy as np

def clean_table(df:pd.DataFrame):

    """ The function removes selected columns and rows 
    which won't be used in a further analysis. It also gets rid of duplicates"""

    df.drop(['menu_item','dish_liked', 'reviews_list', 'listed_in(type)','listed_in(city)'], axis=1, inplace = True)

    df.dropna(subset=['cuisines','location'], inplace=True)

    df.drop_duplicates(subset=["name","address","rest_type"], inplace = True)
