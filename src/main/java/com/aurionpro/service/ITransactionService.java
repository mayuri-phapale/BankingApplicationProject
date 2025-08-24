package com.aurionpro.service;

import com.aurionpro.model.Transaction;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface ITransactionService {
	List<Transaction> getTransactions(String accountNumber) throws Exception;

	List<Transaction> getAllTransactions() throws Exception;

	String getAccountByCustomerId(int customerId) throws Exception;

	List<Transaction> getLast10Transactions() throws Exception;

	void credit(String accountNumber, double amount) throws Exception;

	void transfer(String fromAccount, String toAccount, double amount) throws Exception;

	double getBalance(String accountNumber) throws Exception;

	List<Transaction> searchTransactions(String accountNumber, String type, java.util.Date fromDate,
			java.util.Date toDate) throws Exception;

	List<Transaction> getCustomerTransactions(String accountNumber) throws Exception;

	Map<String, String> validateTransaction(String action, String amountStr, String receiverAccount);

	List<Transaction> getLast5Transactions(String accountNumber) throws Exception;

}
