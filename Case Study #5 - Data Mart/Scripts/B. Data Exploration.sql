--1. What day of the week is used for each week_date value?
    select
        week_date
    , to_char(week_date, 'Day') as day_name
    from data_mart.clean_weekly_sales;

--2. What range of week numbers are missing from the dataset?

    with all_weeks as (
            select 
                generate_series(1, 52) as week_number
        ),

        existing_weeks as (
            select distinct num_week as week_number
            from  data_mart.clean_weekly_sales
        )
        select 
        count(a.week_number) as missing_weeks_count
        from all_weeks a
        left join existing_weeks as e on a.week_number = e.week_number
        where e.week_number is null;

--3. How many total transactions were there for each year in the dataset?

        select
            year 
        , sum(transactions) as total_transactions
        from data_mart.clean_weekly_sales
        group by year
        order by year;

--4. What is the total sales for each region for each month?

        select 
            region
            , month
            , sum (sales) as total_sales
        from  data_mart.clean_weekly_sales
        group by  region, month
        order by  region, month;

--5. What is the total count of transactions for each platform?

        select 
            platform
        , sum(transactions) as total_transactions
        from  data_mart.clean_weekly_sales
        group by platform  
        order by  platform; 

--6. What is the percentage of sales for Retail vs Shopify for each month?

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
            
            group by  extract(month from week_date),  extract(year from week_date), platform     
        ) as subquery
        order by year, month,  platform;

--7. What is the percentage of sales by demographic for each year in the dataset?

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

--8. Which age_band and demographic values contribute the most to Retail sales?

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
            from 
                data_mart.clean_weekly_sales
            where 
                platform = 'Retail'
            group by 
                age_band,
                demographic
        ) as subquery
        order by 
            total_sales desc;

--9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify?

        select 
            extract(year from week_date) as year,
            platform,
            round(sum(sales)::numeric / sum(transactions)::numeric, 2) as average_transaction_size
        from data_mart.clean_weekly_sales   
        where platform in ('Retail', 'Shopify')  
        group by  extract(year from week_date), platform
        order by  year,  platform;
            