# Preliminaries
library(tidyverse)



### Stage 1. Define income inputs

IncomeInputs <- tibble(
  BasePay = c(47300, 33000, 100000, 57300),
  Bonus = c(0, 250, 20000, 400),
  Allowance = c(0, 2000, 5000, 3500),
  MaxTaxableBenefits = c(1200, 0, 0, 0),
  MaxPensionMatch = c(0.05, 0.03, 0.03, 0.03),
  FreePensionContribution = c(0, 0.08, 0, 0.08)
)

# View(IncomeInputs)



### Stage 2. define deductions inputs

DeductionInputs <- tibble(
  LowerTaxThreshold = 12570,
  LowerTaxRate = 0.2,
  HigherTaxThreshold = 50270,
  HigherTaxRate = 0.4,
  FurtherTaxThreshold = 125140,
  FurtherTaxRate = 0.45,
  NIThreshold = 12570,
  NIRate = 0.8,
  NIHigherThreshold = 50270,
  NIHigherRate = 0.02,
  SLCThreshold = 28470,
  SLCRate = 0.09
)
  
  
# View(DeductionInputs)

### Stage 3. define PayrollDecisions

PayrollDecisions <- tibble(
  PensionContribution = c(0.05, 0.0545, 0.05, 0.0545),
  PayrollGiving = c(0, 3000, 0, 3024),
  GivingMatch = c(3600, 0, 0, 0),
  TaxableBenefits = c(1200, 0, 2000, 0)
)


### Stage 4. Discretionary spending choices (take-home pay)
DiscretionarySpend <- tibble(
  PostTaxGiving = c(50*12, 25*12, 600*12, 80*12),
  HousingCosts = c(1000*12, 1000*12, 3000*12, 1000*12),
  SavingAndInvesting = c(500*12, 300*12, 1200*12, 800*12)
)

