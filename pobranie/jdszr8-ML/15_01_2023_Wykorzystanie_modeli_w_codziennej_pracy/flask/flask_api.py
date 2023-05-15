
from flask import render_template, request, jsonify, Flask
import joblib
import pandas as pd

app = Flask(__name__)

@app.route('/')
def welcome():
   return "Prediction test"

@app.route('/predict', methods=['POST'])
def predict():
     json_ = request.json
     print(json_)
     query_df = pd.DataFrame(json_)
     prediction = model.predict_proba(query_df)
     return jsonify({'prediction': [str(p) for p in prediction]})
     
     
if __name__ == '__main__':
     model = joblib.load('model.pkl')
     app.run(port=8080)

