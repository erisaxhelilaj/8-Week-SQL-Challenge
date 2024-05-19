# <p align="center" style="margin-top: 0px;">🛒 Case Study #5 - Data Mart 🛒
## <p align="center"> B. Data Exploration

## Solution

View the complete syntax [*here*](https://github.com/hydaai/8-Week-SQL-Challenge/tree/main/Case%20Study%20%235%20-%20Data%20Mart/Scripts).

***

## 1. *What day of the week is used for each week_date value?*

#### Steps:
- Find the day used for the `week_date` value using **TO_CHAR**.

````sql
      select
        week_date
      , to_char(week_date, 'Day') as day_name
    from data_mart.clean_weekly_sales;
````


#### Answer:

| day_name  |
| --------- |
| Monday    |

- Monday is used for each week_date value.

***

## 2. *What range of week numbers are missing from the dataset?*

#### Steps:
- Assume 1 year has 52 weeks
- Look for which weeks are not in the dataset
- Find out how many weeks are missing in the dataset using **COUNT**.

````sql
with all_weeks as (
               select 
               generate_series(1, 52) as week_number),
                     existing_weeks as (
					select distinct num_week as week_number
					from  data_mart.clean_weekly_sales)
				select 
				count(a.week_number) as missing_weeks_count
				from all_weeks a
				left join existing_weeks as e on a.week_number = e.week_number
				where e.week_number is null;
````

#### Answer:

| missing_weeks_count |
| ------------------- |
| 28                  |

- There are 28 week numbers are missing.

***

## 3. *How many total transactions were there for each year in the dataset?*

#### Steps:
- Find out how many total transactions using **SUM**
- Use **GROUP BY** to separate results each year.

````sql
       select
           year 
         , sum(transactions) as total_transactions
       from data_mart.clean_weekly_sales
       group by year
       order by year;
````


#### Answer:

year | total_transactions
--| --
2018 | 346406460
2019 | 365639285
2020 | 375813651

- In 2018 there were 346406460 transactions.
- In 2019 there were 365639285 transactions.
- In 2020 there were 375813651 transactions.

***

## 4. *What is the total sales for each region for each month?*

#### Steps:
- Find out how many total sales using **SUM**
- Use **GROUP BY** to separate by region for each month.

````sql
        select 
            region
          , month
          , sum (sales) as total_sales
        from  data_mart.clean_weekly_sales
        group by  region, month
        order by  region, month;
````


#### Answer:
***NOTE*** : *Not all output is displayed, considering the number of results and will take up space*	
region | month_number |  total_sales
-- | -- | --
AFRICA | 3 | 567767480
AFRICA | 4 | 1911783504
AFRICA | 5 | 1647244738
AFRICA | 6 | 1767559760
AFRICA | 7 | 1960219710
AFRICA | 8 | 1809596890
AFRICA | 9 | 276320987
ASIA | 3 | 529770793
ASIA | 4 | 1804628707
ASIA | 5 | 1526285399
ASIA | 6 | 1619482889
ASIA | 7 | 1768844756
ASIA | 8 | 1663320609
ASIA | 9 | 252836807

- In March, Africa had total sales of $567767480, while Asia $529770793.
- In April, Africa had total sales of $1911783504, while Asia $1804628707.

***


## 5. *What is the total count of transactions for each platform*

#### Steps:
- Use **SUM** to find total amount each customers per month


````sql
      select 
          platform
        , sum(transactions) as total_transactions
      from  data_mart.clean_weekly_sales
      group by platform  
      order by  platform; 
````


#### Answer:

platform | total_transactions
-- | --
Retail | 1081934227
Shopify | 5925169

- Total transactions for Retail platforms are 1081934227 while Shopify is 5925169.

***

## 6. *What is the percentage of sales for Retail vs Shopify for each month?*

#### Steps:

- Find out the percentage of Retail and Shopify sales each month.

````sql
         select 
              month
            , year
            , platform
            , round(cast(sales_percentage as numeric), 2) as rounded_sales_percentage
         from (
                  select 
                     extract(month from week_date) as month
                   , extract(year from week_date) as year
                   ,  platform
                   ,  (sum(sales) * 100.0 / sum(sum(sales)) over (partition by extract(month from week_date)
                   ,  extract(year from week_date)))::double precision as sales_percentage
                from data_mart.clean_weekly_sales
                where platform in ('Retail', 'Shopify')
                group by  extract(month from week_date),  extract(year from week_date), platform ) as subquery    
                order by year, month,  platform;
````


#### Answer:
***NOTE*** : *Not all output is displayed, considering the number of results and will take up space*	
| month | year | platform | rounded_sales_percentage |
| ----- | ---- | -------- | ------------------------ |
| 3     | 2018 | Retail   | 97.92                    |
| 3     | 2018 | Shopify  | 2.08                     |
| 4     | 2018 | Retail   | 97.93                    |
| 4     | 2018 | Shopify  | 2.07                     |

- In March 2018, the percentage of retail sales was 97.92% while Shopify was 2.08%.
- In April 2018, the percentage of retail sales was 97.93% while Shopify was 2.07%.

***

## 7. *What is the percentage of sales by demographic for each year in the dataset?*

#### Steps:

- Find out the percentage of sales by demographic for each year.

````sql
		select 
                          year,
                          demographic,
                          total_sales,
                          round(sales_percentage, 2) as sales_percentage
						from (
                                                    select 
                                                       extract(year from week_date) as year,
                                                       demographic,
                                                       sum(sales) as total_sales,
                                                       (sum(sales) * 100.0 / sum(sum(sales)) over (partition by extract(year from week_date)))::numeric as sales_percentage
						from data_mart.clean_weekly_sales
						group by extract(year from  week_date), demographic
						) as subquery
						order by year, demographic;
````


#### Answer:

| year | demographic | total_sales | sales_percentage |
| ---- | ----------- | ----------- | ---------------- |
| 2018 | Couples     | 3402388688  | 26.38            |
| 2018 | Families    | 4125558033  | 31.99            |
| 2018 | unknown     | 5369434106  | 41.63            |
| 2019 | Couples     | 3749251935  | 27.28            |
| 2019 | Families    | 4463918344  | 32.47            |
| 2019 | unknown     | 5532862221  | 40.25            |
| 2020 | Couples     | 4049566928  | 28.72            |
| 2020 | Families    | 4614338065  | 32.73            |
| 2020 | unknown     | 5436315907  | 38.55            |

- In 2018, the percentage of sales by couples was 26.38%, families were 31.99% and unknown was 41.63%.
- In 2019, the percentage of sales by couples was 27.28%, families were 32.47% and unknown was 40.25%.
- In 2020, the percentage of sales by couples was 28.72%, families were 32.73% and unknown was 38.55%.

***

## 8. *Which age_band and demographic values contribute the most to Retail sales?*

#### Steps:
- Find out how many total sales using **SUM**
- Find the percentage of the contribution
- Use **GROUP BY** to separate results each `age_band` and `demographic`.

````sql
          select 
              age_band,
              demographic,
              total_sales,
              round(cast(contribute_percent as numeric), 2) as contribute_percent
                 from (
                      select 
                           age_band,
                           demographic,
                           sum(sales) as total_sales,
                           100 * sum(sales) / sum(sum(sales)) over () as contribute_percent
                      from data_mart.clean_weekly_sales
                      where platform = 'Retail'			
                      group by age_band, demographic ) as subquery
                      order by total_sales desc;
					
````


#### Answer:

age_band | demographic | total_transactions | contribute_percent
-- | -- | -- | --
unknown | unknown | 16067285533 | 40.52
Retirees | Families | 6634686916 | 16.73
Retirees | Couples | 6370580014 | 16.07
Middle Aged | Families | 4354091554 | 10.98
Young Adults | Couples | 2602922797 | 6.56
Middle Aged | Couples | 1854160330 | 4.68
Young Adults | Families | 1770889293 | 4.47

- Unknown age_band and demographic are the most contribute to Retail sales (40.52%), 
  followed by Retirees-Families (16.73%) and followed by Retirees-Couples (16.07%).

***

## 9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? 

#### Steps:

- Find the average of each sales divided by each transaction as `avg_transaction_size`


````sql
      select 
          extract(year from week_date) as year, 
          platform,
          round(sum(sales)::numeric / sum(transactions)::numeric, 2) as average_transaction_size
      from data_mart.clean_weekly_sales   
      where platform in ('Retail', 'Shopify')  
      group by  extract(year from week_date), platform
      order by  year,  platform;
````


#### Answer:

| year | platform | average_transaction_size |
| ---- | -------- | ------------------------ |
| 2018 | Retail   | 36.56                    |
| 2018 | Shopify  | 192.48                   |
| 2019 | Retail   | 36.83                    |
| 2019 | Shopify  | 183.36                   |
| 2020 | Retail   | 36.56                    |
| 2020 | Shopify  | 179.03                   |


***

# <p align="center" style="margin-top: 0px;">👩‍💻👩‍💻👩‍💻
