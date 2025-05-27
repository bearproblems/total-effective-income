# Stage 1 - stick together the three inputs

Inputs <- cbind(IncomeInputs, DeductionInputs, PayrollDecisions, DiscretionarySpend)

rm(DeductionInputs, IncomeInputs, PayrollDecisions, DiscretionarySpend)

# Stage 2 - prepare inputs for each stage of adjustments
# For each of these adjustments, we only want to keep the change to income tax;
# not NI or SLCs.

# 1 - no adjustments
Inputs1 <- Inputs %>% rowwise() %>% mutate(
  TaxablePay = BasePay + Bonus + Allowance)

# 2 - add taxable benefits
Inputs2 <- Inputs1 %>% rowwise() %>% mutate(
  TaxablePay = TaxablePay + TaxableBenefits)

# 3 - add personal pension contribution
Inputs3 <- Inputs2 %>% rowwise() %>% mutate(
  PensionablePay = BasePay + Bonus,
  PensionPersonal = PensionablePay*PensionContribution,
  PensionCompany = PensionablePay*(min(PensionContribution, MaxPensionMatch) + FreePensionContribution),
  TaxablePay = TaxablePay - PensionPersonal)

# 4 - add payroll giving - for now, we assume this describes the cost to you, not the amount given.
Inputs4 <- Inputs3 %>% rowwise() %>% mutate(
  TaxablePay = TaxablePay - PayrollGiving)

# 5 - add post-tax charity giving, which entitles you to gift-aid, aka additional giving as a tax relief
Inputs5 <- Inputs4 %>% rowwise() %>% mutate(
  TaxablePay = TaxablePay - PostTaxGiving)

# derive adjustments for each level of taxable pay.
# Deductions1 for NICs and SLCs.
# Deductions4 for Income Tax.
# Calculate TakeHomePay afterwards from outputs.
Deductions1 <- TakeHomePay(Inputs1)
Deductions2 <- TakeHomePay(Inputs2)
Deductions3 <- TakeHomePay(Inputs3)
Deductions4 <- TakeHomePay(Inputs4)
Deductions5 <- TakeHomePay(Inputs5)


###Stage 3 - Calculate adjustments to Income Tax

IncomeTaxAdjustments <- tibble(
  TaxableBenefits = Deductions2$IncomeTax - Deductions1$IncomeTax,
  PersonalPensionContribution = Deductions3$IncomeTax - Deductions2$IncomeTax,
  PayrollGiving = Deductions4$IncomeTax - Deductions3$IncomeTax,
  GiftAid = Deductions5$IncomeTax - Deductions4$IncomeTax)
  
# rm(Inputs2, Deductions2, Deductions3)


### Stage 4 - Use the above results to calculate deductions and take-home pay
# Apply Income Tax adjustments to the main series, while leaving NICs and SLCs unmodified

# Take home Pay = base pay + bonus + allowance
# - personal pension contribution - personal payroll giving
# - income tax - national insurance - SLR


Outputs <- bind_cols(BasePay = Inputs$BasePay, 
                     Bonus = Inputs$Bonus,
                     Allowance = Inputs$Allowance,
                     PensionPersonal = Inputs3$PensionPersonal,
                     PostTaxPayrollGiving = Inputs$PayrollGiving,
                     IncomeTax = Deductions2$IncomeTax, 
                     NationalInsurance = Deductions1$NationalInsurance, 
                     StudentLoanRepayment = Deductions1$StudentLoanRepayment)

Outputs <- Outputs %>% mutate(
  TakeHomePay = BasePay + Allowance + Bonus 
  - PensionPersonal - PostTaxPayrollGiving
  - IncomeTax - NationalInsurance - StudentLoanRepayment
)


OutputsMonthly <- Outputs/12



###########################################################