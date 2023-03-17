import streamlit as st
import numpy as np
import cv2
import tensorflow as tf
from  matplotlib import pyplot as plt
from rembg import remove
import base64
import os
import random
from PIL import Image

cwd = os.getcwd()
repo_path = "Project_4"

#st.set_option('enableStaticServing', True)
st.set_option('deprecation.showPyplotGlobalUse', False)

# # Background
# @st.cache(allow_output_mutation=True)

# def get_base64_of_bin_file(bin_file):
#     with open(bin_file, 'rb') as f:
#         data = f.read()
#     return base64.b64encode(data).decode()

# def set_png_as_page_bg(png_file):
#     bin_str = get_base64_of_bin_file(png_file) 
#     page_bg_img = '''
#     <style>
#     .stApp {
#     background-image: url("data:image/png;base64,%s");
#     background-size: cover;
#     background-repeat: no-repeat;
#     background-attachment: scroll; # doesn't work
#     }
#     </style>
#     ''' % bin_str
    
#     st.markdown(page_bg_img, unsafe_allow_html=True)
#     return
    
# print = os.path.join(cwd,repo_path,"app_2.png")
# set_png_as_page_bg(os.path.join(cwd,repo_path,"app_2.png"))



st.markdown('<h1 style="color:darkred;">Apple classification model</h1>', unsafe_allow_html=True)
st.markdown('<h2 style="color:darkred;">Classify the apple into one of the following six categories</h2>', unsafe_allow_html=True)
st.markdown('<h3 style="color:gray;"> A,B, C, D, E, F</h3>', unsafe_allow_html=True)
st.write(os.getcwd())
st.write(os.getcwd())


upload= st.file_uploader('Insert image for classification', type=['png','jpg','jpeg'])


c1, c2= st.columns(2)

# Default image size
IMG_WIDTH=320
IMG_HEIGHT=258

labels = {'Apple A': 0,
        'Apple B': 1,
        'Apple C': 2,
        'Apple D': 3,
        'Apple E': 4,
        'Apple F': 5}
        


# background_path = os.path.join(cwd,repo_path,"background_rgb.png")
background_path = ("background_rgb.png")


def plot_value_img(prediction):
    predicted_label = np.argmax(prediction)
    plt.figure(figsize=(10,5))
    plt.yticks(np.arange(len(labels.values())), labels.keys())
    plt.ylabel("Class")
    plt.xlabel("Probability")
    plt.title("Probability of belonging to a given class")
    thisplot = plt.barh(range(6), prediction, color="gray")      
    thisplot[predicted_label].set_color('g')
    plt.show()


if upload is not None:

    if "test" in str(upload.name):

        img= Image.open(upload)
        img= np.asarray(img)
        im=cv2.resize(img,(IMG_WIDTH, IMG_HEIGHT), interpolation = cv2.INTER_AREA)
        result = cv2.cvtColor(im,cv2.COLOR_BGR2RGB)
        im_to_display = result

    else:

        img= Image.open(upload)
        img= np.asarray(img)
        im=cv2.resize(img,(IMG_WIDTH, IMG_HEIGHT), interpolation = cv2.INTER_AREA)
        im_to_display = im
        im = remove(im)
        im = cv2.cvtColor(im,cv2.COLOR_BGR2RGB)
        
        background = Image.open(background_path)
        background = np.asarray(background)
        # background=cv2.resize(background,(IMG_WIDTH, IMG_HEIGHT), interpolation = cv2.INTER_AREA)
        # background = cv2.cvtColor(background , cv2.COLOR_BGR2RGB)

        # extract alpha channel from foreground image as mask and make 3 channels
        alpha = im[:,:,2]
        alpha = cv2.merge([alpha,alpha,alpha])

        # extract bgr channels from foreground image
        front = im[:,:,0:2]

        # blend the two images using the alpha channel as controlling mask
        result = np.where(alpha==(0,0,0), background, im)

    c1.header('Input Image')
    c1.image(im_to_display)




    image=np.array(result)
    image = image.astype('float32')
    image /= 255 
    x = np.expand_dims(image, axis=0)

    model = tf.keras.models.load_model(os.path.join(cwd,repo_path,"my_h5_model_4.h5"))
    prediction = model.predict(x)	# wektor prawdopodobieństw
    pred_class = np.argmax(prediction, axis=1)[0] # klasa (0-5)
    
    
    c2.header('Output')
    c2.subheader('Predicted class:')
    
    pred_label = list(labels.keys())[pred_class]  
    
    c2.write(f"{pred_class} ({pred_label}) with a probability of {prediction.max(axis=1)[0]*100:.2f}%.")
    
    st.pyplot(plot_value_img(prediction[0]))	
    



    st.markdown('<h3 style="color:lightred;">See examples of apples in the predicted class:</h3>', unsafe_allow_html=True)
    class_index = labels[pred_label]
    view_class = st.selectbox("Select class:", list(labels.keys()),index=class_index)
    images_folder = os.path.join(cwd,repo_path,'Apple', view_class)
    cols = st.columns(3)

    for i in range(3):
        file = random.choice(os.listdir(images_folder))
        cols[i].image(os.path.join(images_folder,file))

