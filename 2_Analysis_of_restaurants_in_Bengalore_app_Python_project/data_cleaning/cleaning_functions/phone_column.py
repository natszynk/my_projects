import pandas as pd

def clean_phone_column(df:pd.DataFrame):

    """The function takes data frame as an argument and removes '\r\n', '\r' and '\n' symbols 
    from the column containing one or two phone numbers to give string of the '[phone1], [phone2]' type. 
    It also repalaces NaN values with information that the given restaurant has no available phone number."""
    
    df["phone"].replace([r"\r\n", r"\n", r"\r"],[", ",", ", ", "], regex=True, inplace = True)
    df["phone"].fillna("No number", inplace=True)
    
    return df
