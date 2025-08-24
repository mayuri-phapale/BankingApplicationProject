package com.aurionpro.model;

public class CustomerAccountDTO {
	private int customerId;
	private String firstName;
	private String lastName;
	private String email;
	private String accountNumber;
	private double balance;
	private boolean active; // <--- add this

	// getters and setters
	public boolean isActive() {
		return active;
	}

	public void setActive(boolean active) {
		this.active = active;
	}

	public CustomerAccountDTO(String firstName, String lastName, String email, double balance) {
		this.firstName = firstName;
		this.lastName = lastName;
		this.email = email;
		this.accountNumber = accountNumber;
		this.balance = balance;

	}

	public CustomerAccountDTO(String firstName, String lastName, String email, String accountNumber, double balance) {
		this.firstName = firstName;
		this.lastName = lastName;
		this.email = email;
		this.accountNumber = accountNumber;
		this.balance = balance;

	}

	public CustomerAccountDTO(int customerId, String firstName, String lastName, String email, String accountNumber,
			double balance) {
		this.firstName = firstName;
		this.lastName = lastName;
		this.email = email;
		this.accountNumber = accountNumber;
		this.balance = balance;
		this.customerId = customerId;

	}

	public CustomerAccountDTO() {
		// TODO Auto-generated constructor stub
	}

	public int getCustomerId() {
		return customerId;
	}

	public void setCustomerId(int customerId) {
		this.customerId = customerId;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getAccountNumber() {
		return accountNumber;
	}

	public void setAccountNumber(String accountNumber) {
		this.accountNumber = accountNumber;
	}

	public double getBalance() {
		return balance;
	}

	public void setBalance(double balance) {
		this.balance = balance;
	}

	@Override
	public String toString() {
		return "CustomerAccountDTO [firstName=" + firstName + ", lastName=" + lastName + ", email=" + email
				+ ", accountNumber=" + accountNumber + ", balance=" + balance + "]";
	}

}
