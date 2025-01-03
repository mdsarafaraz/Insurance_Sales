USE INSURANCE;
SELECT * FROM BROKERAGE;
SELECT * FROM FEES;
SELECT * FROM INDIVIDUAL_BUDGETS;
SELECT * FROM MEETING;
ALTER TABLE brokerage CHANGE COLUMN `EXE NAME` Exe_Name TEXT(30);
ALTER TABLE BROKERAGE CHANGE COLUMN `Account_EXE_ID` Account_Exe_Id INT;
ALTER TABLE FEES CHANGE COLUMN `ACCOUNT EXE ID` Account_Exe_Id Int;
ALTER TABLE INDIVIDUAL_BUDGETS CHANGE COLUMN `NEW BUDGET` New_Budget double;
ALTER TABLE INDIVIDUAL_BUDGETS CHANGE COLUMN `CROSS SELL BUGDET` Cross_Sell_Budget double;
ALTER TABLE INDIVIDUAL_BUDGETS CHANGE COLUMN `RENEWAL BUDGET` Renewal_Budget double;
ALTER TABLE MEETING CHANGE COLUMN `ACCOUNT EXECUTIVE` Account_Executive TEXT(30);

#COUNT ACTIVE AND INACTIVE POLICY_STATUS:
SELECT COUNT(POLICY_STATUS) AS TOTAL_ACTIVE FROM BROKERAGE
WHERE POLICY_STATUS="ACTIVE";

SELECT COUNT(POLICY_STATUS) AS TOTAL_INACTIVE FROM BROKERAGE
WHERE POLICY_STATUS="INACTIVE";

#CALCULATE THE AMOUNT WITH RESPECT TO PRODUCT_GROUP:
SELECT PRODUCT_GROUP,SUM(AMOUNT) AS AMOUNT FROM BROKERAGE
GROUP BY PRODUCT_GROUP
ORDER BY SUM(AMOUNT) DESC; 

#CALCULATE THE AMOUNT WITH RESPECT TO EXE_NAME:
SELECT EXE_NAME,SUM(AMOUNT) AS AMOUNT FROM BROKERAGE
GROUP BY EXE_NAME
ORDER BY SUM(AMOUNT) DESC;

#CALCULATE ACHIEVED AMOUNT OF CROSS SELL, RENEWAL, NEW:
SELECT * FROM BROKERAGE;
SELECT * FROM FEES;
SELECT B.INCOME_CLASS,F.INCOME_CLASS,(SUM(B.AMOUNT+F.AMOUNT)) AS ACHIEVED_AMOUNT FROM BROKERAGE AS B JOIN FEES AS F
ON B.ACCOUNT_EXE_ID=F.ACCOUNT_EXE_ID
WHERE B.INCOME_CLASS="CROSS SELL" AND F.INCOME_CLASS="CROSS SELL"
GROUP BY B.INCOME_CLASS AND F.INCOME_CLASS;

SELECT B.INCOME_CLASS,SUM(B.AMOUNT+F.AMOUNT) AS ACHIEVED_AMOUNT FROM BROKERAGE AS B JOIN FEES AS F
ON B.ACCOUNT_EXE_ID=F.ACCOUNT_EXE_ID
WHERE B.INCOME_CLASS="RENEWAL" AND F.INCOME_CLASS="RENEWAL"
GROUP BY B.INCOME_CLASS AND F.INCOME_CLASS;

SELECT B.INCOME_CLASS,SUM(B.AMOUNT+F.AMOUNT) AS ACHIEVED_AMOUNT FROM BROKERAGE AS B JOIN FEES AS F
ON B.ACCOUNT_EXE_ID=F.ACCOUNT_EXE_ID
WHERE B.INCOME_CLASS="NEW" AND F.INCOME_CLASS="NEW"
GROUP BY B.INCOME_CLASS AND F.INCOME_CLASS;

#CALCULATE INDIVIDUAL_BUDGETS AMOUNT OF CROSS SELL, RENEWAL, NEW:
SELECT * FROM INDIVIDUAL_BUDGETS;
SELECT SUM(NEW_BUDGET) AS TARGET FROM INDIVIDUAL_BUDGETS;
SELECT SUM(CROSS_SELL_BUDGET) AS TARGET FROM INDIVIDUAL_BUDGETS;
SELECT SUM(RENEWAL_BUDGET) AS TARGET FROM INDIVIDUAL_BUDGETS;

#CALCULATE INVOICE AMOUNT OF CROSS_SELL, RENEWAL, NEW:
SELECT * FROM INVOICE;
SELECT INCOME_CLASS,SUM(AMOUNT) AS AMOUNT FROM INVOICE
GROUP BY INCOME_CLASS HAVING INCOME_CLASS IN ("NEW", "RENEWAL", "CROSS SELL");

#CALCULATE NUMBER OF MEETING BY ACCOUNT EXECUTIVE:
SELECT * FROM MEETING;
SELECT ACCOUNT_EXECUTIVE, COUNT(MEETING_DATE) AS NO_OF_MEETING FROM MEETING
GROUP BY ACCOUNT_EXECUTIVE
ORDER BY NO_OF_MEETING DESC;

#COUNT TOTAL AND OPEN OPPORTUNITY
SELECT * FROM OPPORTUNITY;
SELECT COUNT(STAGE) AS TOTAL_OPPORTUNITIES,(SELECT COUNT(STAGE) FROM OPPORTUNITY
WHERE STAGE NOT IN ("NEGOTIATE")) AS OPEN_OPPORTUNITY FROM OPPORTUNITY;

#CALCULATE OPEN_OPPORTUNITY REVENUE BY PRODUCT_GROUP:
SELECT PRODUCT_GROUP, SUM(REVENUE_AMOUNT) AS REVENUE FROM OPPORTUNITY
WHERE STAGE NOT IN ("NEGOTIATE")
GROUP BY PRODUCT_GROUP
ORDER BY REVENUE DESC;







