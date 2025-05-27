### total effective income

# take home pay (calculated as base pay + bonus + allowance, minus Tax, NICs, SLCs)
# Taxable Benefits (partly offset by also increasing tax)
# Personal Pension Contribution (also reduces tax)
# Company Pension Contribution
# Pension Tax Relief (applied separately to Pension Savings, does not reduce tax)
# Payroll giving (partly reduces take-home pay, and party reduces tax)
# Company match giving (give from take-home pay, and company pays in same amount up to a cap)
# Gift aid (give from take-home pay, and government pays in 25% limited by amount in adjusted 'BaseRatePay')

# deductions based on taxable pay
# Income Tax (on taxable pay *after* adjustments, because it is affected by taxable benefits, pension contributions, payroll giving)
# National Insurance Contributions (on taxable pay *before* adjustments, because it is unaffected by the above)
# SLCs (on taxable pay *before* adjustments, because it is unaffected by the above)

TotalEffectiveIncome <- tibble(
  TakeHomePay = Outputs$TakeHomePay,
  TaxableBenefits = Inputs$TaxableBenefits,
  PensionPersonal = Outputs$PensionPersonal,
  PensionCompany = Inputs3$PensionCompany,
  PensionTaxRelief = -IncomeTaxAdjustments$PersonalPensionContribution,
  PayrollGivingPersonal = Inputs$PayrollGiving,
  PayrollGivingTaxRelief = -IncomeTaxAdjustments$PayrollGiving,
  CompanyMatchGivingPersonal = Inputs$GivingMatch,
  CompanyMatchGivingCompany = Inputs$GivingMatch,
  GiftAid = -IncomeTaxAdjustments$GiftAid,
  TotalEffectiveIncome = TakeHomePay + TaxableBenefits + PensionPersonal + PensionCompany + PensionTaxRelief +
    PayrollGivingPersonal + PayrollGivingTaxRelief + CompanyMatchGivingPersonal + CompanyMatchGivingCompany + GiftAid,
  IncomeTax = Outputs$IncomeTax,
  NationalInsurance = Outputs$NationalInsurance,
  StudentLoanRepayment = Outputs$StudentLoanRepayment
)

View(TotalEffectiveIncome/12)
