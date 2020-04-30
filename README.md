# Sleep quality defined

This repository includes the gourp project II for BIOSTAT620 @Umich SPH and the modified final project to define the sleep quality score.

Group member: Litian Zhou, Bangyao Zhao，Ningyuan Wang

Here are some introduction of some key functions

`data2df.R`: a function to process raw data

`data_preprocess.R`: use the result from `data2df.R` to create epoch data, create a dataframe for every person

`normalization.R`: use the result from `data_preprocess.R`, we can discuss multiple ways to normalize everyone's data and merge them into one big dataframe.

`glm_analysis.R` based on the normalized data, run a glm logistic regression

`random_forest.R` model random forest and tune hyperparameters

`logistic_regression_box_up.R` fit a diagnosed logistic model and draw box plot to check sleep qualiy in subgroups
