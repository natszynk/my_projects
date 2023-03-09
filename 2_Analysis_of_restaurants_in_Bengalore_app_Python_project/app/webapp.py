import pandas as pd
import streamlit as st
import numpy as np
import os
from streamlit_folium import st_folium, folium_static 
from functions.data_filters import cuisines_list
from functions.application_runner import run_application

cwd = os.getcwd()

df = pd.read_csv(str(cwd+"/2_Analysis_of_restaurants_in_Bengalore_app_Python_project/app/cleaned_zomato.csv"))
df["cuisines"] = df["cuisines"].apply(eval)

# set up the app with wide view preset and a title
st.set_page_config(layout="wide")

# Title
st.header("Where to eat in Bengalure? Let us guide you!")

#Graphics
st.image("food.png")

st.header("Find the best restaurants near you that suit your preferences")

# put all widgets in sidebar and have a subtitle
with st.sidebar:
    
    st.subheader("Select your preferences")

    # Cuisine type
    cuisines = st.multiselect("Cuisine type:", tuple(cuisines_list(df).keys()))

    # Price range
    price_min, price_max = st.select_slider('Price range: ', options=['$','$$','$$$','$$$$'], value=('$', '$$$$'))

    # Rate range
    rate = st.slider('Rate range: ', 1.8, 5.0, (3.0, 4.0))
    # st.write('Values:', rate)
    
    # New restaurants
    new_restaurants = st.checkbox('Include new restaurants: ')

# If button is pressed
preferences ={}
if st.button("Find best restaurants"):

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

