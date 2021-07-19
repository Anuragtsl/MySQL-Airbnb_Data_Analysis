# MySQL-Airbnb_Data_Analysis

I have used AIRBNB_USER_DATA from kaggle{Link:- https://www.kaggle.com/c/airbnb-recruiting-new-user-bookings/data}.

I have CLEAN, EXTRACT and ANALYSED the data using SQL Queries in SQL Workbench.

There are some important steps covered in .sql file as comments just follow along and you will get perfect analysis of the data.

# Analysis
> Data cleaning
* Understanding of column names
* Treatment of duplicate values
* Missing value processing
* Outlier handling

>  User portrait analysis
* Gender distribution characteristics of users
* Age distribution of users
* Distribution of users in different regions
* Proportion of regions where Chinese users make reservations abroad

-Speculation and treatment of missing causes
If the date_first_booking (first booking time) data is missing, it can be understood in business that the user is an "unbooked user", that is, a user who has not placed an order.

Gender and age are optional because this part of the information in the client is optional, and the blank value is not filled in by the user.
The other four data are because the front-end statistics are not counted.

-Processing: In actual analysis, null data needs to be excluded from the where condition before analysis.

> Conversion funnel analysis
* Proportion of active users (non-zombie users)
* Proportion of registered users
* Proportion of users placing orders
* Proportion of actual paying users

It can be seen that:
-Registered users to order users are the link with the highest churn rate in the airbnb conversion funnel. Only 14% of registered users place orders, which is only 7.651% of all users.

-The active and repurchase links performed well. Among them, 60% of the users who placed orders repurchased, indicating that airbnb's products and services are doing very well.

-Approximately 13% of users who placed an order did not make the final payment, which requires product R&D intervention.

# Summary of analysis - Conclusions

* #1. User portrait summary

-Among the user genders, there are more male users than female users, but the difference is not big (7.3% gap)
-The age of users is mainly young and middle-aged. The largest number of users is born in the 80s to (29 to 39 years old), followed by the 90s, and then the 75s.
-Europe and the United States have the most users in the region, followed by China, but Europe and the United States account for more than 90%. (As of 2014)
-The other country that Chinese users book the most is the United States, which accounts for more than 90%.

* #2. Summary of conversion funnel

-The link with the highest churn rate in the airbnb conversion funnel is "user orders", with only 14% of registered users placing orders.
-About 13% of the users who placed the order did not make the payment.
-The registration rate needs to be improved.
-The good performance in the active and repurchase links indicates that airbnb's products and services are doing very well.

# Suggestion / Recommendation after Analysis

> Suggestion: User portrait

* According to the characteristics of age distribution, it is recommended that SEO or paid advertisements should be targeted to men aged 29-39.

> Recommendation : Conversion funnel aspects

* -Registered users to place orders are the link with the highest churn rate in the airbnb conversion funnel. Only 14% of registered users actually place orders. This link is one of the main sources of corporate revenue. It is recommended to improve the order rate. More work. For example, regular push (product push + SMS mail) high-quality listings for the user trajectory of active users. In addition, increasing the conversion rate of orders is a long-term task that requires a combination of multiple strategies in parallel.

* -Approximately 13% of the users who placed the order did not pay in the end. It is necessary to investigate the specific reason (why the order has been placed, or one-tenth of the users did not settle), it is recommended that users Investigate, or count the reasons why users have not paid on the product (whether it is the user's own decision, the product process, or the payment type that does not meet individual regions, etc.).
