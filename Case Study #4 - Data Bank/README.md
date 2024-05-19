# <p align="center" style="margin-top: 0px;">💰 Case Study #4 - Data Bank 💰

<p align="center" style="margin-bottom: 0px !important;">
  <img src="https://user-images.githubusercontent.com/43850912/144242375-fa0e601d-ef17-467d-ac70-282a26a2e181.png" width="540" height="540">

## 🧾 Table of Contents
- [Business Case](#business-case)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Available Data](#available-data)
- [Case Study Questions](#case-study-questions)
- Solution: [GitHub](https://github.com/erisaxhelilaj/8-Week-SQL-Challenge/tree/main/Case%20Study%20%234%20-%20Data%20Bank/Scripts)

    
***

## Business Case
  
Another initiative from Danny - Bank Data - some sort of intersection between Neo-Banks 
  (new aged digital only banks without physical branches), cryptocurrency and the data world.

The management team at Data Bank want to increase their total customer base - but also need some help tracking just how much data storage their customers will need.
  **Calculating metrics, growth and analyse data to better forecast and plan for their future developments!**

***
    
## Entity Relationship Diagram
<p align="center" style="margin-bottom: 0px !important;">
  <img src="https://user-images.githubusercontent.com/43850912/144242445-521d1efb-3e05-4f39-87b0-63f468aaa374.png">

***

## Available Data
  
<details><summary>
    All datasets exist in database schema.
  </summary> 
  
 #### ``Table 1: Regions``
region_id | region_name
-- | --
1 | Africa
2 | America
3 | Asia
4 | Europe
5 | Oceania

#### ``Table 2: Customer Nodes``
*Note: this is only customer sample*
customer_id | region_id | node_id | start_date | end_date
-- | -- | -- | -- | --
1 | 3 | 4 | 2020-01-02 | 2020-01-03
2 | 3 | 5 | 2020-01-03 | 2020-01-17
3 | 5 | 4 | 2020-01-27 | 2020-02-18
4 | 5 | 4 | 2020-01-07 | 2020-01-19
5 | 3 | 3 | 2020-01-15 | 2020-01-23
6 | 1 | 1 | 2020-01-11 | 2020-02-06
7 | 2 | 5 | 2020-01-20 | 2020-02-04
8 | 1 | 2 | 2020-01-15 | 2020-01-28
9 | 4 | 5 | 2020-01-21 | 2020-01-25
10 | 3 | 4 | 2020-01-13 | 2020-01-14

#### ``Table 3: Customer Transactions``
*Note: this is only customer sample*
customer_id | txn_date | txn_type | txn_amount
-- | -- | -- | --
429 | 2020-01-21 | deposit | 82
155 | 2020-01-10 | deposit | 712
398 | 2020-01-01 | deposit | 196
255 | 2020-01-14 | deposit | 563
185 | 2020-01-29 | deposit | 626
309 | 2020-01-13 | deposit | 995
312 | 2020-01-20 | deposit | 485
376 | 2020-01-03 | deposit | 706
188 | 2020-01-13 | deposit | 601
138 | 2020-01-11 | deposit | 520

  </details>

***

## Case Study Questions
<details><summary>
Each of the following case study questions can be answered using a single SQL statement.
</summary> 

<details><summary>
  A. Customer Nodes Exploration</summary>
  
1. How many unique nodes are there on the Data Bank system?
2. What is the number of nodes per region?
3. How many customers are allocated to each region?
4. How many days on average are customers reallocated to a different node?
5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
</details>
  
<details><summary>
  B. Customer Transactions</summary>
  
1. What is the unique count and total amount for each transaction type?
2. What is the average total historical deposit counts and amounts for all customers?
3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
4. What is the closing balance for each customer at the end of the month?
5. What is the percentage of customers who increase their closing balance by more than 5%?
</details>

***

# <p align="center" style="margin-top: 0px;">👩‍💻👩‍💻👩‍💻
