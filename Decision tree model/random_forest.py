import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from sklearn import metrics, tree
from sklearn.tree import DecisionTreeClassifier, DecisionTreeRegressor, export_graphviz
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import cross_val_score, train_test_split
from sklearn.metrics import confusion_matrix, mean_squared_error
import seaborn as sns
import pydot
import os

plt.rcParams.update({'figure.figsize': (12.0, 8.0)})
plt.rcParams.update({'font.size': 14})

# Create dictionary for each county that is going to have the random forest model ran on
# There are four attributes to look at, crime, population estimate, poverty percentage, and state tax
# The model will run against the hmi of each city in each county as a target 

sources_dict = {"arrests": None, "crime":None, "pop_estimate":None, "poverty_pct": None, "state_tax":None}
dict = {"cochise":sources_dict, "coconino":sources_dict, "gila":sources_dict, "graham":sources_dict, 
"maricopa":sources_dict, "mohave":sources_dict, "pima": sources_dict, "navajo":sources_dict, 
"santa_cruz": sources_dict, "yavapai":sources_dict, "yuma":sources_dict}

# Go through each county, split the data by attribute into their own dataframe
# Create a list of all the attributes and their dataframes
# For each attribute create a model that runs it against the hmi of the city within that county
for county in dict.keys():

    data = pd.read_csv("C:/Users/Mason/Documents/Capstone-Fall-2021-main/final_data/"+ county + ".csv")

    hmi = data.iloc[:, 1]
    arrests = data.iloc[:, 2:3].values
    crime = data.iloc[:, 3:4].values
    pop_estimate = data.iloc[:, 4:5].values
    poverty_pct = data.iloc[:, 5:6].values
    state_tax = data.iloc[:, 6:7].values

    sources = [arrests, crime, pop_estimate, poverty_pct, state_tax]

    # Create a list of the r squared values for each attribute used against the hmi
    # Using the hmi and given attribute it will create training and testing data for the
    # model to learn from

    r_sqrs = []

    # Will create and fit the model for each training and test data given by each attribute
    # then obtain the r-squared value, append it to the list
    for source in sources:
        X = source
        y = hmi
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=0)
        model = RandomForestRegressor()
        model.fit(X_train, y_train)
        y_pred = model.predict((X_test))
        r2 = metrics.r2_score(y_test, y_pred)
        r_sqrs.append(r2)
        
        export_graphviz(model.estimators_[0], out_file= county + '.dot', filled=True, rounded=True)
        (graph,) = pydot.graph_from_dot_file(county + '.dot')
        graph.write_png(county + '.png')
        from subprocess import call
        call(['dot', '-Tpng', county + '.dot', '-o', county + '.png', '-Gdpi=600'])
    
        # Within the dictionary of counties is another dictionary whose values are each attribute and value equaling none
    # The next 5 lines will connect each attribute to their respective r-squared value
    dict[county]["arrests"] = r_sqrs[0]
    dict[county]["crime"] = r_sqrs[1]
    dict[county]["pop_estimate"] = r_sqrs[2]
    dict[county]["poverty_pct"] = r_sqrs[3]
    dict[county]["state_tax"] = r_sqrs[4]

    print(county + ':' + str(dict[county]))
    
    




