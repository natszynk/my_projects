import ipywidgets as widgets
from IPython.display import display
from .data_filters import cuisines_list
import numpy as np
import pandas as pd
from .application_runner import run_application


def display_widgets(df:pd.DataFrame):

    cuisine_selection = widgets.SelectMultiple(description='Cuisine type: ', 
                                                options=cuisines_list(df).keys(),
                                                disabled=False)
    price_selection = widgets.SelectionRangeSlider(options=['$', '$$', '$$$','$$$$'],
                                                    index=(0, 3), 
                                                    description='Price range: ',
                                                    disabled=False)
    rate_selection = widgets.FloatRangeSlider(description='Rating: ', min=1.8, 
                                                max= 5.0, step=0.1, disabled=False)
    new_restaurants = widgets.Checkbox(value=False, description='Include new restaurants: ')
    out = widgets.Output()
    button = widgets.Button(description="OK")
    
    global preferences
    preferences={}


    def collect_preferences():

        preferences["cuisine"] = cuisine_selection.value
        preferences["rate"] = rate_selection.value
        preferences["price"] = price_selection.value
        preferences["new_restaurants"] = new_restaurants.value
        return preferences

    def display_preferences(preferences):
        print(f"""Your preferences:
        -- cuisine: {preferences["cuisine"]} 
        -- rating: {preferences["rate"]}
        -- price: {preferences["price"]}
        -- include new restaurants: {preferences["new_restaurants"]}""")

    def on_button_clicked(b):
        
        collect_preferences()
        cuisine_selection.close()
        price_selection.close()
        rate_selection.close()
        new_restaurants.close()
        out.close()
        button.close()
        display_preferences(preferences)
        run_application(preferences,df)


    @out.capture()
    def changed(b):
        out.clear_output()
        print(f"Selected cuisine types: {str(cuisine_selection.value)}")
        print(f"Selected price range: {price_selection.value[0]} - {price_selection.value[1]}")
        print(f"Selected rate range: {rate_selection.value[0]} - {rate_selection.value[1]}")
        print(f"Incude new restaurants: {new_restaurants.value}") 

    cuisine_selection.observe(changed)
    price_selection.observe(changed)
    rate_selection.observe(changed)
    new_restaurants.observe(changed)


    display(cuisine_selection,price_selection,rate_selection, new_restaurants, button,out)
    button.on_click(on_button_clicked)


    