# Input should be a dataframe in the name of people

# Output is the standardized data frame, adding columns of ratios to 
# the sleeping median/mean, including HR/sleep_HR, EDA/sleep_EDA, ACC/sleep_ACC
require(dplyr)

med_ratio_standardization = function(people){
  if(!is.data.frame(people)) {
    people = bind_rows(people)
  }
  for(p in c(2:7)) {
    dmed = median(people[[p]][people$sleep==1])
    people[[p]] = people[[p]]/dmed
  }
  return(people)
}

mean_ratio_standardization = function(people) {
  if (!is.data.frame(people)) {
    people = bind_rows(people)
  }
  for (p in c(2:7)) {
    dmean = mean(people[[p]][people$sleep == 1])
    people[[p]] = people[[p]] / dmean
  }
  return(people)
}
