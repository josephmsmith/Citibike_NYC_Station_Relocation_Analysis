# Citibike NYC Station Relocation Analysis 
Data analysis from Citibike NYC. Analyzed in PostgreSQL and Tableau. Full presentation is located [HERE](https://public.tableau.com/app/profile/josephmsmith/viz/Citibike_Post-Covid_Analysis/CitibikeAnalysis) in Tableau Public

## Introduction
The purpose of the Bike Share Expansion Program is to evaluate the current routes based on popularity, identify population centers and destination attractions, for both amusement and employment bikesharing and add stations in growing locations. The presentation is geared towards Citibike executives to understand how their current landscape has changed over the last 4 years and how to pivot in order to remain successful.


## Purpose
If COVID has impacted the number of rideshare users, then how has individual station popularity changed since the start of 2020? By doing this analysis we will be able to see how station popularity has changed and if we need to expand to new areas. The goal will be to eliminate any stations that have decreased popularity drastically since 2019 and relocate them to new areas.

## Data Sources
All of the data was collected from [Citi Bike NYC System Data](https://ride.citibikenyc.com/system-data), specifically for the years 2019 and 2022. Based on the dataset we can see what type of user the rider is, where they started and where they ended, how long the ride was, how old and what gender the user is, if the user is a subscriber, and more. 

The primary columns that will be used for this analyis include:

Start_time  | Stop_time | Start_station_id  | End_station_id | Bike_id  | User_type | 
----------- | --------- | ----------------- | -------------- | -------- | --------- | 

The main questions that will be answered include:
1. How has the number of rideshare users changed? Has it increased? Decreased?
2. Has subscriber versus customer percentage changed?
3. What were the most popular stations in 2019 versus 2022? 
4. Are there any stations that are no longer being used? 

## About the Data
2019 & 2022 Data is collected from Citibike and is limited to Jersey City only

The data does not include:
- Staff associated trips
- “Test” rides or stations
- Trips that are shorter than 60 seconds in length

Assumptions:
Riders are using their own account (not subscribers)

Limitations:
- Data is limited to two specific years - which are 2019 and 2022 and does not include 2020/2021 data
- Only includes rides that started and ended in Jersey City
- This excludes commuter data (for riders going back and forth to NYC)
- Data Collection Methodology has changed slightly. For instance, gender is no longer recorded and Citibike added electric bikes to the fleet. Neither of these   specific characteristics will be included. 
- Rider identification is limited. We can’t gather information like how many times the average subscriber rode last year. 


Subscribers Versus Customers
- A customer is a 24 hour pass or 3 day pass user while a subscriber pays an annual or monthly membership rate
- Subscribers get the first 45 minutes of each trip included while customers only get 30 minute rides and pay a fee for every minute after.


## Analysis
Ridership 
228%  increase in total ridership from 2019 to 2022 with a grand total of 895,485 rides. Another ridership change we saw was an increase in average time per ride.

Subscribership
Major user type shift from 90% of users in 2019 being subscribers to about 66%. Increase in the number of customers during summer months

At-Risk Bike Stations
Classify at-risk: any station under 120 rides/year or 10/month. These are stations we should consider relocating to busier areas where bike availability and maintenance is more frequent.
In 2022 we had a total number of end stations of 320 and out of them, we said 238 were at risk. With that being said these were only about 1000 of the 900,000 - accounts for about less than 1% of the total rides

## Conclusion
Despite COVID, Ridership has increased since 2019. After comparing this analysis with previous [operating reports](https://ride.citibikenyc.com/system-data/operating-reports) from citibike we can actually see revenue streams from increased rider activity combined with casual membership start increasing drastically which could be an indicator of how we should charge customers moving forward. Citibike is projected to surpass subscription revenue with casual membership revenue in the near term. Propose analyzing the at-risk stations to determine profit margin while continuing to invest in additional stations near highly used stations

## Other Resources
[NYC Bicycling Data](https://www.nyc.gov/html/dot/html/about/datafeeds.shtml#Bikes)

[BikeNYC Google Group](https://groups.google.com/g/citibike-hackers/about)


