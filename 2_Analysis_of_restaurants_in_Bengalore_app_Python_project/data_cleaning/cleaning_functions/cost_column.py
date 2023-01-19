import pandas as pd

def clean_cost_column(df:pd.DataFrame):

	"""The function takes dataframe as an argument, renames the column and removes comma from 
	the column values containing approximate cost of a meal for two people to convert these 
	values into float type. """

	df.rename(columns={"approx_cost(for two people)": "cost"}, inplace=True)
	for x in df.index:
		df.loc[x, "cost"] = float(str(df.loc[x, "cost"]).replace(",",""))

	return df
