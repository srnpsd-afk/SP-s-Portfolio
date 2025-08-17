/*	CREATING HOSPITAL DATA TABLE */
CREATE TABLE Hospital_Data (
Hospital_name VARCHAR(100),
Location VARCHAR(100),
Department VARCHAR(50),
Doctors_count INT,
Patients_count INT,
Admission_Date DATE,
Discharge_Date DATE,
Medical_Expenses DECIMAL(10,2)
);

SELECT * FROM Hospital_Data;

/* INSERTING DATA VIA CSV FILE INTO HOSPITAL DATA TABLE */
COPY Hospital_Data(Hospital_Name, Location, Department, Doctors_Count, Patients_Count, Admission_Date, Discharge_Date, Medical_Expenses)
FROM 'C:/Users/asus/Downloads/30 Days SQL Course Assignment-20250719T183223Z-1-001/30 Days SQL Course Assignment/Hospital_Data.csv'
CSV HEADER;

SELECT * FROM Hospital_Data;

--QUESTIONS

--1) Total Number of Patients 
-- Write an SQL query to find the total number of patients across all hospitals.
SELECT SUM(patients_count) AS Total_No_of_Patients
FROM Hospital_Data;

--2. Average Number of Doctors per Hospital 
-- Retrieve the average count of doctors available in each hospital.
SELECT hospital_name, AVG(doctors_count) AS Avg_Count_of_Doctors
FROM Hospital_Data
GROUP BY hospital_name;

--3. Top 3 Departments with the Highest Number of Patients
--Find the top 3 hospital departments that have the highest number of patients.
SELECT department, patients_count
FROM Hospital_Data
ORDER BY patients_count DESC
LIMIT 3;

--4. Hospital with the Maximum Medical Expenses 
--Identify the hospital that recorded the highest medical expenses.
SELECT hospital_name, medical_expenses AS HOSP_MAX_MEDEXP
FROM Hospital_Data
ORDER BY Medical_expenses DESC
LIMIT 1;

--5. Daily Average Medical Expenses 
--Calculate the average medical expenses per day for each hospital.
SELECT hospital_name, AVG(medical_expenses) AS Avg_Med_exp
FROM Hospital_Data
GROUP BY hospital_name;

--6. Longest Hospital Stay 
--Find the patient with the longest stay by calculating the difference between Discharge Date and Admission Date.
SELECT hospital_name, location, department, 
(discharge_date::date-admission_date::date) AS Total_Stay
FROM hospital_data
GROUP BY hospital_name, location, department, Total_Stay
ORDER BY Total_Stay DESC
LIMIT 1;

--7. Total Patients Treated Per City 
--Count the total number of patients treated in each city.
SELECT location AS City, 
SUM(patients_count) AS Patients_Treated_Count
FROM hospital_data
GROUP BY location;

--8. Average Length of Stay Per Department 
--Calculate the average number of days patients spend in each department.
SELECT department, 
AVG(discharge_date::date-admission_date::date) AS Avg_Days_Spend
FROM hospital_data
GROUP BY department
ORDER BY Avg_Days_Spend;

--9. Identify the Department with the Lowest Number of Patients 
--Find the department with the least number of patients.
SELECT department, patients_count AS Lowest_Patient_count
FROM hospital_data
GROUP BY department, patients_count
ORDER BY Patients_count
LIMIT 1;

--10. Monthly Medical Expenses Report 
--Group the data by month and calculate the total medical expenses for each month.
SELECT EXTRACT('MONTH' FROM admission_date) as Month, 
SUM(medical_expenses) Total_Med_Exp
FROM hospital_data
GROUP BY Month
ORDER BY Month;