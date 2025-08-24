package com.aurionpro.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import com.aurionpro.model.Transaction;

public class AdminDashboardDbUtil {
	private DataSource dataSource;

	public AdminDashboardDbUtil(DataSource dataSource) {
		this.dataSource = dataSource;
	}


	public int getTotalCustomers() throws Exception {
		String sql = "SELECT COUNT(*) AS total FROM Customer";
		try (Connection conn = dataSource.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			if (rs.next())
				return rs.getInt("total");
		}
		return 0;
	}


	public int getTotalActiveCustomers() throws Exception {
		String sql = "SELECT COUNT(*) AS total FROM Customer WHERE active = TRUE";
		try (Connection conn = dataSource.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			if (rs.next())
				return rs.getInt("total");
		}
		return 0;
	}


	public int getTotalInactiveCustomers() throws Exception {
		String sql = "SELECT COUNT(*) AS total FROM Customer WHERE active = FALSE";
		try (Connection conn = dataSource.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			if (rs.next())
				return rs.getInt("total");
		}
		return 0;
	}


	public int getTotalTransactions() throws Exception {
		String sql = "SELECT COUNT(*) AS total FROM Transactions";
		try (Connection conn = dataSource.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			if (rs.next())
				return rs.getInt("total");
		}
		return 0;
	}


	public double getTotalBalance() throws Exception {
		String sql = "SELECT SUM(balance) AS total_balance FROM Accounts WHERE active = TRUE";
		try (Connection conn = dataSource.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			if (rs.next())
				return rs.getDouble("total_balance");
		}
		return 0.0;
	}

	public List<Transaction> getLast10Transactions() throws SQLException {
		List<Transaction> transactions = new ArrayList<>();
		String sql = "SELECT * FROM Transactions ORDER BY timestamp DESC LIMIT 10";

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

}
