# :bank: #4 Data Bank

## Solution



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
```select
            a.region_name as region_name
          , count(distinct node_id) as count_node
        from data_bank.regions as a
        left join data_bank.customer_nodes as b on a.region_id = b.region_id
        group by 1
```
#### Steps:
 - Joins the `regions` table with the `customer_nodes` table on `region_id`.
 - Groups the results by `region_name`. 
 - Counts the distinct `node_id` for each `region_name`.

#### Answer
| customer_id |  nr_visits  |
| ----------- | ----------- |
|      A      |       4     |
|      B      |       6     |
|      C      |       2     |

- Customer A visited the restaurant 4 days
- Customer B visited the restaurant 6 days
- Customer C visited the restaurant 2 days

<hr/>

### 3. What was the first item from the menu purchased by each customer?
```sql
WITH CTE_ranked_sales AS(
		SELECT customer_id, order_date, product_name,
		DENSE_RANK() OVER(PARTITION BY S.customer_id
		ORDER BY S.order_date) AS ranked_products
		FROM sales AS S
		JOIN menu AS M
		ON S.product_id = M.product_id
)

SELECT  customer_id, product_name
FROM CTE_ranked_sales
WHERE ranked_products = 1
GROUP BY customer_id, product_name;
```
#### Steps:
 - Creating a CTE table `(CTE_ranked_sales)` using a window function, `DENSE_RANK` to create a ranking column based on the `customer_id` and ordered by the `order_date`
 - Using `DENSE_RANK`, because a customer might have ordered more than one item in the same day
 - From the table created, we take the columns needed where the `ranked_products` = 1
 
#### Answer
| customer_id | product_name |
| ----------- | ------------ |
|      A      |    curry     |
|      A      |    sushi     |
|      B      |    curry     |
|      C      |    ramen     |

- Customer A's first choices are curry and sushi
- Customer B's first choice is curry
- Customer C's first choice is ramen

<hr/>

### 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

```sql
SELECT TOP 1 M.product_name, COUNT(S.customer_id) AS number_of_purchased
FROM sales AS S
JOIN menu AS M
ON S.product_id = M.product_id
GROUP BY M.product_name
ORDER BY number_of_purchased DESC;
```
#### Steps:
 - Using `COUNT()` to find the number of each item purchased and `ORDER BY` in **descending order**
 - `TOP 1` will output the first product

#### Answer
| product_name | number_of_purchased |
| ------------ | ------------------- |
|     ramen    |          8          |

<hr/>

### 5. Which item was the most popular for each customer?

```sql
WITH CTE_nrOrders AS (
	SELECT S.customer_id, M.product_name, COUNT(M.product_id) AS number_of_orders,
	ROW_NUMBER() OVER(partition by S.customer_id ORDER BY COUNT(M.product_id) DESC) AS rn
	FROM sales AS S
	JOIN menu AS M
	ON S.product_id = M.product_id
	GROUP BY S.customer_id, product_name
)

SELECT customer_id, product_name, number_of_orders
FROM CTE_nrOrders
WHERE rn = 1;
```
#### Steps:
- Create a CTE table `CTE_nrOrders`, inside of which we join the `sales` and `menu` table using the `product_key`
- Use of the aggregate function **COUNT()** to get the number of the products purchased by each client
- We use the **Window Function**, `ROW_NUMBER()` to get the ranking of each customer based on the count of orders


#### Answer
| customer_id | product_name | number_of_order|
| ----------- | ------------ | -------------- |
|     A       |    ramen     |       3        |
|     B       |    sushi     |       3        |
|     C       |    ramen     |       3        |

<hr/>

### 6. Which item was purchased first by the customer after they became member?

```sql
WITH CTE_firstOrderMember AS (
	SELECT S.customer_id, M1.product_name, S.order_date,
	ROW_NUMBER() OVER(PARTITION BY S.customer_id ORDER BY S.order_date) AS rn
	FROM sales AS S
	JOIN menu AS M1
	ON S.product_id = M1.product_id
	JOIN members AS M2
	ON S.customer_id = M2.customer_id
	WHERE S.order_date >= M2.join_date
)
SELECT customer_id, product_name
FROM CTE_firstOrderMember
WHERE rn = 1;
```
#### Steps:
- Created a CTE table, `CTE_firstOrderMemeber`, inside of which I have used the **Row_Number()** window function to create a rank of the customers
partitioned by the `customer_id` and ordered by `order_date`
- Joined the tables `sales` and `menu` on `customer_id` column
- Add the condition where the `order_date` >= `join_date` as we need the products purchased after becoming e member.

#### Answer
| customer_id |	product_name |
| ----------- | ------------ |
|      A      |    ramen     |
|      B      |    sushi     |

<hr/>

### 7. Which item was purchased just before the customer became a member?

```sql
WITH CTE_FirstOrderBeforeMember AS (
	SELECT S.customer_id, M1.product_name, S.order_date, 
	DENSE_RANK() OVER(PARTITION BY S.customer_id ORDER BY S.order_date DESC) AS ranking
	FROM sales AS S
	JOIN menu AS M1
	ON S.product_id = M1.product_id
	JOIN members AS M2
	ON S.customer_id = M2.customer_id
	WHERE S.order_date < M2.join_date
)

SELECT customer_id, product_name
FROM CTE_FirstOrderBeforeMember
WHERE ranking = 1
```

#### Answer
| customer_id |	product_name |
| ----------- | ------------ |
|      A      |    sushi     |
|      B      |    sushi     |

<hr/>

### 8. What is the total items and amound spent for each member before they became a member?

```sql
SELECT S.customer_id, COUNT(M1.product_id) AS total_orders, SUM(M1.price) AS total_amount
FROM sales AS S
JOIN menu AS M1
ON S.product_id = M1.product_id
JOIN members AS M2
ON S.customer_id = M2.customer_id
WHERE S.order_date < M2.join_date
GROUP BY S.customer_id;
```

#### Steps:
- Selecting the `customer_id` and using the **COUNT()** function to get the total number of items purchased, 
**SUM()** function to get the total price.
- Joining the tables `sales` and `menu` on `product_id` column, and then with `members` on `customer_id` column
- The condition should be `order_date` < `join_date`

#### Answer:
| customer_id | total_orders | total_amount |
| ----------- | ------------ | ------------ |
|      A      |     2        |      25      |
|      B      |     3        |      40      |

<hr/>

### 9. If each $1 spent equates to 10 points and sushi has sx points multiplier - how many points would each customer have?

```sql
WITH CTE_points AS (
	SELECT S.customer_id, M.product_name, M.price,
	CASE
		WHEN M.product_name = 'sushi' THEN 20 * price
		ELSE 10 * price
	END AS points_collected
	FROM sales AS S
	JOIN menu AS M
	ON S.product_id = M.product_id
)
 SELECT customer_id, SUM(points_collected) AS points
 FROM CTE_points
 GROUP BY customer_id;
 ```
 
 #### Steps:
 - Creating a CTE table, `CTE_points` where we join the tables `sales` and `menu` on `product_id`
 - Inside the CTE table, create a new column using **CASE WHEN** to get te number of points
 - In the end we select the `customer_id` and use the **SUM()** function to get the total number of the points collected

#### Answer:
| customer_id |	points_collected |
| ----------- | ---------------- |
|      A      |    860           |
|      B      |    940           |
|      C      |    360           |

<hr/>

### 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

```sql
WITH CTE_dates AS (
		SELECT *,
			   DATEADD(day, 6, join_date) AS valid_date,
			   EOMONTH('2021-01-31') AS last_date
		FROM members 
)

SELECT d.customer_id,
		SUM(CASE WHEN m.product_name = 'sushi' THEN 20 * m.price
		         WHEN s.order_date between d.join_date AND d.valid_date THEN 20 * m.price
		         ELSE 10 * m.price END) AS total_points
FROM CTE_dates as d
JOIN sales AS s 
ON  d.customer_id = s.customer_id
JOIN menu AS m 
ON s.product_id = m.product_id
WHERE s.order_date <= d.last_date
GROUP BY d.customer_id;
```
#### Answer:
| customer_id |	total_points     |
| ----------- | ---------------- |
|      A      |    1370          |
|      B      |    820           |

