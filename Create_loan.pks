CREATE OR REPLACE PACKAGE ldms_pkg AS

-- 
-- Purpose : This package specification contains all related
--           functions and procedures for LDMS
-- Version History
-- version date       Name          Description
-- ------- ---------- ------------- ------------------------
-- 1.0     15/05/2024 Sridhar Morti initial version
-- 

CREATE OR REPLACE FUNCTION new_loan_request (ip_loan_details IN XMLTYPE)
RETURN VARCHAR2;

END ldms_pkg;
/
