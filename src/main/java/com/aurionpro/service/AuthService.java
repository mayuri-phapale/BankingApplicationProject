package com.aurionpro.service;

import com.aurionpro.dao.PasswordUtil;
import com.aurionpro.model.Customer;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AuthService {

	private DataSource dataSource;

	public AuthService(DataSource dataSource) {
		this.dataSource = dataSource;
	}

	public boolean validateAdmin(String username, String password) {
		String sql = "SELECT password FROM users WHERE username=? AND role='admin'";
		try (Connection conn = dataSource.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setString(1, username);
			ResultSet rs = stmt.executeQuery();

			if (rs.next()) {
				String storedHash = rs.getString("password");
				return PasswordUtil.verifyPassword(password, storedHash);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	public boolean validateCustomer(String email, String password) {
		String sql = "SELECT password FROM Customer WHERE email=?";
		try (Connection conn = dataSource.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setString(1, email);
			ResultSet rs = stmt.executeQuery();

			if (rs.next()) {
				String storedHash = rs.getString("password");
				return PasswordUtil.verifyPassword(password, storedHash);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}


	public int getCustomerId(String username) throws Exception {
		String sql = "SELECT customer_id FROM Customer WHERE email = ?";
		try (Connection conn = dataSource.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, username);
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next())
					return rs.getInt("customer_id");
			}
		}
		return -1;
	}

	
	public String getAccountNumber(int customerId) throws Exception {
		String sql = "SELECT account_number FROM Accounts WHERE customer_id = ?";
		try (Connection conn = dataSource.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, customerId);
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next())
					return rs.getString("account_number");
			}
		}
		return null;
	}

	public double getBalance(int customerId) throws Exception {
		String sql = "SELECT balance FROM Accounts WHERE customer_id = ?";
		try (Connection conn = dataSource.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, customerId);
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					return rs.getDouble("balance");
				}
			}
		}
		return 0.0;
	}

	public Customer getCustomerByUsername(String username) throws Exception {
		String sql = "SELECT c.customer_id, c.firstname, c.lastname, "
				+ "a.account_number, a.balance, c.email, c.mobile_number, c.address " + "FROM Customer c "
				+ "JOIN Accounts a ON c.customer_id = a.customer_id " + "WHERE c.email = ?";

		try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, username.trim());
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					Customer customer = new Customer();
					customer.setCustomerId(rs.getInt("customer_id"));
					customer.setFirstName(rs.getString("firstname")); // use correct column
					customer.setLastName(rs.getString("lastname"));
					customer.setEmail(rs.getString("email"));
					customer.setMobileNumber(rs.getString("mobile_number"));
					customer.setAddress(rs.getString("address"));
					return customer;
				} else {
					throw new Exception("Customer not found with username: " + username);
				}
			}
		}
	}

}
