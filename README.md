# RoadSafety

The UK police forces for every vehicle collision in the United Kingdom by year. The main purpose of this project is to investigate factors that affect accident severity using historical accidents from 2018-2020.

## Questions:
* How is the accidents encounters change over time? What is the YOY change?
* What percentage of each accident severity category do we have?
* On which Months/weekdays are accidents likely to occur?
* How are accidents distrusted throughout the day?
* Is accident severity dependant on Geography (Urban/Rural, Lat/Lon)?
* What are the factors that affect the accident severity and can we predict severity based on these factors?
* How accurate can we predict accident severity using accident features only?

## Approach
* Data processing and analysis was performed in R and using tableau for visualization.
* Linking reference data to road-casualty-statistics-accident data and viewing a data summary.
* Pre-processing the data:  
    + Handling missing values.
    + Converting time / number of casualties/ number of vehicles columns.
* EDA
    + Distribution of accident features.
    + Significance and correlation between categorical features using Chi-square and CramerV statistical tests.
    + Checking for any interactions between the features against the target variable.
    + Using Random forest model for feature importance considering the class imbalance in the target variable using SMOTE sampling.

## Solution
Required packages:  
  * data.table  
  * caret  
  * ggplot2  
  * dplyr  
  * rcompanion  
  * DescTools  
  * creditmodel  
  * corrplot  
  * rstudioapi  

