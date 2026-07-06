/*==========================================================
        HOTEL BOOKING ANALYSIS USING POSTGRESQL
==========================================================*/

/*----------------------------------------------------------
Question 1:
Which year had the highest total lead time?
----------------------------------------------------------*/

SELECT
    arrival_date_year,
    SUM(lead_time) AS Total_Lead_Time
FROM hotel_bookings
GROUP BY arrival_date_year
ORDER BY Total_Lead_Time DESC;


/*----------------------------------------------------------
Question 2:
How many bookings were checked out and canceled each month?
----------------------------------------------------------*/

SELECT
    arrival_date_month,
    COUNT(CASE WHEN reservation_status = 'Check-Out' THEN 1 END) AS Check_Out,
    COUNT(CASE WHEN reservation_status = 'Canceled' THEN 1 END) AS Canceled
FROM hotel_bookings
GROUP BY arrival_date_month
ORDER BY CASE arrival_date_month
    WHEN 'January' THEN 1
    WHEN 'February' THEN 2
    WHEN 'March' THEN 3
    WHEN 'April' THEN 4
    WHEN 'May' THEN 5
    WHEN 'June' THEN 6
    WHEN 'July' THEN 7
    WHEN 'August' THEN 8
    WHEN 'September' THEN 9
    WHEN 'October' THEN 10
    WHEN 'November' THEN 11
    WHEN 'December' THEN 12
END;


/*----------------------------------------------------------
Question 3:
How many bookings were checked out and canceled each year?
----------------------------------------------------------*/

SELECT
    arrival_date_year,
    COUNT(CASE WHEN reservation_status = 'Check-Out' THEN 1 END) AS Check_Out,
    COUNT(CASE WHEN reservation_status = 'Canceled' THEN 1 END) AS Canceled
FROM hotel_bookings
GROUP BY arrival_date_year;


/*----------------------------------------------------------
Question 4:
Which hotel has the highest total lead time?
----------------------------------------------------------*/

SELECT
    hotel,
    SUM(lead_time) AS Total_Lead_Time
FROM hotel_bookings
GROUP BY hotel;


/*----------------------------------------------------------
Question 5:
Compare canceled and non-canceled bookings for each hotel.
----------------------------------------------------------*/

SELECT
    hotel,
    SUM(CASE WHEN is_canceled = 0 THEN 1 ELSE 0 END) AS Not_Canceled,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS Canceled
FROM hotel_bookings
GROUP BY hotel;


/*----------------------------------------------------------
Question 6:
How many adults and children stayed in each hotel?
----------------------------------------------------------*/

SELECT
    hotel,
    SUM(adults) AS Total_Adults,
    SUM(children) AS Total_Children
FROM hotel_bookings
GROUP BY hotel;


/*----------------------------------------------------------
Question 7:
Which countries generated the highest estimated revenue?
----------------------------------------------------------*/

SELECT
    country,
    ROUND(
        SUM(adr * (stays_in_weekend_nights + stays_in_week_nights))::numeric,
        2
    ) AS Total_Revenue
FROM hotel_bookings
WHERE is_canceled = 0
GROUP BY country
ORDER BY Total_Revenue DESC
LIMIT 10;


/*----------------------------------------------------------
Question 8:
Which customer type generated the highest revenue?
----------------------------------------------------------*/

SELECT
    customer_type,
    ROUND(
        SUM(adr * (stays_in_weekend_nights + stays_in_week_nights))::numeric,
        2
    ) AS Total_Revenue
FROM hotel_bookings
WHERE is_canceled = 0
GROUP BY customer_type
ORDER BY Total_Revenue DESC;


/*----------------------------------------------------------
Question 9:
Which hotel generated the highest revenue?
----------------------------------------------------------*/

SELECT
    hotel,
    ROUND(
        SUM(adr * (stays_in_weekend_nights + stays_in_week_nights))::numeric,
        2
    ) AS Total_Revenue
FROM hotel_bookings
WHERE is_canceled = 0
GROUP BY hotel
ORDER BY Total_Revenue DESC;


/*----------------------------------------------------------
Question 10:
Which month generated the highest revenue?
----------------------------------------------------------*/

SELECT
    arrival_date_month,
    ROUND(
        SUM(adr * (stays_in_weekend_nights + stays_in_week_nights))::numeric,
        2
    ) AS Revenue
FROM hotel_bookings
WHERE is_canceled = 0
GROUP BY arrival_date_month
ORDER BY CASE arrival_date_month
    WHEN 'January' THEN 1
    WHEN 'February' THEN 2
    WHEN 'March' THEN 3
    WHEN 'April' THEN 4
    WHEN 'May' THEN 5
    WHEN 'June' THEN 6
    WHEN 'July' THEN 7
    WHEN 'August' THEN 8
    WHEN 'September' THEN 9
    WHEN 'October' THEN 10
    WHEN 'November' THEN 11
    WHEN 'December' THEN 12
END;


/*----------------------------------------------------------
Question 11:
Which market segment contributes the most revenue?
----------------------------------------------------------*/

SELECT
    market_segment,
    ROUND(
        SUM(adr * (stays_in_weekend_nights + stays_in_week_nights))::numeric,
        2
    ) AS Revenue
FROM hotel_bookings
WHERE is_canceled = 0
GROUP BY market_segment
ORDER BY Revenue DESC;


/*----------------------------------------------------------
Question 12:
Which deposit type has the highest cancellation rate?
----------------------------------------------------------*/

SELECT
    deposit_type,
    COUNT(*) AS Total_Bookings,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS Canceled,
    ROUND(
        (
            SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 100.0
            / COUNT(*)
        )::numeric,
        2
    ) AS Cancellation_Rate
FROM hotel_bookings
GROUP BY deposit_type
ORDER BY Cancellation_Rate DESC;


/*----------------------------------------------------------
Question 13:
Compare repeat guests and new guests based on
bookings, cancellations, and revenue.
----------------------------------------------------------*/

SELECT
    CASE
        WHEN is_repeated_guest = 1 THEN 'Repeat Guest'
        ELSE 'New Guest'
    END AS Guest_Type,
    COUNT(*) AS Total_Bookings,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS Total_Cancellations,
    ROUND(
        SUM(adr * (stays_in_weekend_nights + stays_in_week_nights))::numeric,
        2
    ) AS Revenue
FROM hotel_bookings
GROUP BY Guest_Type;