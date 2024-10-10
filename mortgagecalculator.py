def mortgage_calculator(principal, annual_rate, years, extra_payment=0):
    # Convert annual interest into a monthly rate
    monthly_rate = annual_rate / 100 / 12

    # Next we calculate the total payments

    total_payments = years * 12

    # Next we find the monthly payments

    monthly_payment = principal * (monthly_rate * (1 + monthly_rate) ** total_payments) / ((1 + monthly_rate) ** total_payments - 1)

    balance = principal

    total_interest = 0
    amortization_schedule = []

    for month in range (1, total_payments + 1):

        interest_payment = balance * monthly_rate

        principal_payment = monthly_payment - interest_payment + extra_payment

        if principal_payment > balance:
            principal_payment = balance
        
        balance -= principal_payment
        total_interest += interest_payment


        amortization_schedule.append({
            'Month': month,
            'Interest Payment': round(interest_payment, 2),
            'Principal Payment': round(principal_payment, 2),
            'Remaining Balance': round(balance, 2)
        })
    
    total_paid = total_interest + principal
    return {
        'Monthly Payment': round(monthly_payment, 2),
        'Total Interest Paid': round(total_interest, 2),
        'Total Paid': round(total_paid, 2),
        'Amortization Schedule': amortization_schedule
    } 

# Example usage:
result = mortgage_calculator(2777000, 5.0, 30, extra_payment=0)

# Displaying results
print(f"Monthly Payment: {result['Monthly Payment']} DKK")
print(f"Total Interest Paid: {result['Total Interest Paid']} DKK")
print(f"Total Paid: {result['Total Paid']} DKK")

# Display first few months of the amortization schedule
for month in result['Amortization Schedule'][:60]:
    print(month)        
