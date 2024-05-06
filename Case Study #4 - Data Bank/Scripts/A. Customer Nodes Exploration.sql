---------------------
 ----A. Customer Nodes Exploration-----
---------------------

--1. How many unique nodes are there on the Data Bank system?
        select
        count(distinct node_id) as unique_node_count
        from data_bank.customer_nodes


--2. What is the number of nodes per region?
         select
            a.region_name as region_name
          , count(distinct node_id) as unique_nodes
          , count(node_id) as number_of_nodes
        from data_bank.regions as a
        left join data_bank.customer_nodes as b on a.region_id = b.region_id
        group by 1
        order by 3 desc

--3. How many customers are allocated to each region?
        select
                    count(distinct customer_id)as num_customer 
                , region_name 
                from data_bank.customer_nodes as a 
                left join data_bank.regions as b on a.region_id = b.region_id
                group by 2

--4. How many days on average are customers reallocated to a different node?
        select
            avg(end_date -start_date) as average
        from data_bank.customer_nodes
        where end_date != '99991231';


--5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?