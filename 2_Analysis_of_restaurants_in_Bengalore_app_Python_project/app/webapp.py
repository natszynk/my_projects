import pandas as pd
import streamlit as st
import numpy as np
from streamlit_folium import st_folium, folium_static 
# from functions.input_collectors import display_widgets, cuisines_list
from functions.application_runner import run_application
df = pd.read_csv("cleaned_zomato.csv")
df["cuisines"] = df["cuisines"].apply(eval)

# Title
st.header("Where to eat in Bengalure? Let us help you!")

# Cuisine type
cuisines = st.multiselect("Select cuisine type:", tuple(cuisines_list(df).keys()))

# Price range
price_min, price_max = st.select_slider('Select price range: ', options=['$','$$','$$$','$$$$'], value=('$', '$$$$'))

# Rate range
rate = st.slider('Select rate range: ', 1.8, 5.0, (3.0, 4.0))
st.write('Values:', rate)

new_restaurants = st.checkbox('Include new restaurants: ')

# If button is pressed
preferences ={}
if st.button("OK"):

    # Collecting preferences for data processing
    preferences["cuisine"] = cuisines
    preferences["price"] = (price_min,price_max)
    preferences["rate"] = rate
    preferences["new_restaurants"] = new_restaurants
    
    # Output generator
    map = run_application(preferences,df)

    
    # path_to_html = "./map.html" 

	# # Read file and keep in variable
    # with open(path_to_html,'r') as f: 
    #     html_data = f.read()
    #     # Show in webpage
    #     st.components.v1.html(html_data,height=400)

