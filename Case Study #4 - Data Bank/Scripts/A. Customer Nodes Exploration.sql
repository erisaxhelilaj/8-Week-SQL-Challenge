---------------------
 ----A. Customer Nodes Exploration-----
---------------------

--How many unique nodes are there on the Data Bank system?
        select
        count(distinct node_id) as unique_node_count
        from data_bank.customer_nodes


--What is the number of nodes per region?
        select
            a.region_name as region_name
          , count(distinct node_id) as count_node
        from data_bank.regions as a
        left join data_bank.customer_nodes as b on a.region_id = b.region_id
        group by 1
        order by 2 desc

--How many customers are allocated to each region?
        select
                    count(distinct customer_id)as num_customer 
                , region_name 
                from data_bank.customer_nodes as a 
                left join data_bank.regions as b on a.region_id = b.region_id
                group by 2

--How many days on average are customers reallocated to a different node?
