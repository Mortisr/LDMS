CREATE OR REPLACE PACKAGE BODY ldms_pkg AS

-- 
-- Purpose : This package Body contains code for all related
--           functions and procedures for LDMS
-- Version History
-- version date       Name          Description
-- ------- ---------- ------------- ------------------------
-- 1.0     15/05/2024 Sridhar Morti initial version
-- 

CREATE OR REPLACE FUNCTION new_loan_request (ip_loan_details IN XMLTYPE)
RETURN VARCHAR2
IS
  CURSOR c_customer(ip_name IN VARCHAR2, ip_date_of_birth IN DATE, ip_title IN VARCHAR2 )
  IS
     SELECT customer_id
	 FROM   ldms_customers
	 WHERE  upper(name) = upper(ip_name)
	 AND    date_of_birth = ip_date_of_birth
	 AND    title = ip_title;
	 
   CURSOR c_product(ip_product_name IN VARCHAR2)
   IS
      SELECT loan_product_id, variable_interest_rate
	  FROM   ldms_loan_product_types
	  WHERE upper(loan_product_name) = upper(ip_product_name);
	  
   v_customer_id   NUMBER;
   v_product_id    NUMBER;
   v_interest_rate NUMBER;
   v_error         VARCHAR2(100);
BEGIN
FOR i IN
  (SELECT XMLTYPE.EXTRACT (VALUE (a), '/Root/CustomerName/text()').getstringval() AS customername,
          XMLTYPE.EXTRACT (VALUE (a), '/Root/CustomerDateOfBirth/text()').getstringval() AS customerdob,
          XMLTYPE.EXTRACT (VALUE (a), '/Root/CustomerTitle/text()').getstringval() AS customertitle,
          XMLTYPE.EXTRACT (VALUE (a), '/Root/ProductName/text()').getstringval () AS productname,
          XMLTYPE.EXTRACT (VALUE (a), '/Root/InterestRate/text()').getstringval () AS interestrate,
		  XMLTYPE.EXTRACT (VALUE (a), '/Root/OpeningBalance/text()').getnumberval () AS opening_balance,
		  XMLTYPE.EXTRACT (VALUE (a), '/Root/CurrentBalance/text()').getnumberval () AS current_balance,
		  XMLTYPE.EXTRACT (VALUE (a), '/Root/PaymentAmount/text()').getnumberval () AS payment_amount,
		  XMLTYPE.EXTRACT (VALUE (a), '/Root/InstalmentPaymentDate/text()').getstringval () AS instalment_payment_date,
   FROM TABLE (XMLSEQUENCE (ip_loan_details.EXTRACT ('/LoanData/Root')
)
) a)
LOOP
  IF customername IS NULL THEN
     v_error := 'Customer Name can not be empty';
	 RETURN v_error;
  END IF;   
  IF customerdob IS NULL THEN
     v_error := 'Customer Date of Birth can not be empty';
	 RETURN v_error;
  END IF; 
  BEGIN
    -- Check that converting the string to a date does not raise any error  
    IF to_date(customerdob,'dd-mon-yyyy') <> to_date(customerdob,'dd-mon-yyyy') THEN
       v_error := 'Customer Date of Birth should be dd-mon-yyyy';
	   RETURN v_error;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
	   v_error := 'Customer Date of Birth should be dd-mon-yyyy';
	   RETURN v_error;
  END;
  IF customertitle IS NULL THEN
     v_error := 'Customer Title can not be empty';
	 RETURN v_error;
  END IF; 
  IF productname IS NULL THEN
     v_error := 'Loan Product name can not be empty';
	 RETURN v_error;
  END IF;   
  IF interestrate IS NULL THEN
     v_error := 'Loan interest rate can not be empty';
	 RETURN v_error;
  END IF;  
  BEGIN
     IF to_number(interestrate) <= 0 THEN
        v_error := 'Loan interest rate can not negative or zero';
		RETURN v_error;
     END IF;
  EXCEPTION
     WHEN OTHERS THEN
        v_error := 'Loan interest rate needs to be a valid number';
		RETURN v_error;
  END;	 
  BEGIN
  -- Check that converting the string to a date does not raise any error  
    IF to_date(instalment_payment_date,'dd-mon-yyyy') <> to_date(instalment_payment_date,'dd-mon-yyyy') THEN
       v_error := 'Payment Date should be in dd-mon-yyyy format';
	   RETURN v_error;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
	   v_error := 'Payment Date should be in dd-mon-yyyy format';
	   RETURN v_error;
  END;
  
  OPEN c_customer (customername, customerdob, customertitle);
  FETCH c_customer INTO v_customer_id;
  IF c_customer%FOUND THEN
     INSERT INTO ldms_customers 
	 VALUES (v_customer_id, customername, customerdob, customertitle);
  ELSE
  
     SELECT ldms_customer_seq.nextval INTO v_customer_id FROM dual;
	 
     INSERT INTO ldms_customers 
	 VALUES (v_customer_id, customername, customerdob, customertitle);
  END IF;
  CLOSE c_customer;
  
  OPEN c_product (productname);
  FETCH c_product INTO v_product_id, v_interest_rate;
  IF c_product%NOTFOUND THEN
  
     SELECT ldms_product_seq.nextval INTO v_product_id FROM dual;
	 
     INSERT INTO ldms_loan_product_types 
	 VALUES (v_product_id, productname, interestrate);
	 
  END IF;
  CLOSE c_product;
  
  INSERT INTO ldms_loans
    (loan_id, customer_id, loan_product_id, opening_balance, current_balance, payment_amount, instalment_payment_date, rate)
  VALUES (ldms_loan_seq.nextval, v_customer_id, v_product_id, opening_balance, current_balance, payment_amount, instalment_payment_date, interestrate);

END LOOP;
RETURN ('SUCCESS');
END new_loan_request;
END ldms_pkg;
/
