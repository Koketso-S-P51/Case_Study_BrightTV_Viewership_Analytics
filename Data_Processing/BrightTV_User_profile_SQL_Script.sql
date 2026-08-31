
-------------------------------------------------------------------------------

-- Return all records: user profile

SELECT *
FROM brighttv.bronze.user_profiles;


-------------------------------------------------------------------------------





-- Count number of records for user profile table

SELECT COUNT(*)
FROM brighttv.bronze.user_profiles;

-- Round Count: 5375

-------------------------------------------------------------------------------


-- Duplicate Check: Username

SELECT *,
        COUNT(*) AS Dup_Check
FROM brighttv.bronze.user_profiles
GROUP BY ALL
HAVING COUNT(*)>1;

-- No duplicates, only unique values

-------------------------------------------------------------------------------

--- Check Null Values : User Profile Table

SELECT  *,
        CASE
        WHEN UserID IS NULL Then "Missing UserID"
        WHEN Name IS NULL Then "Missing Name"
        WHEN Surname IS NULL Then "Missing Surname"
        WHEN Email IS NULL Then "Missing Email"
        WHEN Gender IS NULL Then "Missing Gender"
        WHEN Race IS NULL Then "Missing Race"
        WHEN Age IS NULL Then "Missing Age"
        WHEN Province IS NULL Then "Missing Province"
        WHEN `Social Media Handle` IS NULL Then "Missing Social Media Handle"
        END AS rejection_reason
FROM brighttv.bronze.user_profiles
WHERE 
        UserID IS NULL
        OR Name IS NULL
        OR Surname IS NULL 
        OR Email IS NULL 
        OR Gender IS NULL 
        OR Race IS NULL 
        OR Age IS NULL 
        OR Province IS NULL 
        OR `Social Media Handle` IS NULL;

---No NULL on the User profiles

---------------------------------------------------------------------------------



-- Record All records: Viewership

SELECT *
FROM brighttv.bronze.viewership;

-------------------------------------------------------------------------------

-- Return all records: user profile

SELECT *
FROM brighttv.bronze.user_profiles;



-------------------------------------------------------------------------------

-- Count number of records for user profile table

SELECT COUNT(*)
FROM brighttv.bronze.user_profiles;

-- Round Count: 5375

-------------------------------------------------------------------------------


-- Duplicate Check: User Profile


SELECT *,
        COUNT(*) AS Dup_Check
FROM brighttv.bronze.user_profiles
GROUP BY ALL
HAVING COUNT(*)>1;

-- No duplicates, only unique values

-------------------------------------------------------------------------------

--- Check Empty Strings and None Values : User Profile Table

SELECT  *,
        CASE
        WHEN TRIM(UserID) = '' Then "Empty: UserID"
        WHEN Name = "None" Then "None: Name"   --None Check
        WHEN TRIM(Name) = '' Then "Empty: Name" --Empty String Check
        WHEN Surname = "None" Then "None: Surname"
        WHEN TRIM(Surname) = '' Then "Empty: Surname"
        WHEN Email = "None" Then "None: Email"
        WHEN TRIM(Email) = '' Then "Empty: Email"
        WHEN Gender = "None" Then "None: Gender"
        WHEN TRIM(Gender) = '' Then "Empty: Gender"
        WHEN Race = "None" Then "None: Race"
        WHEN TRIM(Race) = '' Then "Empty: Race"
        WHEN Age IS NULL Then "Missing Age"
        WHEN Province = 'None' Then "None: Province"
        WHEN TRIM(Province) = '' Then "Empty: Province" 
        WHEN `Social Media Handle` IS NULL Then "Missing Social Media Handle"
        END AS rejection_reason
FROM brighttv.bronze.user_profiles
WHERE 
        UserID IS NULL
        OR Name = "None" OR TRIM(Name) = ''
        OR Surname = "None" OR TRIM(Surname) = ''
        OR Email = "None" OR TRIM(Email) = ''
        OR Gender = "None" OR TRIM(Gender) = ''
        OR Race = "None" OR TRIM(Race) = ''
        OR Age IS NULL 
        OR Province = "None"  OR TRIM(Province) = ''
        OR `Social Media Handle` = "None" OR TRIM(`Social Media Handle`) = '';



---------------------------------------------------------------------------------


--- Count of None(null) and Blank values

SELECT 'Name' AS Column_Names,   
        SUM(CASE WHEN TRIM(Name) = '' THEN 1 ELSE 0 END) AS Blank_Count,
        SUM(CASE WHEN (Name = 'None') THEN 1 ELSE 0 END) AS None_Count,
        SUM(CASE WHEN (Name = 'None' OR TRIM(Name) = '') THEN 1 ELSE 0 END) AS Total_Issues,
        COUNT(*) AS Total_Rows
FROM brighttv.bronze.user_profiles

UNION ALL

SELECT 'Surname', 
        SUM(CASE WHEN TRIM(Surname) = '' THEN 1 ELSE 0 END),
        SUM(CASE WHEN (Surname = 'None') THEN 1 ELSE 0 END),
        SUM(CASE WHEN (Surname = 'None' OR TRIM(Surname) = '') THEN 1 ELSE 0 END),
        COUNT(*)
FROM brighttv.bronze.user_profiles

UNION ALL

SELECT 'Email', 
        SUM(CASE WHEN TRIM(Email) = '' THEN 1 ELSE 0 END),
        SUM(CASE WHEN (Email = 'None') THEN 1 ELSE 0 END),
        SUM(CASE WHEN (Email = 'None' OR TRIM(Email) = '') THEN 1 ELSE 0 END),
        COUNT(*)
FROM brighttv.bronze.user_profiles

UNION ALL

SELECT 'Gender', 
        SUM(CASE WHEN TRIM(Gender) = '' THEN 1 ELSE 0 END),
        SUM(CASE WHEN (Gender = 'None') THEN 1 ELSE 0 END),
        SUM(CASE WHEN (Gender = 'None' OR TRIM(Gender) = '') THEN 1 ELSE 0 END),
        COUNT(*)
FROM brighttv.bronze.user_profiles

UNION ALL

SELECT 'Race', 
        SUM(CASE WHEN TRIM(Race) = '' THEN 1 ELSE 0 END),
        SUM(CASE WHEN (Race = 'None') THEN 1 ELSE 0 END),
        SUM(CASE WHEN (Race = 'None' OR TRIM(Race) = '') THEN 1 ELSE 0 END),
        COUNT(*)
FROM brighttv.bronze.user_profiles

UNION ALL

SELECT 'Province', 
        SUM(CASE WHEN TRIM(Province) = '' THEN 1 ELSE 0 END),
        SUM(CASE WHEN (Province = 'None') THEN 1 ELSE 0 END),
        SUM(CASE WHEN (Province = 'None' OR TRIM(Province) = '') THEN 1 ELSE 0 END),
        COUNT(*)
FROM brighttv.bronze.user_profiles

UNION ALL

SELECT 'Social Media Handle', 
        SUM(CASE WHEN TRIM(`Social Media Handle`) = '' THEN 1 ELSE 0 END),
        SUM(CASE WHEN (`Social Media Handle` = 'None') THEN 1 ELSE 0 END),
        SUM(CASE WHEN (`Social Media Handle` = 'None' OR TRIM(`Social Media Handle`) = '') THEN 1 ELSE 0 END),
        COUNT(*)
FROM brighttv.bronze.user_profiles

ORDER BY Total_Rows;



--------------------------------------------------------------------------------------------------------

-- Create Silver Table for user profile table

SELECT * EXCEPT(Gender,Race,Age,Province),
        UPPER(CASE 
            WHEN Gender = "None" THEN "Unknown" 
            WHEN TRIM(Gender) = "" THEN "Unknown"
            ELSE Gender END) AS Gender,
        UPPER(CASE 
            WHEN Province = "None" THEN "Unknown" 
            WHEN TRIM(Province) = '' THEN "Unknown"
            ELSE Province END) AS Province,
        UPPER(CASE 
            WHEN Race = "None" THEN "Unknown" 
            WHEN TRIM(Race) = "" THEN "Unknown"
            ELSE Race END) AS Race,
        Age,
        CASE
            
            WHEN Age < 18       THEN '<18'
            WHEN Age BETWEEN 18 AND 24 THEN '18-24'
            WHEN Age BETWEEN 25 AND 34 THEN '25-34'
            WHEN Age BETWEEN 35 AND 44 THEN '35-44'
            WHEN Age BETWEEN 45 AND 54 THEN '45-54'
            WHEN Age  >=55      THEN '55+'
            WHEN Age = 0        THEN 'Unknown'
            ELSE ""
        END AS age_bucket,
        CASE
            WHEN Age < 18       THEN '1'
            WHEN Age BETWEEN 18 AND 24 THEN '2'
            WHEN Age BETWEEN 25 AND 34 THEN '3'
            WHEN Age BETWEEN 35 AND 44 THEN '4'
            WHEN Age BETWEEN 45 AND 54 THEN '5'
            WHEN Age  >=55      THEN '6'
            WHEN Age = 0        THEN '7'
            ELSE ""
        END AS Sort_Order_age_bucket 
         
FROM brighttv.bronze.user_profiles
WHERE NOT ( Name = "None" AND Surname = "None");
