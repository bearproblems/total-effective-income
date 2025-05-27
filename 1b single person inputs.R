# Preliminaries
library(tidyverse)



### Stage 1. Define income inputs

IncomeInputs <- tibble(
  BasePay = c(40000, 33000),
  Bonus = c(4000, 250),
  Allowance = c(0, 2000),
  MaxTaxableBenefits = c(2000, 0),
  MaxPensionMatch = c(0.05, 0.3),
  FreePensionContribution = c(0, 0.08)
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
  PensionContribution = c(0.05, 0.0545),
  PayrollGiving = c(0, 3000),
  GivingMatch = c(3600, 0),
  TaxableBenefits = c(2000, 0)
)


