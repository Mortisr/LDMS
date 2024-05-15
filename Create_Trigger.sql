CREATE OR REPLACE TRIGGER variable_interest_rate
AFTER INSERT ON ldms_loans
FOR EACH ROW 

-- 
-- Purpose : This is an after insert trigger on ldms_loans table for LDMS
-- Version History
-- version date       Name          Description
-- ------- ---------- ------------- ------------------------
-- 1.0     15/05/2024 Sridhar Morti initial version
-- 

DECLARE
  v_variable_interest_rate BOOLEAN;
  
  CURSOR c_variable_interest_rate 
  IS
  SELECT variable_interest_rate  
  FROM   ldms_loan_product_types
  WHERE loan_product_id = :new.loan_product_id;
  
BEGIN

   OPEN  c_variable_interest_rate;
   FETCH c_variable_interest_rate INTO v_variable_interest_rate;
   CLOSE c_variable_interest_rate;
   
   IF nvl(v_variable_interest_rate, FALSE) = TRUE THEN
      :new.rate := 5.25;
   ELSE
      :new.rate := :old.rate;
   END IF;

EXCEPTION
   WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20001, 'Error finding product id in trigger');
END;