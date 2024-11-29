# BNPL Loan Application Workflow

### Version: 1.0.0

This workflow walks through the steps to apply for a BNPL loan at checkout, including checking product eligibility, retrieving terms and conditions, creating a customer record, initiating the loan transaction, customer authentication, and retrieving the finalized payment plan. It concludes by updating the order status once the transaction is complete.

---

## Metadata Table

| Attribute                     | Value                                                                                      |
|-------------------------------|--------------------------------------------------------------------------------------------|
| **Specification Version**     | 1.0.0                                                                                     |
| **Number of APIs Referenced** | 2 (`BnplEligibilityApi`, `BnplLoanApi`)                                                   |
| **Number of Workflows**       | 1                                                                                         |
| **Workflows Validity**        | Yes                                                                                       |
| **API Surface Area Coverage** | 100%                                                                                      |

---

## Workflow Overview: ApplyForLoanAtCheckout

**Summary**: This workflow applies for a BNPL loan at checkout using the BNPL platform.  
**Description**: The process includes verifying product and customer eligibility, initiating the loan transaction, retrieving payment plans, and updating order statuses.  

---

### Inputs

| Name      | Type          | Required | Description                                        |
|-----------|---------------|----------|----------------------------------------------------|
| customer  | `object`      | Yes      | Customer details or a URI to an existing record.  |
| products  | `array`       | Yes      | Array of products to be checked for BNPL loans.   |

**Customer Object Variants**:

| Properties           | Type     | Required | Description                                      |
|-----------------------|----------|----------|--------------------------------------------------|
| `firstName`          | `string` | Yes      | Customer's first name.                          |
| `lastName`           | `string` | Yes      | Customer's last name.                           |
| `dateOfBirth`        | `string` | Yes      | Customer's date of birth in `date-time` format. |
| `postalCode`         | `string` | Yes      | Customer's postal or ZIP code.                  |

**Product Properties**:

| Property              | Type     | Required | Description                  |
|-----------------------|----------|----------|------------------------------|
| `productCode`         | `string` | Yes      | Unique code for the product. |
| `purchaseAmount`      | `object` | Yes      | Details of the product price.|

`purchaseAmount` Object:

| Property     | Type     | Required | Description               |
|--------------|----------|----------|---------------------------|
| `currency`   | `string` | Yes      | Currency code (e.g., USD).|
| `amount`     | `number` | Yes      | Price in specified currency.|

---

### Workflow Steps

| Step ID                            | Description                                                                        | Operation ID                                      |
|------------------------------------|------------------------------------------------------------------------------------|--------------------------------------------------|
| `checkProductEligibility`          | Checks whether selected products are eligible for BNPL loans.                      | `findEligibleProducts` (BnplEligibilityApi)      |
| `getCustomerTermsAndConditions`    | Retrieves terms and conditions for BNPL loans.                                     | `getTermsAndConditions` (BnplEligibilityApi)     |
| `createCustomer`                   | Creates a new customer record for BNPL loan eligibility.                           | `createCustomer` (BnplEligibilityApi)           |
| `initiateBnplTransaction`          | Initiates a BNPL loan transaction.                                                 | `createBnplTransaction` (BnplLoanApi)           |
| `authenticateCustomerAndAuthorizeLoan` | Authenticates the customer and obtains authorization for the loan.               | `getAuthorization` (BnplEligibilityApi)         |
| `retrievePaymentPlan`              | Retrieves the finalized payment plan after loan authorization.                     | `retrieveBnplLoanTransaction` (BnplLoanApi)     |
| `updateOrderStatus`                | Updates the order status to "Completed" after loan finalization.                   | `updateBnplLoanTransactionStatus` (BnplLoanApi) |

---

### Workflow Outputs

| Name                   | Type          | Description                                       |
|------------------------|---------------|---------------------------------------------------|
| `finalizedPaymentPlan` | `object`      | Finalized payment plan returned by the workflow. |

---

### Workflow Diagram

**Mermaid Syntax for the Workflow:**

```mermaid
sequenceDiagram
    participant Client
    participant EligibilityAPI as BnplEligibilityApi
    participant LoanAPI as BnplLoanApi

    Client->>+EligibilityAPI: Check product eligibility
    EligibilityAPI-->>-Client: Eligible products and required checks

    alt Customer eligibility required
        Client->>+EligibilityAPI: Retrieve terms and conditions
        EligibilityAPI-->>-Client: Terms and conditions
        Client->>+EligibilityAPI: Create customer
        EligibilityAPI-->>-Client: Customer record or eligibility status
    end

    Client->>+LoanAPI: Initiate loan transaction
    LoanAPI-->>-Client: Loan ID and redirect token

    alt Authorization required
        Client->>+EligibilityAPI: Authenticate customer
        EligibilityAPI-->>-Client: Redirect URL
    end

    Client->>+LoanAPI: Retrieve payment plan
    LoanAPI-->>-Client: Finalized payment plan

    Client->>+LoanAPI: Update order status
    LoanAPI-->>-Client: Confirmation
