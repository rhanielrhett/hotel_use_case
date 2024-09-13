# IHG Hotels and Resorts
**Application for Advanced Analytics Associate Manager**

## Analytics Assessment Using Google Big Query
### Assumptions
*Air Quality Index (AQI) Brackets*: </br>
Assume we categorize ozone air quality into common AQI brackets, like "Good," "Moderate," "Unhealthy for Sensitive Groups," "Unhealthy," "Very Unhealthy," and "Hazardous."

*Spatial Join Between Air Quality and Population*: </br>
Assume that the block group data from the census can be spatially mapped to the air quality data by geographical boundaries (block groups).
*Time Frame*: </br>
We focus on a specific year or a range of years for both air quality and census data. For simplicity, assume the year 2018 is used for both air quality and population data.
*Population Estimation*: </br>
Each block group has an estimated population that we'll aggregate based on air quality brackets for that region.

### Problem Solving Framework
*Define Air Quality Brackets*: </br>
We'll first need to group the air quality data into AQI brackets.
*Spatial Join*: </br>
Join the air quality data (by block group or nearest location) to census block group population data.
*Aggregation*: </br>
For each AQI bracket, calculate the total population within that category.
*Percentage Calculation*: </br>
Calculate the percentage of the total population for each AQI bracket.
*Validation*: </br>
Ensure that the air quality measurements and populations match appropriately across spatial boundaries.

### Validation Framework
*Data Integrity*: </br>
Check for missing or inconsistent values in the air quality data and census population data.
*Join Integrity*: </br>
Validate that spatial joins or mappings between the air quality and block groups make sense (e.g., ensure no mismatches in geographic boundaries).
*Population Aggregation*: </br>
Ensure the population percentages sum up to 100% across all AQI brackets.
*Time Consistency*: </br>
Verify that the time frames for the air quality and population data align properly.

### Evaluation Methods
*Check Distribution of Air Quality by Bracket*: </br>
Validate that the distribution of the population across AQI brackets matches general trends (i.e., most areas should have “Good” or “Moderate” air quality).
*Compare Population Totals*: </br>
Ensure that the total population across all air quality brackets matches the total census population.
*Handle Edge Cases*: </br>
Identify and manage any block groups without air quality data.