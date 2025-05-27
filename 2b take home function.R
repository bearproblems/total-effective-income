### Deductions function
# Feed in inputs, plus a 'TaxablePay' figure with or without adjustment.
# get out income tax, NICs, SLR.
# NICs and SLRs should be picked up from unadjusted TaxablePay.
# Income Tax should be picked up from adjusted TaxablePay because it is impacted by pension payments etc.


TakeHomePay <- function(SelectedInputs = Inputs) {
  DerivedDeductions <- SelectedInputs %>% rowwise() %>% mutate(
    TaxFreePay = min(LowerTaxThreshold, TaxablePay),
    BaseRatePay = min(HigherTaxThreshold - LowerTaxThreshold, TaxablePay - TaxFreePay),
    HigherRatePay = min(FurtherTaxThreshold - HigherTaxThreshold, TaxablePay - TaxFreePay - BaseRatePay),
    FurtherRatePay = max(TaxablePay - TaxFreePay - BaseRatePay - HigherRatePay, 0)
  )
  
  # note we assume student loan plan 2. Will eventually need to include different student loan options.
  DerivedDeductions <- DerivedDeductions %>% rowwise() %>% mutate(
    IncomeTax = BaseRatePay*LowerTaxRate + HigherRatePay*HigherTaxRate + FurtherRatePay*FurtherTaxRate,
    NationalInsurance = BaseRatePay*NIRate + (HigherRatePay + FurtherRatePay)* NIHigherRate,
    StudentLoanRepayment = max((TaxablePay - SLCThreshold), 0) * SLCRate,
    TakeHomePay = TaxablePay - IncomeTax - NationalInsurance - StudentLoanRepayment
  )
  
  DerivedDeductions <- DerivedDeductions %>% select(
    BasePay:Allowance, TaxablePay, IncomeTax:TakeHomePay)
  
return(DerivedDeductions)
}

