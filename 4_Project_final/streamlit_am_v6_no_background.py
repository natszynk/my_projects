import streamlit as st
from streamlit_option_menu import option_menu
import numpy as np
import cv2
import tensorflow as tf
import plotly.express as px
import pandas as pd
from rembg import remove
from PIL import Image
import os 

cwd = os.getcwd()
repo_path = "4_Project_final"

st.set_page_config(layout="centered", page_title="Apple recognition", page_icon=":apple:", initial_sidebar_state="expanded")


def show_example_image(image_path:str, image_cat:str):
    img=cv2.imread(image_path + image_cat + ".png")
    img=cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    img=cv2.copyMakeBorder(src=img, top=5, bottom=5, left=5, right=5, borderType=cv2.BORDER_CONSTANT, value=[256, 256, 256])
    return img   

def show_droped_image(img):
    # img=cv2.cvtColor(img, cv2.COLOR_BGR2RGB) - przy improcie z PIL nie zmieniają się kolory, można pominąć
    img=cv2.copyMakeBorder(src=img, top=5, bottom=5, left=5, right=5, borderType=cv2.BORDER_CONSTANT, value=[256, 256, 256])
    return img

# To chyba do usunięcia, bo się duplikuje

# def processed_image_for_classification(img):
#     img=cv2.cvtColor(img,cv2.COLOR_BGR2RGB)
#     img=cv2.resize(src=img, dsize=(320, 258), interpolation=cv2.INTER_AREA)
#     img=img.astype('float32')
#     img=img / 255 
#     img=np.expand_dims(img, axis=0)
#     return img

def processed_image_for_classification(img):

    img=cv2.resize(src=img, dsize=(320, 258), interpolation=cv2.INTER_AREA)
    img=remove(img)
    img=cv2.cvtColor(img,cv2.COLOR_BGR2RGB)
    
    background = cv2.imread(os.path.join(cwd,repo_path,"pic_background/background_rgb.png"))
    background = cv2.cvtColor(background, cv2.COLOR_BGR2RGB)
    alpha=img[:,:,2]
    alpha=cv2.merge([alpha, alpha, alpha])
    img=np.where(alpha==(0, 0, 0), background, img)
    
    img=img.astype('float32')
    img=img / 255 
    img=np.expand_dims(img, axis=0)
    return img

image_path = os.path.join(cwd,repo_path,"pic_examples/")


with st.sidebar:
    selected = option_menu(menu_title=None,
                           options=["Model", "About", "Authors"],
                           icons=["calculator", "clipboard", "people-fill"],
                           default_index=0,
                           styles={"icon": {"font-size": "25px"},
                                   "nav-link": {"font-size": "25px", "--hover-color": "#8EAD7C"}})
       

if selected == "Model":
    
    
    title = st.container()
    subtitle = st.container()
    pictures_line_1 = st.container()
    pictures_line_2 = st.container()
    drop_section = st.container()
    results = st.container()


    with title:
        st.markdown("<h1 style='text-align: center;'>Classification of apples in a jam sorting plant</h1>", unsafe_allow_html=True)
        st.markdown("""---""")


    with subtitle:
        
        st.markdown("<h2 style='text-align: center;'>This is how &#127822 &#127823 categories look like:</h1>", unsafe_allow_html=True)
        
        
    with pictures_line_1:
        col1, col2, col3 = st.columns(3)
        with col1:
            st.markdown('<h3 style="text-align: center;"> A</h3>', unsafe_allow_html=True)
            st.image(image = show_example_image(image_path, "A"))
        with col2:
            st.markdown('<h3 style="text-align: center;"> B</h3>', unsafe_allow_html=True)
            st.image(image = show_example_image(image_path, "B"))
        with col3:
            st.markdown('<h3 style="text-align: center;"> C</h3>', unsafe_allow_html=True)
            st.image(image = show_example_image(image_path, "C"))


    with pictures_line_2:
        col4, col5, col6 = st.columns(3)
        with col4:
            st.markdown('<h3 style="text-align: center;"> D</h3>', unsafe_allow_html=True)
            st.image(image = show_example_image(image_path, "D"))
        with col5:
            st.markdown('<h3 style="text-align: center;"> E</h3>', unsafe_allow_html=True)
            st.image(image = show_example_image(image_path, "E"))
        with col6:
            st.markdown('<h3 style="text-align: center;"> F</h3>', unsafe_allow_html=True)
            st.image(image = show_example_image(image_path, "F"))
        st.markdown("""---""")


    with drop_section:

        st.markdown('<h2 style="text-align: center;"> Insert an image for classification</h2>', unsafe_allow_html=True)
        upload_file= st.file_uploader(label="", type=['png', 'jpg', 'jpeg'])
        

        if upload_file is not None:
            
            img= Image.open(upload_file)
            img= np.asarray(img)

            # Convert the file to an opencv image
            # file_bytes=np.asarray(bytearray(upload_file.read()), dtype=np.uint8)
            # img=cv2.imdecode(file_bytes, 1)

            st.markdown('<h4 style="text-align: center;"> Input image</h4>', unsafe_allow_html=True)
            col7, col8, col9 = st.columns(3)
            with col7:
                st.write(' ')
            with col8:
                st.image(image = show_droped_image(img))
            with col9:
                st.write(' ')
        
        st.markdown("""---""")
        
        
    with results:
        
        if upload_file is not None:

            # model=tf.keras.models.load_model("my_h5_model_4.h5", compile=False)
            model=tf.keras.models.load_model(os.path.join(cwd,repo_path,"my_h5_model_4.h5"))
            # model.compile(optimizer=tf.keras.optimizers.Adam(), loss=tf.keras.losses.CategoricalCrossentropy(), metrics=["accuracy"])
            
            y_pred = model.predict(processed_image_for_classification(img)).argmax(axis=1)
            number = y_pred[0]
            classificaiton_dict = {0:"A", 1:"B", 2:"C", 3:"D", 4:"E", 5:"F"}
            apple_class=classificaiton_dict.get(number)
            predictions = model.predict(processed_image_for_classification(img)).flatten()*100
            predictions_int = [str(" ") if int(round(i)) == 0 else str(int(round(i)))+"%" for i in predictions]
            
            st.markdown(f'<h2 style="text-align: center;"> Predicted apple category: {apple_class}</h2>', unsafe_allow_html=True)
            st.markdown('<h4 style="text-align: center;"> Probability in %</h4>', unsafe_allow_html=True)
            fig = px.bar(x=["A","B","C","D","E","F"],
                         y=predictions,
                         text=predictions_int)
            fig.update_traces(textposition='outside')
            fig.update_yaxes(showticklabels=False, showgrid=False, range=[0, 110])
            fig.update_xaxes(showline=True, linewidth=1, linecolor='#8EAD7C')
            fig.update_layout(xaxis_title='Categories', font=dict(size=20),
                              xaxis_tickfont=dict(size=20), yaxis_title=" ", yaxis_tickfont=dict(size=20),
                              xaxis_title_font=dict(size=20))
            st.plotly_chart(fig)


if selected == "About":
    
    goals_descr = st.container()
    model_descr = st.container()
    model_structure = st.container()
    confusion_matrix = st.container()


    with goals_descr:
        st.markdown("<h1 style='text-align: center;'>Goals of the project</h1>", unsafe_allow_html=True)
        st.markdown("""
                    
                    <style>
                    a {
                    color: #8EAD7C !important;
                    text-decoration: none;}
                    
                    a:hover {
                    color: #E3DED7 !important;
                    text-decoration: none;}
                    </style>

                    """
                    , unsafe_allow_html=True)  
        

        st.markdown("##### &nbsp;&nbsp;&nbsp;&nbsp; :ballot_box_with_check: &nbsp;&nbsp;&nbsp; Goal of a project:  <span style='color: #8EAD7C; font-weight: normal;'> Recognition of three to all classes of apples</span>", unsafe_allow_html=True)
        st.markdown("##### &nbsp;&nbsp;&nbsp;&nbsp; :ballot_box_with_check: &nbsp;&nbsp;&nbsp; Goal of an app:  <span style='color: #8EAD7C; font-weight: normal;'> Classification of apples in a jam sorting plant</span>", unsafe_allow_html=True)
        st.markdown("##### &nbsp;&nbsp;&nbsp;&nbsp; :ballot_box_with_check: &nbsp;&nbsp;&nbsp; Data source: <span style='color: #8EAD7C; font-weight: normal;'> https://www.kaggle.com/chrisfilo/fruit-recognition </span>", unsafe_allow_html=True)
        st.markdown("##### &nbsp;&nbsp;&nbsp;&nbsp; :ballot_box_with_check: &nbsp;&nbsp;&nbsp; Code: <span style='color: #8EAD7C; font-weight: normal;'> https://cutt.ly/J4pFsMO </span>", unsafe_allow_html=True)
        
        st.markdown("---")
    
    
    with model_descr:
        st.markdown("<h1 style='text-align: center;'>Model description</h1>", unsafe_allow_html=True)
        st.markdown("<p style='text-align: justify; color: #E3DED7, background-color: #2D4443;'> \
                    \
                    In this project, a precise <b><u>Convolutional Neural Network (CNN)</u></b> model was developed from scratch, \
                    without relying on any pre-trained models. \
                    The model comprises convolutional layers that process images \
                    and flatten them before further processing them with dense layers. \
                    The Soft Max function is used to determine the probability of the image belonging to a specific category, \
                    and the image is assigned accordingly. \
                    The <b><u>Accuracy</u></b> is the primary evaluation metric used to evaluate the performance of this model. \
                    Overall, this project showcases the impressive capabilities of CNNs in accurately classifying images.\
                    </p>"
                    , unsafe_allow_html=True)

        st.markdown("---")
       
       
    with model_structure:
        st.markdown("<h1 style='text-align: center;'>Model architecture</h1>", unsafe_allow_html=True) 
        st.markdown("<h5 style='text-align: center;'>Number of parameters: 170 598</h5>", unsafe_allow_html=True)

        df = pd.read_excel(os.path.join(cwd,repo_path,"model_structure/model_structure.xlsx"), sheet_name="model_structure")
        
        # CSS that hides table index
        st.markdown("""
                    <style>
                    thead tr th:first-child {display:none}
                    tbody th {display:none}
                    </style>
                    """ ,unsafe_allow_html=True)
        
        st.table(df)
        
        st.markdown("---")
 

    with confusion_matrix:
        st.markdown("<h1 style='text-align: center;'>Model performance</h1>", unsafe_allow_html=True)
        st.markdown("<h5 style='text-align: center;'>Accuracy: 0.99 &#9989</h5>", unsafe_allow_html=True)
        
        df_matrix = pd.read_excel(os.path.join(cwd,repo_path,"model_structure/model_structure.xlsx"), sheet_name="matrix")

        # CSS that hides table index
        st.markdown("""
                    <style>
                    thead tr th:first-child {display:none}
                    tbody th {display:none}
                    </style>
                    """ ,unsafe_allow_html=True)

        st.table(df_matrix.style.format({'Precision': '{:.2f}', 'Recall': '{:.2f}', 'F1-score': '{:.2f}'}))

        st.markdown("---")   
    
    
if selected == "Authors":    
    st.markdown("# Project team members:")
    
    # streamlit requires to overwrite link color defined in html <style> section with addidional command: "!important"
    # defining "a:hover" changes link display while hover by coursor
    st.markdown("""
                
                <style>
                a {
                color: #8EAD7C !important;
                font-size: 16px;
                text-decoration: none;}
                
                a:hover {
                color: #E3DED7 !important;
                text-decoration: none;}
                </style>
                
                <h4>&nbsp&nbsp&nbsp&nbsp 1. &nbsp&nbsp Natalia Szynkiewicz &nbsp&nbsp&nbsp<a href="https://github.com/natszynk" target="_blank">(go to GitHub)</a></h4>
                <h4>&nbsp&nbsp&nbsp&nbsp 2. &nbsp&nbsp Aron Możejko &nbsp&nbsp&nbsp<a href="https://github.com/aronm88" target="_blank">(go to GitHub)</a></h4>
                <h4>&nbsp&nbsp&nbsp&nbsp 3. &nbsp&nbsp Filip Szulc &nbsp&nbsp&nbsp<a href="https://github.com/fszulc1" target="_blank">(go to GitHub)</a></h4>
                """
                , unsafe_allow_html=True)
