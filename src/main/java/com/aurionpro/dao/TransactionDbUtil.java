package com.aurionpro.dao;

import com.aurionpro.model.Transaction;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TransactionDbUtil {

	private DataSource dataSource;

	public TransactionDbUtil(DataSource dataSource) {
		this.dataSource = dataSource;
	}


	public void credit(String accountNumber, double amount) throws Exception {
		try (Connection conn = dataSource.getConnection()) {
			conn.setAutoCommit(false);

		
			String sqlUpdate = "UPDATE Accounts SET balance = balance + ? WHERE account_number = ?";
			try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
				ps.setDouble(1, amount);
				ps.setString(2, accountNumber);
				ps.executeUpdate();
			}

			String sqlInsert = "INSERT INTO Transactions(from_customer, to_customer, amount, type, timestamp) VALUES (?, ?, ?, ?, ?)";
			try (PreparedStatement ps = conn.prepareStatement(sqlInsert)) {
				ps.setString(1, accountNumber);
				ps.setString(2, accountNumber);
				ps.setDouble(3, amount);
				ps.setString(4, "CREDIT");
				ps.setTimestamp(5, new java.sql.Timestamp(System.currentTimeMillis())); // current timestamp
				ps.executeUpdate();
			}

			conn.commit();
		} catch (Exception e) {
			throw e;
		}
	}

	public void transfer(String fromAccount, String toAccount, double amount) throws Exception {
		try (Connection conn = dataSource.getConnection()) {
			conn.setAutoCommit(false);

		
			double senderBalance;
			String sqlSender = "SELECT balance FROM Accounts WHERE account_number = ?";
			try (PreparedStatement ps = conn.prepareStatement(sqlSender)) {
				ps.setString(1, fromAccount);
				ResultSet rs = ps.executeQuery();
				if (!rs.next())
					throw new Exception("Sender account not found");
				senderBalance = rs.getDouble("balance");
			}

			if (senderBalance < amount)
				throw new Exception("Insufficient balance");

		
			String sqlReceiver = "SELECT account_number FROM Accounts WHERE account_number = ?";
			try (PreparedStatement ps = conn.prepareStatement(sqlReceiver)) {
				ps.setString(1, toAccount);
				ResultSet rs = ps.executeQuery();
				if (!rs.next())
					throw new Exception("Receiver account not found");
			}

			
			String sqlUpdateSender = "UPDATE Accounts SET balance = balance - ? WHERE account_number = ?";
			try (PreparedStatement ps = conn.prepareStatement(sqlUpdateSender)) {
				ps.setDouble(1, amount);
				ps.setString(2, fromAccount);
				ps.executeUpdate();
			}

		
			String sqlUpdateReceiver = "UPDATE Accounts SET balance = balance + ? WHERE account_number = ?";
			try (PreparedStatement ps = conn.prepareStatement(sqlUpdateReceiver)) {
				ps.setDouble(1, amount);
				ps.setString(2, toAccount);
				ps.executeUpdate();
			}

			String sqlInsert = "INSERT INTO Transactions(from_customer, to_customer, amount, type, timestamp) VALUES (?, ?, ?, ?, ?)";
			try (PreparedStatement ps = conn.prepareStatement(sqlInsert)) {
				ps.setString(1, fromAccount);
				ps.setString(2, toAccount);
				ps.setDouble(3, amount);
				ps.setString(4, "TRANSFER");
				ps.setTimestamp(5, new java.sql.Timestamp(System.currentTimeMillis())); // current timestamp
				ps.executeUpdate();
			}

			conn.commit();
		} catch (Exception e) {
			throw e;
		}
	}


	public double getBalance(String accountNumber) throws Exception {
		String sql = "SELECT balance FROM Accounts WHERE account_number = ?";
		try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, accountNumber);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next())
					return rs.getDouble("balance");
			}
		}
		return 0.0;
	}

	public List<Transaction> getTransactions(String accountNumber) throws Exception {
		List<Transaction> transactions = new ArrayList<>();
		String sql = "SELECT * FROM Transactions WHERE from_customer = ? OR to_customer = ? ORDER BY timestamp DESC";

		try (Connection conn = dataSource.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setString(1, accountNumber);
			stmt.setString(2, accountNumber);

			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				transactions.add(mapRowToTransaction(rs));
			}
		}
		return transactions;
	}

	
	public List<Transaction> getAllTransactions() throws Exception {
		List<Transaction> transactions = new ArrayList<>();
		String sql = "SELECT * FROM Transactions ORDER BY timestamp DESC";

		try (Connection conn = dataSource.getConnection(); Statement stmt = conn.createStatement()) {

			ResultSet rs = stmt.executeQuery(sql);
			while (rs.next()) {
				transactions.add(mapRowToTransaction(rs));
			}
		}
		return transactions;
	}

	// Search transactions
	public List<Transaction> searchTransactions(String accountNumber, String type, java.util.Date fromDate,
			java.util.Date toDate) throws Exception {
		List<Transaction> transactions = new ArrayList<>();
		StringBuilder sql = new StringBuilder("SELECT * FROM Transactions WHERE 1=1");

		if (accountNumber != null && !accountNumber.isEmpty()) {
			sql.append(" AND (from_customer = ? OR to_customer = ?)");
		}
		if (type != null && !type.isEmpty()) {
			sql.append(" AND type = ?");
		}
		if (fromDate != null) {
			sql.append(" AND DATE(timestamp) >= ?");
		}
		if (toDate != null) {
			sql.append(" AND DATE(timestamp) <= ?");
		}

		sql.append(" ORDER BY timestamp DESC");

		try (Connection conn = dataSource.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

			int index = 1;
			if (accountNumber != null && !accountNumber.isEmpty()) {
				stmt.setString(index++, accountNumber);
				stmt.setString(index++, accountNumber);
			}
			if (type != null && !type.isEmpty()) {
				stmt.setString(index++, type);
			}
			if (fromDate != null)
				stmt.setDate(index++, new java.sql.Date(fromDate.getTime()));
			if (toDate != null)
				stmt.setDate(index++, new java.sql.Date(toDate.getTime()));

			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				transactions.add(mapRowToTransaction(rs));
			}
		}
		return transactions;
	}


	private Transaction mapRowToTransaction(ResultSet rs) throws SQLException {
		Transaction t = new Transaction();
		t.setTransactionId(rs.getInt("transaction_id"));
		t.setFromCustomer(rs.getString("from_customer"));
		t.setToCustomer(rs.getString("to_customer"));
		t.setAmount(rs.getDouble("amount"));
		t.setType(rs.getString("type"));
		t.setTimestamp(rs.getTimestamp("timestamp"));
		return t;
	}

	public String getAccountByCustomerId(int customerId) throws SQLException {
		String sql = "SELECT account_number FROM Accounts WHERE customer_id=?";
		try (Connection conn = dataSource.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, customerId);
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					return rs.getString("account_number");
				}
			}
		}
		return null;
	}

	public List<Transaction> getLast10Transactions() throws SQLException {
		List<Transaction> transactions = new ArrayList<>();
		String sql = "SELECT transaction_id, from_customer, to_customer, amount, type, timestamp "
				+ "FROM Transactions ORDER BY timestamp DESC LIMIT 10";

		try (Connection conn = dataSource.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql);
				ResultSet rs = stmt.executeQuery()) {

			while (rs.next()) {
				Transaction txn = new Transaction();
				txn.setTransactionId(rs.getInt("transaction_id"));
				txn.setFromCustomer(rs.getString("from_customer"));
				txn.setToCustomer(rs.getString("to_customer"));
				txn.setAmount(rs.getDouble("amount"));
				txn.setType(rs.getString("type"));
				txn.setTimestamp(rs.getTimestamp("timestamp"));
				transactions.add(txn);
			}
		}
		return transactions;
	}

	public List<Transaction> getTransactionsByCustomer(String accountNumber) throws Exception {
		List<Transaction> transactions = new ArrayList<>();

		String sql = "SELECT * FROM Transactions WHERE from_customer = ? ORDER BY timestamp DESC";

		try (Connection conn = dataSource.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setString(1, accountNumber);
			try (ResultSet rs = stmt.executeQuery()) {
				while (rs.next()) {
					Transaction txn = new Transaction();
					txn.setTransactionId(rs.getInt("transaction_id"));
					txn.setFromCustomer(rs.getString("from_customer"));
					txn.setToCustomer(rs.getString("to_customer"));
					txn.setAmount(rs.getDouble("amount"));
					txn.setType(rs.getString("type"));
					txn.setTimestamp(rs.getTimestamp("timestamp"));
					transactions.add(txn);
				}
			}
		}
		return transactions;
	}

	public List<Transaction> getLast5Transactions(String accountNumber) throws Exception {
		List<Transaction> transactions = new ArrayList<>();
		String sql = "SELECT * FROM Transactions " + "WHERE from_customer = ? OR to_customer = ? "
				+ "ORDER BY timestamp DESC " + "LIMIT 5";

		try (Connection myConn = dataSource.getConnection(); PreparedStatement myStmt = myConn.prepareStatement(sql)) {

		
			myStmt.setString(1, accountNumber);
			myStmt.setString(2, accountNumber);

			try (ResultSet rs = myStmt.executeQuery()) {
				while (rs.next()) {
					int id = rs.getInt("transaction_id");
					String from = rs.getString("from_customer");
					String to = rs.getString("to_customer");
					double amount = rs.getDouble("amount");
					String type = rs.getString("type");
					Timestamp ts = rs.getTimestamp("timestamp");

				
					Transaction txn = new Transaction(id, from, to, amount, type, ts);
					transactions.add(txn);
				}
			}
		}

		return transactions;
	}

}
