# -*- coding: utf-8 -*-
"""
Created on Mon Jan 18 18:51:10 2021

@author: krzys
"""
import pandas as pd
from sklearn.ensemble import RandomForestClassifier as rf


df = pd.read_csv('train.csv')
include = ['Age', 'Sex', 'Embarked', 'Survived']
df_ = df[include]  # only using 4 variables


categoricals = []
for col, col_type in df_.dtypes.iteritems():
     if col_type == 'O':
          categoricals.append(col)
     else:
          df_[col].fillna(0, inplace=True)

df_ohe = pd.get_dummies(df_, columns=categoricals, dummy_na=True)

dependent_variable = 'Survived'
x = df_ohe[df_ohe.columns.difference([dependent_variable])]
y = df_ohe[dependent_variable]
clf = rf()
clf.fit(x, y)



#from sklearn.externals import joblib
import joblib
joblib.dump(clf, 'model.pkl')

