
import argparse
import logging
import pandas as pd
from sklearn.model_selection import  train_test_split
from sklearn.model_selection import RandomizedSearchCV
from sklearn.ensemble import RandomForestClassifier
import time 
from datetime import datetime
from sklearn.metrics import f1_score,accuracy_score
import pickle

## ---- pobranie i przygotowanie danych 

def prepare_data(params):
    
    data = pd.read_csv(params.data_path)
    ex_cols = params.exclude_cols.split(',')
    feature_columns = list(set(data.columns) - set(ex_cols))
    data = data[feature_columns]
    if params.dummy_cols:
        dummy_cols = params.dummy_cols.split(',')
    else:
        dummy_cols = data.columns[data.dtypes=='object']
    
    data = pd.get_dummies(data, columns=dummy_cols)
    return data.dropna()

## ---- podział na zbiór testowy i treningowy


def datasets(params,data):
    X = data.drop(columns=params.target_col)
    Y = data[params.target_col]    
    X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size = params.test_size, random_state = params.random_state)
    return X_train, X_test, Y_train, Y_test
    
## ---- znalezienie najpeszych parametrów i wytrenowanie modelu

def fit_best_model(params,X,Y):
    
    clf = RandomForestClassifier()    
    param_grid = {"max_depth": [4,7,10,None],
            "n_estimators":[10,20,50,100],
            "min_samples_leaf":[1,3,5],
            "max_features":['auto',5,8,10],
             }
    random_search = RandomizedSearchCV(clf, param_distributions=param_grid, cv=params.cv,n_iter=params.n_iter,verbose=0, random_state=params.random_state)
    random_search.fit(X, Y)
    best = random_search.best_params_
    model = RandomForestClassifier(n_estimators=best['n_estimators'],max_depth=best['max_depth'],max_features=best['max_features'],min_samples_leaf=best['min_samples_leaf'])
    model.fit(X, Y)
    return model

## ---- wyniki na zbiorze testowym

def test_results(X,Y,model,model_name):
    predict = model.predict(X)
    acc = accuracy_score(Y,predict)
    f1 = f1_score(Y,predict,average='micro')
    result = pd.DataFrame({'model':[model_name],'accuracy':[acc],'f1':[f1]})
    return result, acc,f1
    
## ---- Główna funkcja

def main(params):
    
    start = time.time()
    log = logging.getLogger('train_model')
    log.info('Start train script')
    model_name = datetime.now().strftime('%Y%m%d') + '_' +params.suffix
    
    log.debug('Download and prepare data ...')
    data = prepare_data(params)
    X_train, X_test, Y_train, Y_test = datasets(params,data)
    
    log.debug('Find best model ... ')
    model = fit_best_model(params,X_train,Y_train)
    
    log.debug('Model testing... ')
    result, acc,f1 = test_results(X_test,Y_test,model,model_name)
    log.info('Train model compleate! Acc: {0} F1: {1}'.format(acc,f1))
    
    log.debug('Save model and results... ')
    result.to_csv('{0}/{1}.csv'.format(params.metrics_dir,model_name),index=False)
    
    with open('{0}/{1}.pkl'.format(params.model_dir,model_name), 'wb') as handle:
        pickle.dump(model, handle, protocol=pickle.HIGHEST_PROTOCOL)
    
    end = time.time()
    log.info('Script finished!')
    log.info('took {0} seconds'.format( round((end-start),1 )))
    
## ---- Parametry
    
if __name__ == "__main__":
    ## parsowanie argmentów z konsoli 
    parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    
    parser.add_argument('--data_path', type=str, default='titanic.csv',
                        help="Path to training data")
    
    parser.add_argument('--model_dir', type=str, default='models',
                        help="Path to training data")
    
    parser.add_argument('--metrics_dir', type=str, default='metrics',
                        help="Path to training data")
    
    parser.add_argument('--suffix', type=str, default='',
                        help="model suffix")
    
    parser.add_argument('--target_col', type=str, default='Survived',
                        help="")
    
    parser.add_argument('--exclude_cols', type=str, default='Name,Ticket,Cabin',
                        help="Columns to exclude ")
    
    parser.add_argument('--dummy_cols', type=str, default=None,
                        help="Dummy columns,all string type columns take if None")
    
    parser.add_argument('--test_size', type=float, default=0.2,
                        help="Test dataset size ")
    
    parser.add_argument('--random_state', type=int, default=100,
                        help="Random state")

    parser.add_argument('--cv', type=int, default=5,
                        help="Cross valiation folds")

    parser.add_argument('--n_iter', type=int, default=15,
                        help="Random search iterations")


    parser.add_argument('--debug', action='store_const', const=True, default=False,
                        help='Set debug logging level, otherwise info level is set.') 
    
    params = parser.parse_args()
    # konfiguracja loggera
    logger = logging.getLogger('train_model')
    logger.setLevel(logging.DEBUG)
    ch = logging.StreamHandler()
    ch.setLevel(logging.DEBUG if params.debug else logging.INFO)
    ch.setFormatter(logging.Formatter(fmt='%(asctime)s [%(name)s:%(levelname)s]: %(message)s',
                                      datefmt="%H:%M:%S"))
    logger.addHandler(ch)
    # wywolanie funckji main
    main(params)
