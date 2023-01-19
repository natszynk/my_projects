import pandas as pd
import numpy as np

def clean_cuisine_column(df:pd.DataFrame,column_name:str):

	""" The function converts the data type of columns containing types 
	of cuisine served in a restaurant. It takes a data frame as an argument 
	and converts the column values: from a string to a list of strings."""

	for x in df.index:
		if pd.notnull(df.loc[x, column_name]):
			df.at[x, "cuisines"] = [y.strip() for y in str(df.loc[x, column_name]).split(",")]
   
