-- 
-- Purpose : This is an installation script which would drop and recreate
--           sequences and tables related to loan application
-- Version History
-- version date       Name          Description
-- ------- ---------- ------------- ------------------------
-- 1.0     15/05/2024 Sridhar Morti initial version
-- 
DROP SEQUENCE ldms_loan_seq;

CREATE SEQUENCE ldms_loan_seq
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20;
  
DROP SEQUENCE ldms_customer_seq;

CREATE SEQUENCE ldms_customer_seq
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

DROP SEQUENCE ldms_product_seq;

CREATE SEQUENCE ldms_product_seq
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20;  
  
DROP TABLE ldms_customers;

CREATE TABLE ldms_customers
(
 customer_id   NUMBER(3)    NOT NULL, -- Uniqueidentifierof thecustomerrecord
 name          VARCHAR2(50) NOT NULL, -- Thenameof thecustomer
 date_of_birth DATE         NOT NULL, -- Thedateofbirthof thecustomer
 title         VARCHAR2(10)           -- Preferredtitlee.g.Mr.,Dr.etc
)
/

DROP TABLE ldms_loan_product_types;

CREATE TABLE ldms_loan_product_types
(  
loan_product_id        NUMBER(3)    NOT NULL, -- The unique identifier for the type of loan_product_id
loan_product_name      VARCHAR2(50) NOT NULL, -- The name of the loan product
variable_interest_rate BOOLEAN      NOT NULL -- True if interest on loan is variable, false if fixed
)
/

DROP TABLE ldms_loans;

CREATE TABLE ldms_loans
(  
 loan_id                  NUMBER(3)    NOT NULL, -- Unique identifier of the loans record
 customer_id              NUMBER(3)    NOT NULL, -- Identifier of the Customer linked to the  Loan
 loan_product_id          NUMBER(3)    NOT NULL, -- Identify the type of loan from available Loan Product Types
 opening_balance          NUMBER(10,2) NOT NULL, -- Opening Balance on the loan
 current_balance          NUMBER(10,2) NOT NULL, -- Current remaining balance to repay
 payment_amount           NUMBER(10,2) NOT NULL, -- Amount to payb ack in each repayment
 instalment_payment_date  DATE         NOT NULL, -- Date of repayment
 rate                     NUMBER(10,2) NOT NULL -- Interest rate on loan
)
/

exit;