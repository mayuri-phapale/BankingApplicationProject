package com.aurionpro.model;

import java.sql.Timestamp;

public class Transaction {
	private int transactionId;
	private String fromCustomer;
	private String toCustomer;
	private double amount;
	private String type;
	private Timestamp timestamp;

	
	
	public Transaction() {
	}

	public Transaction(int transactionId, String fromCustomer, String toCustomer, double amount, String type,
			Timestamp timestamp) {
		this.transactionId = transactionId;
		this.fromCustomer = fromCustomer;
		this.toCustomer = toCustomer;
		this.amount = amount;
		this.type = type;
		this.timestamp = timestamp;
	}


	public Transaction(String fromCustomer, String toCustomer, double amount, String type, Timestamp timestamp) {
		this.fromCustomer = fromCustomer;
		this.toCustomer = toCustomer;
		this.amount = amount;
		this.type = type;
		this.timestamp = timestamp;
	}

	public int getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(int transactionId) {
		this.transactionId = transactionId;
	}

	public String getFromCustomer() {
		return fromCustomer;
	}

	public void setFromCustomer(String fromCustomer) {
		this.fromCustomer = fromCustomer;
	}

	public String getToCustomer() {
		return toCustomer;
	}

	public void setToCustomer(String toCustomer) {
		this.toCustomer = toCustomer;
	}

	public double getAmount() {
		return amount;
	}

	public void setAmount(double amount) {
		this.amount = amount;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Timestamp getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(Timestamp timestamp) {
		this.timestamp = timestamp;
	}

	@Override
	public String toString() {
		return "Transaction [transactionId=" + transactionId + ", fromCustomer=" + fromCustomer + ", toCustomer="
				+ toCustomer + ", amount=" + amount + ", type=" + type + ", timestamp=" + timestamp + "]";
	}
	
	
}
