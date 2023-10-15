import streamlit as st
import pandas as pd
import pickle
import gzip
import seaborn as sns
import matplotlib.pyplot as plt
import plotly.express as px
st.set_option('deprecation.showPyplotGlobalUse', False)
#Loading up the Regression model we created
# model = xgb.XGBClassifier()
# model.load_model('best_model.json')

with gzip.open('model.pklz', 'rb') as model:
    classifer = pickle.load(model)

#Caching the model for faster loading
@st.cache


def predict(fa,va,ca,rs,ch,fsd,tsd,d,ph,sul,a):

    df_pred = pd.DataFrame([[fa,va,ca,rs,ch,fsd,tsd,d,ph,sul,a]], columns=['fixed acidity', 'volatile acidity', 'citric acid', 'residual sugar',
    'chlorides', 'free sulfur dioxide', 'total sulfur dioxide', 'density','pH', 'sulphates', 'alcohol'])

    prediction = classifer.predict(df_pred.values)
    return prediction

columns=['fixed acidity', 'volatile acidity', 'citric acid', 'residual sugar',
    	'chlorides', 'free sulfur dioxide', 'total sulfur dioxide', 'density',
	'pH', 'sulphates', 'alcohol']

df = pd.read_csv('wine_transformed.csv')




# set up the app with wide view preset and a title
st.set_page_config(layout="wide")
st.title('Wine quality predictor ')
st.image("Quality-In-Wine-cover.jpg")
st.header("Classify the wine quality by its properties")

# put all widgets in sidebar and have a subtitle
with st.sidebar:
	st.subheader("Enter the wine properties")

	fa = st.number_input('Fixed acidity:', min_value=0.0,value=df[columns[0]].mean())
	va = st.number_input('Volatile acidity:', min_value=0.0, value=df[columns[1]].mean())
	ca = st.number_input('Citric acid:', min_value=0.0, value=df[columns[2]].mean())
	rs = st.number_input('Residual sugar:', min_value=0.0, value=df[columns[3]].mean())
	ch = st.number_input('Chlorides:', min_value=0.0, value=df[columns[4]].mean())
	fsd = st.number_input('Free sulfur dioxide:', min_value=0.0, value=df[columns[5]].mean())
	tsd = st.number_input('Total sulfur dioxide:', min_value=0.0, value=df[columns[6]].mean())
	d = st.number_input('Density:', min_value=0.900, max_value=1.100, value=df[columns[7]].mean())
	ph = st.number_input('pH:', min_value=0.1, max_value=14.0, value=df[columns[8]].mean())
	sul = st.number_input('Sulphates:', min_value=0.0, value=df[columns[9]].mean())
	a = st.number_input('Alcohol:', min_value=0.0, value=df[columns[10]].mean())

points = [fa,va,ca,rs,ch,fsd,tsd,d,ph,sul,a]


def draw_boxplot(df, features, points):

	if len(features)%6 !=0:
		nrows = (len(features))//6+1
	else:
		nrows = int((len(features))/6)
	fig, axes = plt.subplots(nrows, 6,figsize=(20, nrows*5))

	row=0
	i=0
	
	# for feature in features:
	for feature, point in zip(features,points):
		if nrows != 1:
			sns.boxplot(data=df, x='quality',y=feature, showmeans=True, meanprops={"markeredgecolor": "yellow"},ax=axes[row,i])
			sns.stripplot(data=df,x='quality', y = point, color = 'red', dodge=True, jitter=False, alpha = 0.5, ax=axes[row,i])
			i += 1
			
			if i > 5 and nrows != 1:
				i = 0
				row += 1
		else:
			sns.boxplot(data=df, x='quality', showmeans=True, meanprops={"markeredgecolor": "yellow"},ax=axes[i])
			sns.stripplot(data=df, x='quality', y = point, color = 'red', dodge=True, jitter=False, alpha = 0.5, ax=axes[i])
			i += 1
    
	plt.tight_layout()
	plt.show()


if st.button('Predict quality'):

	quality = predict(fa,va,ca,rs,ch,fsd,tsd,d,ph,sul,a)
	st.success(f'The predicted quality of the wine is {quality[0]} (0 - poor, 1 - good, 2 - very good, 3 - excellent)')
	st.header("Properties of wines within the class")
	# points = [fa,va,ca,rs,ch,fsd,tsd,d,ph,sul,a]
	# plot = draw_boxplot(df,columns,'quality',points)
	df_filtered = df[df['quality']==quality[0]]
	plot = draw_boxplot(df_filtered, columns, points)
	# properties = st.selectbox(label="Select property:", options=columns, index=0)
	# fig = px.box(df[df["quality"]==quality], x="quality", y=properties)
	# st.plotly_chart(fig)
	st.pyplot(plot)




