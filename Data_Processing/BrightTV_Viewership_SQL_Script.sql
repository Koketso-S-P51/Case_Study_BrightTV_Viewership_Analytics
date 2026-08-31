-------------------------------------------------------------------------------

-- Record All records: Viewership

SELECT *
FROM brighttv.bronze.viewership;

----------------------------------------------------------------------------

-- Return all records: user profile

SELECT distinct Channel2

FROM brighttv.bronze.viewership;


-------------------------------------------------------------------------------


----------------------------------------------------------------------------

--Count number of records for viewership table

SELECT COUNT(*)
FROM brighttv.bronze.viewership;

-- Result: 10000 records

-------------------------------------------------------------------------------


-- Duplicate Check: Viewship

SELECT *,
        COUNT(*) AS Dup_Check
FROM brighttv.bronze.viewership
GROUP BY ALL
HAVING COUNT(*)=1;

-- 5 Records have appear more than once

-------------------------------------------------------------------------------

-- Record Distinct records: Viewership

SELECT distinct(*)
FROM brighttv.bronze.viewership;

----------------------------------------------------------------------------

-- Check Null values: Viewership Table

SELECT  *,
        CASE
        WHEN UserID0 IS NULL Then "Missing UserID0"
        WHEN Channel2 IS NULL Then "Missing Channel2"
        WHEN RecordDate2 IS NULL Then "Missing RecordDate2"
        WHEN `Duration 2` IS NULL Then "Missing Duration 2"
        WHEN userid4 IS NULL Then "Missing userid4"
        END AS rejection_reason
FROM brighttv.bronze.viewership
WHERE 
        UserID0 IS NULL
        OR userid4 IS NULL
        OR Channel2 IS NULL 
        OR `Duration 2` IS NULL 
        OR RecordDate2 IS NULL;


-------------------------------------------------------------------------------

SELECT
     -- 'Duration 2',
      DATE_FORMAT(try_cast(`Duration 2` AS timestamp), 'HH:mm:ss') AS Duration_Time
     -- CAST(RecordDate2 AS DATE) AS Record_Date,
     -- DATE_FORMAT(RecordDate2,"HH:mm:ss") AS Record_Time
FROM brighttv.bronze.viewership;

----------------------------------------------------------------------------------------------------

-- Converting the UTC to South Africa  timezone

SELECT 
    UserID0,
    Channel2,
    RecordDate2,
    FROM_UTC_TIMESTAMP(Recorddate2,'Africa/Johannesburg') AS RecordDate_SAST,
    TO_DATE(FROM_UTC_TIMESTAMP(Recorddate2,'Africa/Johannesburg')) AS Record_Date,
    DATE_FORMAT(FROM_UTC_TIMESTAMP(Recorddate2,'Africa/Johannesburg'),'HH:mm:ss') AS Record_Time,
    DATE_FORMAT(FROM_UTC_TIMESTAMP(Recorddate2,'Africa/Johannesburg'),'HH:00') AS Record_Time,
    DATE_FORMAT(try_cast(`Duration 2` AS timestamp), 'HH:mm:ss') AS Duration_Time
FROM Brighttv.bronze.viewership;


-------------------------------------------------------------------------------------------------

---- Create Channel Category


SELECT Channel2,
       UPPER (CASE
                WHEN UPPER(TRIM(Channel2)) IN ('SUPERSPORT LIVE EVENTS', 'SUPERSPORT BLITZ','ICC CRICKET WORLD CUP 2011','DSTV EVENTS 1','WIMBLEDON','LIVE ON SUPERSPORT') THEN 'SPORTS'
                WHEN UPPER(TRIM(Channel2)) IN ('TRACE TV','CHANNEL O','VUZU') THEN 'MUSIC'
                WHEN UPPER(TRIM(Channel2)) IN ('CARTOON NETWORK','BOOMERANG') THEN 'KIDS'
                WHEN UPPER(TRIM(Channel2)) IN ('M-NET','AFRICA MAGIC','E! ENTERTAINMENT','KYKNET','SAWSEE') THEN 'ENTERTAINMENT'
                WHEN UPPER(TRIM(Channel2)) IN ('CNN') THEN 'NEWS'
                ELSE 'OTHER'  END ) AS Channel_Category
FROM brighttv.bronze.viewership;




-------------------------------------------------------------------------------------------------

---- Create Session Grouping


SELECT DATE_FORMAT(try_cast(RecordDate2 AS timestamp), 'HH:mm:ss') AS Record_Time,  ---Try_cast because string could not 
       CASE
                WHEN Record_Time BETWEEN '00:00:00' AND '05:59:99' THEN "Night: 12am-6am"
                WHEN Record_Time BETWEEN '06:00:00' AND '11:59:99' THEN "Morning: 6am-12pm"
                WHEN Record_Time BETWEEN '12:00:00' AND '17:59:99' THEN "Afternoon: 12pm-6pm"
                WHEN Record_Time BETWEEN '18:00:00' AND '23:59:99' THEN "Evening: 6pm-12am"
                ELSE ""
                END AS Record_Time_Bucket
FROM brighttv.bronze.viewership;






-------------------------------------------------------------------------------------------------

---- Create viewership Table

SELECT DISTINCT(*),
    Channel2,
    UPPER (CASE
                WHEN UPPER(TRIM(Channel2)) IN ('SUPERSPORT LIVE EVENTS', 'SUPERSPORT BLITZ','ICC CRICKET WORLD CUP 2011','DSTV EVENTS 1','WIMBLEDON','LIVE ON SUPERSPORT') THEN 'SPORTS'
                WHEN UPPER(TRIM(Channel2)) IN ('TRACE TV','CHANNEL O','VUZU') THEN 'MUSIC'
                WHEN UPPER(TRIM(Channel2)) IN ('CARTOON NETWORK','BOOMERANG') THEN 'KIDS'
                WHEN UPPER(TRIM(Channel2)) IN ('M-NET','AFRICA MAGIC','E! ENTERTAINMENT','KYKNET','SAWSEE') THEN 'ENTERTAINMENT'
                WHEN UPPER(TRIM(Channel2)) IN ('CNN') THEN 'NEWS'
                ELSE 'OTHER'  END ) AS Channel_Category,
    RecordDate2,
    FROM_UTC_TIMESTAMP(Recorddate2,'Africa/Johannesburg') AS SA_Time,
    TO_DATE(FROM_UTC_TIMESTAMP(Recorddate2,'Africa/Johannesburg')) AS Record_Date,
    DAYNAME(TO_DATE(FROM_UTC_TIMESTAMP(Recorddate2,'Africa/Johannesburg')) ) AS Day_Name_Record,
    MONTHNAME(TO_DATE(FROM_UTC_TIMESTAMP(Recorddate2,'Africa/Johannesburg')) ) AS MonthName_Record,
    DATE_FORMAT(FROM_UTC_TIMESTAMP(Recorddate2,'Africa/Johannesburg'),'HH:mm:ss') AS Record_Time,
    CASE
                WHEN Record_Time BETWEEN '00:00:00' AND '05:59:99' THEN "Night: 12am-6am"
                WHEN Record_Time BETWEEN '06:00:00' AND '11:59:99' THEN "Morning: 6am-12pm"
                WHEN Record_Time BETWEEN '12:00:00' AND '17:59:99' THEN "Afternoon: 12pm-6pm"
                WHEN Record_Time BETWEEN '18:00:00' AND '23:59:99' THEN "Evening: 6pm-12am"
                ELSE ""
                END AS Record_Time_Bucket,
    DATE_FORMAT(FROM_UTC_TIMESTAMP(Recorddate2,'Africa/Johannesburg'),'HH') AS Hour_of_Day,
    DATE_FORMAT(try_cast(`Duration 2` AS timestamp), 'HH:mm:ss') AS Duration_Time,
    ((HOUR(try_cast(`Duration 2` AS timestamp)))+((MINUTE(try_cast(`Duration 2` AS timestamp)))/60.0) + ((SECOND(try_cast(`Duration 2` AS timestamp))) / 3600.0)) AS Duration_Hours
  
FROM brighttv.bronze.viewership;


--------------------------------------------------------------------------------------