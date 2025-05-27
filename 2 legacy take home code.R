# 2 take home - legacy code


# Stage 2 - calculate amount of income in each tax category BEFORE adjustments

# put these bits into a function?
DeductionsUnadjusted <- Inputs %>% rowwise() %>% mutate(
  TaxablePay = BasePay + Bonus + Allowance,
  TaxFreePay = min(LowerTaxThreshold, TaxablePay),
  BaseRatePay = min(HigherTaxThreshold - LowerTaxThreshold, TaxablePay - TaxFreePay),
  HigherRatePay = min(FurtherTaxThreshold - HigherTaxThreshold, TaxablePay - TaxFreePay - BaseRatePay),
  FurtherRatePay = max(TaxablePay - TaxFreePay - BaseRatePay - HigherRatePay, 0)
)



# Stage 3 - adjustments to taxable pay
# taxable benefit adjustment
# personal pension contribution
# payroll giving

# taxable benefit adjustment
DeductionsAdjusted1 <- DeductionsUnadjusted %>% rowwise() %>% mutate(
  TaxablePay = TaxablePay + TaxableBenefits,
  TaxFreePay = min(LowerTaxThreshold, TaxablePay),
  BaseRatePay = min(HigherTaxThreshold - LowerTaxThreshold, TaxablePay - TaxFreePay),
  HigherRatePay = min(FurtherTaxThreshold - HigherTaxThreshold, TaxablePay - TaxFreePay - BaseRatePay),
  FurtherRatePay = max(TaxablePay - TaxFreePay - BaseRatePay - HigherRatePay, 0)
)


# personal pension contribution
DeductionsAdjusted2 <- DeductionsAdjusted1 %>% rowwise() %>% mutate(
  PensionablePay = BasePay + Bonus,
  PensionPersonal = PensionablePay*PensionContribution,
  PensionCompany = PensionablePay*(min(PensionContribution, MaxPensionMatch) + FreePensionContribution),
  TaxablePay = TaxablePay - PensionPersonal,
  TaxFreePay = min(LowerTaxThreshold, TaxablePay),
  BaseRatePay = min(HigherTaxThreshold - LowerTaxThreshold, TaxablePay - TaxFreePay),
  HigherRatePay = min(FurtherTaxThreshold - HigherTaxThreshold, TaxablePay - TaxFreePay - BaseRatePay),
  FurtherRatePay = max(TaxablePay - TaxFreePay - BaseRatePay - HigherRatePay, 0)
)


# payroll giving - for now, we assume this describes the cost to you, not the amount given
DeductionsAdjusted3 <- DeductionsAdjusted2 %>% rowwise() %>% mutate(
  TaxablePay = TaxablePay - PayrollGiving,
  TaxFreePay = min(LowerTaxThreshold, TaxablePay),
  BaseRatePay = min(HigherTaxThreshold - LowerTaxThreshold, TaxablePay - TaxFreePay),
  HigherRatePay = min(FurtherTaxThreshold - HigherTaxThreshold, TaxablePay - TaxFreePay - BaseRatePay),
  FurtherRatePay = max(TaxablePay - TaxFreePay - BaseRatePay - HigherRatePay, 0)
)




# Tax relief on pensions (base rate and higher rate separate. (tax, not NI or SLC)
# currently ignore higher rate pension tax relief, will need to come back to this.
# also, work out how to deduct the tax reliefs from the appropriate tax brackets, and stop deducting when there is no tax left to deduct that level.
# Deductions <- Deductions %>% rowwise() %>% mutate(
#   PensionablePay = BasePay + Bonus,
#   PensionPersonal = PensionablePay*PensionContribution,
#   PensionCompany = PensionablePay*(min(PensionContribution, MaxPensionMatch) + FreePensionContribution),
#   PensionTaxReliefBasic = if_else(BaseRatePay >= PensionPersonal, PensionPersonal * LowerTaxRate, BaseRatePay * LowerTaxRate)
# ) 



# Additional tax on taxable benefits (tax, not NI or SLC)



# Tax relief on giving (payroll giving, gift aid) (tax, not NI or SLC)


# Stage 4 - payments of Income Tax, National Insurance, and SLC

# note we assume student loan plan 2. Will eventually need to include different student loan options.
Deductions <- Deductions %>% rowwise() %>% mutate(
  IncomeTax = BaseRatePay*LowerTaxRate + HigherRatePay*HigherTaxRate + FurtherRatePay*FurtherTaxRate,
  NationalInsurance = BaseRatePay*NIRate + (HigherRatePay + FurtherRatePay)* NIHigherRate,
  StudentLoanRepayment = max((TaxablePay - SLCThreshold), 0) * SLCRate,
  TakeHomePay = TaxablePay - IncomeTax - NationalInsurance - StudentLoanRepayment
)




PlaceholderName <- tibble(
  PensionPersonal = (incomes$BasePay + incomes$Bonus)*PayrollDecisions$PensionContribution,
  PensionCompany = (incomes$BasePay + incomes$Bonus)*(min(incomes$MaxPensionMatch, PayrollDecisions$PensionContribution) + 
                                                        incomes$FreePensionContribution),
  BasePensionTaxRelief = 0.25*PensionPersonal
)


# 
# pension tax relief = 0, until income is the lower threshold.
# above the threshold, pension tax relief = 0.25*TaxablePersonalPension


# PensionPersonal
# PensionCompany
# PensionTaxRelief
# 
# PayrollGivingPersonal
# PayrollGivingTaxRelief
# 
# GivingMatchPersonal
# GivingMatchCompany
# 
# TaxableBenefitsTaxRelief
# 
# 
# TakeHomePay