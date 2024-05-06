
# <p align="center" style="margin-top: 0px;"> 💰 Case Study #4 - Data Bank 💰
## <p align="center"> A. Customer Nodes Exploration

## Solution

View the complete syntax [*here*](https://github.com/erisaxhelilaj/my_portofolio/blob/main/%234%20-%20Data%20Bank/questions.sql).



### 1. How many unique nodes are there on the Data Bank system?
```sql
select
   count(distinct node_id) as unique_node_count
from data_bank.customer_nod
```
#### Steps:
 - Using `distinct` to eliminate duplicate rows from the result and return only unique rows from the selected column    *customer_nodes* 
 - Using `count()`to return the number of unique nodes

#### Answer
| unique_node_count |
| ----------------- |
| 5                 |


- There are 5 unique nodes on the Data Bank system.

<hr/>

### 2. What is the number of nodes per region?
```sql
          select
            a.region_name as region_name
          , count(distinct node_id) as unique_nodes
          , count(node_id) as number_of_nodes
        from data_bank.regions as a
        left join data_bank.customer_nodes as b on a.region_id = b.region_id
        group by 1
        order by 3 desc
```
#### Steps:
 - Joins the `regions` table with the `customer_nodes` table on `region_id`.
 - Groups the results by `region_name`. 
 - Counts the distinct `node_id` for each `region_name`and `ORDER BY` in **descending order**

#### Answer
| region_name | unique_nodes | number_of_nodes |
| ----------- | ------------ | --------------- |
| Australia   | 5            | 770             |
| America     | 5            | 735             |
| Africa      | 5            | 714             |
| Asia        | 5            | 665             |
| Europe      | 5            | 616             |

- Each region has 5 unique nodes with the highest number of nodes located in Australia (770 nodes)

<hr/>

### 3. How many customers are allocated to each region?
```sql
        select
            count(distinct customer_id)as num_customer 
        , region_name 
        from data_bank.customer_nodes as a 
        left join data_bank.regions as b on a.region_id = b.region_id
        group by 2
```
#### Steps:
 - Joining the `regions` and `customer_nodes` tables on the `region_id` field.
 - Grouping the results by `region_name`.
 - Counting the distinct `customer_id` for each group, which provides the number of unique customers in each region.
 
#### Answer
| num_customer | region_name |
| ------------ | ----------- |
| 102          | Africa      |
| 105          | America     |
| 95           | Asia        |
| 110          | Australia   |
| 88           | Europe      |

- Africa has 102 customers.
- America has 105 customers.
- Asia has 95 customers.
- Australia has 110 customers.
- Europe has 88 customers.

<hr/>

### 4. How many days on average are customers reallocated to a different node?

```sql
        select
            avg(end_date -start_date) as average
        from data_bank.customer_nodes
        where end_date != '99991231';
```
#### Steps:
 - (`end_date - start_date`): This calculates the duration in days for each row in the `customer_nodes table`.
 - Average Calculation (`AVG`): The average function computes the mean of all these durations to give a single average value.

#### Answer
| average             |
| ------------------- |
| 14.6340000000000000 |

- The average number of days customers are reallocated to a different node is 14.63 days.


<hr/>

### 5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

```sql

```
#### Steps:
-`
- 
-


#### Answer
| customer_id | product_name | number_of_order|
| ----------- | ------------ | -------------- |
|     A       |    ramen     |       3        |
|     B       |    sushi     |       3        |
|     C       |    ramen     |       3        |

<hr/>

