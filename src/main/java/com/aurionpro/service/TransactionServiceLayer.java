package com.aurionpro.service;

import com.aurionpro.dao.TransactionDbUtil;
import com.aurionpro.model.Transaction;
import javax.sql.DataSource;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TransactionServiceLayer implements ITransactionService {

	private TransactionDbUtil transactionDbUtil;

	public TransactionServiceLayer(DataSource dataSource) {
		this.transactionDbUtil = new TransactionDbUtil(dataSource);
	}

	@Override
	public List<Transaction> getTransactions(String accountNumber) throws Exception {
		return transactionDbUtil.getTransactions(accountNumber);
	}

	@Override
	public List<Transaction> getAllTransactions() throws Exception {
		return transactionDbUtil.getAllTransactions();
	}

	@Override
	public List<Transaction> searchTransactions(String accountNumber, String type, Date fromDate, Date toDate)
			throws Exception {
		return transactionDbUtil.searchTransactions(accountNumber, type, fromDate, toDate);
	}

	@Override
	public void credit(String accountNumber, double amount) throws Exception {
		transactionDbUtil.credit(accountNumber, amount);
	}

	@Override
	public void transfer(String fromAccount, String toAccount, double amount) throws Exception {
		transactionDbUtil.transfer(fromAccount, toAccount, amount);
	}

	@Override
	public double getBalance(String accountNumber) throws Exception {
		return transactionDbUtil.getBalance(accountNumber);
	}

	@Override
	public String getAccountByCustomerId(int customerId) throws Exception {

		return transactionDbUtil.getAccountByCustomerId(customerId);
	}

	@Override
	public List<Transaction> getLast10Transactions() throws Exception {

		return transactionDbUtil.getLast10Transactions();
	}

	public List<Transaction> getCustomerTransactions(String accountNumber) throws Exception {
		return transactionDbUtil.getTransactionsByCustomer(accountNumber);
	}

	@Override
	public List<Transaction> getLast5Transactions(String accountNumber) throws Exception {
		return transactionDbUtil.getLast5Transactions(accountNumber);
	}

	public Map<String, String> validateTransaction(String action, String amountStr, String receiverAccount) {
		Map<String, String> errors = new HashMap<>();

		if (action == null || (!action.equals("credit") && !action.equals("transfer"))) {
			errors.put("action", "Please select a valid transaction type.");
		}

		if (amountStr == null || amountStr.isBlank()) {
			errors.put("amount", "Amount is required.");
		} else {
			try {
				double amount = Double.parseDouble(amountStr);
				if (amount <= 0)
					errors.put("amount", "Amount must be greater than 0.");
			} catch (NumberFormatException e) {
				errors.put("amount", "Amount must be a valid number.");
			}
		}

		if ("transfer".equals(action) && (receiverAccount == null || receiverAccount.isBlank())) {
			errors.put("receiver", "Receiver account is required for transfer.");
		}

		return errors;
	}

}
