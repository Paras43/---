SELECT * FROM GE.indicators
order by EMPLOYEE_ID
limit 20;
##  Check the missing values.
# c1
select nullif(EMPLOYEE_ID,'') from alert_indicators_with_demographics;
select * from alert_indicators_with_demographics
where EMPLOYEE_ID is null; 
select nullif(EMPLOYEE_ID,'#N/A')from alert_indicators_with_demographics;# EMPLOYEE_ID has no empty space & null value.
# c2
select nullif(TYPE_NAME,'') from alert_indicators_with_demographics;
select * from alert_indicators_with_demographics
where TYPE_NAME is null;
select nullif(TYPE_NAME,'#N/A')from alert_indicators_with_demographics; # TYPE_NAME has no empty space, N/A, & null value.
# c4
select nullif(ALERT_ID_FK,'') from alert_indicators_with_demographics;
select * from alert_indicators_with_demographics
where ALERT_ID_FK is null;
select nullif(ALERT_ID_FK,'#N/A')from alert_indicators_with_demographics;
update alert_indicators_with_demographics
set ALERT_ID_FK = coalesce(nullif(ALERT_ID_FK,'#N/A'),null); # replace the N/A with null value.
select count(ALERT_ID_FK) from alert_indicators_with_demographics; # 10.4% missing rate. 641
# c6 
select * from alert_indicators_with_demographics
where SCORE is null;
select nullif(SCORE,'') from alert_indicators_with_demographics;
select nullif(SCORE,'#N/A')from alert_indicators_with_demographics;
select count(SCORE) from alert_indicators_with_demographics; # no missing value.
# STATUS 
select count(STATUS) from indicators;
select nullif(EMPLOYEE_ID,'') from indicators; # no missing values in STATUS.


##### Analysis #####
select count(distinct EMPLOYEE_ID) from indicators; # 132 different employees involved.
select count(EMPLOYEE_ID) from indicators; # 6858 records.

select distinct(TYPE_NAME) from indicators; # There are four different kinds of types: FP, TP, TP/low, TP/High.
select TYPE_NAME, count(TYPE_NAME)as Type_count from indicators
group by TYPE_NAME
order by Type_count DESC; # 10.8% error & The probability of high risk: (1-0.108)*0.0083=0.74%

select EMPLOYEE_ID, count(RISK_FACTOR) as Factor_count from indicators
group by EMPLOYEE_ID 
having count(RISK_FACTOR >1)
order by Factor_count DESC;

select INDICATORS, count(MALICIOUS) as M_count from indicators
group by ALERT_ID_FK 
having count(MALICIOUS='yes')
order by M_count DESC; 

select MALICIOUS, count(MALICIOUS) as m_count from indicators
group by MALICIOUS
order by m_count;

select INDICATORS,count(INDICATORS) as Ins_count from indicators
group by INDICATORS
order by Ins_count DESC;

select distinct(STATUS) from indicators
where TYPE_NAME = 'FP'; # All FP,TP has been cleared
select distinct(STATUS) from indicators
where TYPE_NAME = 'TP';
select STATUS,count(STATUS) as stat_count from indicators
where TYPE_NAME = 'TP/Low'
group by STATUS
order by stat_count; # 499 not cleared, 8 cleared
select STATUS,count(STATUS) as stat_count from indicators
where TYPE_NAME = 'TP/High'
group by STATUS
order by stat_count; # all 51 not cleared


### Analysis of Indicators
select distinct(INDICATORS) from indicators; # 57 different indicators in total
select INDICATORS, count(INDICATORS) as IND_count from indicators 
where (TYPE_NAME = 'TP/HIGH' or TYPE_NAME = 'TP/LOW') and STATUS = 'confirmed'
group by INDICATORS
order by IND_count DESC;
select INDICATORS, count(INDICATORS) as IND_count from indicators 
where TYPE_NAME = 'TP/HIGH'and STATUS = 'confirmed'
group by INDICATORS
order by IND_count DESC;

select MALICIOUS, count(MALICIOUS) from indicators
group by MALICIOUS; # 87.7% malicious rate (6014)

select INDICATORS, count(INDICATORS) as IND_count from indicators 
where TYPE_NAME = 'TP/HIGH' and MALICIOUS = 'yes' and STATUS = 'confirmed'
group by INDICATORS
order by IND_count DESC; # App_3_Heat_Email_CAD & App_3_Heat_Email_CD are the highest risk ones

select * from indicators
where (INDICATORS = 'App_3_Heat_Email_CAD' or INDICATORS = 'App_3_Heat_Email_CD')and STATUS = 'confirmed';
# ID: 590702601 (HRU11), 738494261, 665484379.

select distinct(HRU) from indicators;
select HRU, count(HRU) as hru_count from indicators
group by HRU
order by hru_count DESC;

select * from indicators
where INDICATORS = 'App_9_Heat_USB_IND' ; 

select * from indicators
where INDICATORS = 'Top_Users_Heat_USB_IND' and HRU = 'None'; # ID: 803288724,1658910178

select * from indicators
where INDICATORS = 'App_13_Heat_USB_IND' and HRU = 'None';

select * from indicators
where INDICATORS = 'App_7_Heat_USB_MIL' and HRU = 'None';

select * from indicators
where INDICATORS = 'App_7_Heat_USB_NON_MIL' and HRU = 'None';

select * from indicators
where INDICATORS = 'Threshold_Heat_USB_IND' and HRU = 'None'; # 

select * from indicators
where INDICATORS = 'App_9_Heat_Box_IND' and HRU = 'None'; # ID: 1768420029


### Conclusion: 
select * from locations 
where EMPLOYEE_ID = 590702601; # (HRU11)
select * from locations 
where EMPLOYEE_ID = 738494261;
select * from locations 
where EMPLOYEE_ID = 665484379;
select * from locations 
where EMPLOYEE_ID = 803288724;
select * from locations 
where EMPLOYEE_ID = 1658910178;
select * from locations 
where EMPLOYEE_ID = 1768420029;

