--Создание таблицы по отчету 1 

/*
    CREATE TABLE credits (
        ID SERIAL PRIMARY KEY,
        contract_id CHAR(10),
        issue_date DATE,
        loan_amount NUMERIC,
        debt_balance NUMERIC, 
        interest_due NUMERIC,
        days_overdue INT
    );
*/

--Создание таблицы по отчету 2 

/*
    CREATE TABLE contracts (
        num_contract INT,
        contract_id INT,
        client_id INT,
        inner_lead_id INT,
        subdivision_name TEXT,
        issue_date_timestamp TIMESTAMP,
        repayment_plan_date DATE,
        loan_amount NUMERIC,
        status TEXT,
        date_status TIMESTAMP,
        sum_last_pay NUMERIC
    );

*/

--Ниже запросы из задания


/*
    4. Написать SQL запрос по отчету 2, который выведет 
    клиентов с регионом выдачи онлайн и выданные в 2024 году							
*/

SELECT 
  	DISTINCT client_id 
FROM contracts
WHERE 
	EXTRACT(YEAR FROM  issue_date_timestamp) = 2024  
	AND subdivision_name = 'Онлайн';

/*
    5. Написать SQL запрос по отчету 2, который выведет 
    три поля: статус, количество клиентов в статусе, сумму выданных займов в статусе			
*/

SELECT 
  	status,
    COUNT(client_id)  AS count_clients,
    SUM(loan_amount) AS total_amount
FROM 
	contracts
GROUP BY status;

/*
    6. Написать SQL запрос, который выведет все поля отчета 1 и отчета 2
*/
SELECT 
   	(CASE 
    	WHEN con.num_contract IS NULL THEN cr.num_contract::INT
        ELSE con.num_contract 
    END) AS num_contract,
    con.contract_id,
    con.client_id,
    (CASE 
    	WHEN con.issue_date_timestamp IS NULL THEN cr.issue_date 
        ELSE con.issue_date_timestamp::DATE 
    END) AS issue_date,
    (CASE 
    	WHEN con.loan_amount IS NULL THEN cr.loan_amount 
        ELSE con.loan_amount 
    END) AS loan_amount,
    con.inner_lead_id,
    con.subdivision_name,
    con.repayment_plan_date,
    con.status,
    con.date_status,
    con.sum_last_pay,
  	cr.debt_balance,
  	cr.interest_due,
    cr.days_overdue
   FROM contracts con
   FULL JOIN credits cr on con.num_contract = cr.num_contract::INT;