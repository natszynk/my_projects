def clean_name_column(df):

    """The function takes dataframe as an argument and removes non ASCII symbols from  
    name column."""

    def remove_non_ascii(text):
        return "".join(i for i in text if any([ord(i)<128, ord(i) in [146,176]]))

    for x in df.index:
        df.at[x, "name"] = remove_non_ascii(df.loc[x, "name"])

    