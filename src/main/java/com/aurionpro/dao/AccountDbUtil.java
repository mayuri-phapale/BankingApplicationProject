package com.aurionpro.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.sql.DataSource;

public class AccountDbUtil {
	private DataSource dataSource;

	public AccountDbUtil(DataSource dataSource) {
		this.dataSource = dataSource;
	}

	public String createAccount(int customerId) throws SQLException {
		String accountNumber = null;

		try (Connection conn = dataSource.getConnection()) {

			String insertSql = "INSERT INTO Accounts (customer_id, balance) VALUES (?, 0)";
			PreparedStatement insertStmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
			insertStmt.setInt(1, customerId);
			insertStmt.executeUpdate();

			ResultSet rs = insertStmt.getGeneratedKeys();
			int accountId = 0;
			if (rs.next()) {
				accountId = rs.getInt(1);
				accountNumber = "ACC" + (1000 + accountId); // e.g. ACC1001, ACC1002
			}

			String updateSql = "UPDATE Accounts SET account_number=? WHERE account_id=?";
			PreparedStatement updateStmt = conn.prepareStatement(updateSql);
			updateStmt.setString(1, accountNumber);
			updateStmt.setInt(2, accountId);
			updateStmt.executeUpdate();
		}

		return accountNumber;
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
}
