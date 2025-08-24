package com.aurionpro.model;

public class Account {
	private int accId;
	private String accNumber;
	private int customerId;
	private double balance;

	public Account(int accId, String accNumber, int customerId, double balance) {
		super();
		this.accId = accId;
		this.accNumber = accNumber;
		this.customerId = customerId;
		this.balance = balance;
	}

	public int getAccId() {
		return accId;
	}

	public void setAccId(int accId) {
		this.accId = accId;
	}

	public String getAccNumber() {
		return accNumber;
	}

	public void setAccNumber(String accNumber) {
		this.accNumber = accNumber;
	}

	public int getCustomerId() {
		return customerId;
	}

	public void setCustomerId(int customerId) {
		this.customerId = customerId;
	}

	public double getBalance() {
		return balance;
	}

	public void setBalance(double balance) {
		this.balance = balance;
	}

	@Override
	public String toString() {
		return "Account [accId=" + accId + ", accNumber=" + accNumber + ", customerId=" + customerId + ", balance="
				+ balance + "]";
	}

}
