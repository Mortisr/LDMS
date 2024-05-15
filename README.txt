README
------
To install the code do the following steps
1. Go to SQL
2. Run Instalation_Script.sql

It would drop & create some sequences and tables required for the application.
Please ignore the errors reported while droping the sequences and tables when running the script for the first time.
The code has never been compiled. So I expect to see some silly errors while compilng the code. I would request you to please correct the errors.

To run the code one needs to invoke the following pl/sql function :

ldms_pkg.new_loan_request with the following XML as an input parameter. The output is either any validation errors or  SUCCESS if the code is executed successfully and corresponding records are created in the following tables :

XML input format
----------------
<ROOT>
<CustomerName>Sridhar</CustomerName>
<CustomerDateOfBirth>19-SEP-1970</CustomerDateOfBirth>
<CustomerTitle>Mr</CustomerTitle>
<ProductName>Fixed Rate Product</ProductName>
<InterestRate>6.5</InterestRate>
<OpeningBalance>1000</OpeningBalance>
<CurrentBalance>1000</CurrentBalance>
<PaymentAmount>10</PaymentAmount>
<InstalmentPaymentDate>16-May-2024</InstalmentPaymentDate>
</ROOT>

