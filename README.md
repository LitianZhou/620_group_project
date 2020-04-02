# 620_group_project

This is the project II for BIOSTAT620 @Umich

Group member: Litian Zhou, Bangyao Zhao， Ningyuan Wang

`data2df.R`: a function to process raw data
`data_preprocess.R`: use the result from `data2df.R` to create epoch data, create a dataframe for every person
`normalization.R`: use the result from `data_preprocess.R`, we can discuss multiple ways to normalize everyone's data and merge them into one big dataframe.
`glm_analysis.R` based on the normalized data, run a glm logistic regression
