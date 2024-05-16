CREATE OR REPLACE PACKAGE ldms_pkg AS

-- 
-- Purpose : This package specification contains all related
--           functions and procedures for LDMS
-- Version History
-- version date       Name          Description
-- ------- ---------- ------------- ------------------------
-- 1.0     15/05/2024 Sridhar Morti initial version
-- 1.1     16/05/2024 Sridhar Morti Added functon pay_amount
-- 

CREATE OR REPLACE FUNCTION new_loan_request (ip_loan_details IN XMLTYPE)
RETURN VARCHAR2;

CREATE OR REPLACE FUNCTION pay_amount (ip_payment_details IN XMLTYPE)
RETURN VARCHAR2;

END ldms_pkg;
/
