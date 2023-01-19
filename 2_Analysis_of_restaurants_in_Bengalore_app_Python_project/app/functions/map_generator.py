import folium
import webbrowser
import pandas as pd
import numpy as np
from IPython.display import display

BANGALORE_CENTRE_POSITION = [12.978889, 77.591667]
FILE_LOCATION = "map.html"

def generate_popup(df,x):

    label=f"""
        <h4>{df['name'][x]}</h4>
        <b>Address:</b> {df['address'][x]}<br>
        <div style="white-space: nowrap;overflow: hidden;text-overflow: ellipsis;">
        <b>Website:</b> <a href={df['url'][x]}>{df['url'][x]}</a></div>
        <b>Phone number(s):</b> {df['phone'][x]}<br>
        <b>Rating:</b> {get_rate_info(df,x)} <br>
        <b>Cuisine type:</b> {", ".join(df['cuisines'][x])}<br>
        <b>Price:</b> {get_price_key(df,x)}"""
        
    return label

def get_rate_info(df,row):
    val = df.loc[row,"rate"]
    if val == val:
        info = f"{df['rate'][row]}/5 ({df['votes'][row]} votes)"
    else: 
        info = f"-/5 ({df['votes'][row]} votes) - new restaurant"

    return info

def get_price_key(df,row):
    
    val = df.loc[row,"cost"]
    price_ranges={'$':(0,250), '$$': (250,400), '$$$':(400,600), '$$$$':(600,4701)}
    if val==val:
        for key, value in price_ranges.items():
            if  value[0]<=val<value[1]:
                return key
    else:
        return 'No information (new restaurant)'

def generate_map(df:pd.DataFrame,user_location:tuple):

    generated_map = folium.Map(location=BANGALORE_CENTRE_POSITION, zoom_start=13) 
    generated_map.add_child(folium.Marker(location=user_location, 
                                        popup=folium.Popup(html="<b>You are here!</b>",max_width=300), 
                                        icon=folium.Icon(icon='glyphicon glyphicon-user',color="red")))
    for x in df.index:
        restaurant_location = df["latitude"][x], df["longitude"][x]
        generated_map.add_child(            
            folium.Marker(                  
                location=restaurant_location,       
                popup=folium.Popup(html=generate_popup(df,x), max_width=400),         
                tooltip = f"""
                <b>TOP {x+1}: </b><i>{df['name'][x]}</i>. 
                You will get there on foot in {df['walk_time'][x]} minutes.""",
                icon=folium.Icon(icon='glyphicon glyphicon-cutlery',color="green")
            )
        )

    # Draws a line to the TOP location
    target_restaurant = df["latitude"][0], df["longitude"][0]
    folium.PolyLine([user_location, target_restaurant], color="red", weight=3.5,dash_array='10', opacity=0.5,).add_to(
        generated_map
    )

    generated_map.save(FILE_LOCATION)
    # return webbrowser.open('map.html')
    return generated_map
    # display(generated_map)

    
