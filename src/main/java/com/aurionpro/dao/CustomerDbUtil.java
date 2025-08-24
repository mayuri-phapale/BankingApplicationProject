package com.aurionpro.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;
import com.aurionpro.model.Customer;
import com.aurionpro.model.CustomerAccountDTO;
import com.aurionpro.model.Transaction;

public class CustomerDbUtil {
	private DataSource dataSource;

	public CustomerDbUtil(DataSource dataSource) {
		this.dataSource = dataSource;
	}

	public void addCustomer(Customer customer) throws Exception {
		try (Connection conn = dataSource.getConnection()) {
			String sql = "INSERT INTO Customer(firstname, lastname, email, password, mobile_number, address) VALUES (?, ?, ?, ?, ?, ?)";
			try (PreparedStatement stmt = conn.prepareStatement(sql)) {
				stmt.setString(1, customer.getFirstName());
				stmt.setString(2, customer.getLastName());
				stmt.setString(3, customer.getEmail());
				stmt.setString(4, customer.getPassword());
				stmt.setString(5, customer.getMobileNumber());
				stmt.setString(6, customer.getAddress());
				stmt.executeUpdate();
			}
		}
	}

	public Customer getCustomerByEmail(String email) throws Exception {
		try (Connection conn = dataSource.getConnection()) {
			String sql = "SELECT * FROM Customer WHERE email=?";
			try (PreparedStatement stmt = conn.prepareStatement(sql)) {
				stmt.setString(1, email);
				try (ResultSet rs = stmt.executeQuery()) {
					if (rs.next()) {
						return new Customer(rs.getInt("customer_id"), rs.getString("firstname"),
								rs.getString("lastname"), rs.getString("email"), rs.getString("password"),
								rs.getString("mobile_number"), rs.getString("address"));
					}
					return null;
				}
			}
		}
	}

	public Customer getCustomerById(int id) throws Exception {
		try (Connection conn = dataSource.getConnection()) {
			String sql = "SELECT * FROM Customer WHERE customer_id=?";
			try (PreparedStatement stmt = conn.prepareStatement(sql)) {
				stmt.setInt(1, id);
				try (ResultSet rs = stmt.executeQuery()) {
					if (rs.next()) {
						return new Customer(rs.getInt("customer_id"), rs.getString("firstname"),
								rs.getString("lastname"), rs.getString("email"), rs.getString("password"),
								rs.getString("mobile_number"), rs.getString("address"));
					}
					return null;
				}
			}
		}
	}

	public void deleteCustomer(String id) throws Exception {
		int customerId = Integer.parseInt(id);

		try (Connection myConn = dataSource.getConnection();
				PreparedStatement myStmt = myConn
						.prepareStatement("UPDATE Customer SET active = FALSE WHERE customer_id=?")) {

			myStmt.setInt(1, customerId);
			int rowsAffected = myStmt.executeUpdate();
			System.out.println("Rows marked inactive: " + rowsAffected);
		}
	}

	public void updateCustomer(Customer customer) throws SQLException {
		try (Connection myConn = dataSource.getConnection();
				PreparedStatement myStmt = myConn.prepareStatement(
						"UPDATE Customer SET firstname=?, lastname=?, mobile_number=?, address=? WHERE customer_id=?")) {

			myStmt.setString(1, customer.getFirstName());
			myStmt.setString(2, customer.getLastName());
			myStmt.setString(3, customer.getMobileNumber());
			myStmt.setString(4, customer.getAddress());
			myStmt.setInt(5, customer.getCustomerId());

			myStmt.executeUpdate();
		}
	}

	public List<Transaction> getAllTransactionAccounts() throws SQLException {
		List<Transaction> transactions = new ArrayList<>();

		String sql = "SELECT t.transaction_id, t.from_customer, t.to_customer, t.amount, t.type, t.timestamp "
				+ "FROM Transactions t";

		try (Connection conn = dataSource.getConnection();
				Statement stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery(sql)) {

			while (rs.next()) {
				int transactionId = rs.getInt("transaction_id");
				String fromAccount = rs.getString("from_customer");
				String toAccount = rs.getString("to_customer");
				double amount = rs.getDouble("amount");
				String type = rs.getString("type");
				Timestamp timestamp = rs.getTimestamp("timestamp");

				Transaction transaction = new Transaction(transactionId, fromAccount, toAccount, amount, type,
						timestamp);
				transactions.add(transaction);
			}
		}

		return transactions;
	}

	public List<Transaction> searchTransactionsDb(String keyword) throws SQLException {
		List<Transaction> transactions = new ArrayList<>();

		String sql = "SELECT * FROM transactions " + "WHERE from_customer LIKE ? " + "   OR to_customer LIKE ? "
				+ "   OR type LIKE ?";

		try (Connection myConn = dataSource.getConnection(); PreparedStatement myStmt = myConn.prepareStatement(sql)) {
			String likeKeyword = "%" + keyword + "%";
			myStmt.setString(1, likeKeyword);
			myStmt.setString(2, likeKeyword);
			myStmt.setString(3, likeKeyword);

			ResultSet rs = myStmt.executeQuery();

			while (rs.next()) {
				int transactionId = rs.getInt("transaction_id");
				String fromCustomer = rs.getString("from_customer");
				String toCustomer = rs.getString("to_customer");
				double amount = rs.getDouble("amount");
				String type = rs.getString("type");
				Timestamp timestamp = rs.getTimestamp("timestamp");

				Transaction transaction = new Transaction(transactionId, fromCustomer, toCustomer, amount, type,
						timestamp);

				transactions.add(transaction);
			}
		}

		return transactions;
	}


	public void toggleCustomerStatus(int customerId, boolean active) throws Exception {
		String sql = "UPDATE Customer SET active = ? WHERE customer_id = ?";
		try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setBoolean(1, active);
			ps.setInt(2, customerId);
			ps.executeUpdate();
		}

		// Also toggle account status if needed
		sql = "UPDATE Accounts SET active = ? WHERE customer_id = ?";
		try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setBoolean(1, active);
			ps.setInt(2, customerId);
			ps.executeUpdate();
		}
	}

	public void deactivateCustomer(int customerId) throws SQLException {
		String sql1 = "UPDATE Customer SET active = FALSE WHERE customer_id = ?";
		String sql2 = "UPDATE Accounts SET active = FALSE WHERE customer_id = ?";

		try (Connection conn = dataSource.getConnection();
				PreparedStatement ps1 = conn.prepareStatement(sql1);
				PreparedStatement ps2 = conn.prepareStatement(sql2)) {

			ps1.setInt(1, customerId);
			ps1.executeUpdate();

			ps2.setInt(1, customerId);
			ps2.executeUpdate();
		}
	}

	public void reactivateCustomer(int customerId) throws SQLException {
		String sql1 = "UPDATE Customer SET active = TRUE WHERE customer_id = ?";
		String sql2 = "UPDATE Accounts SET active = TRUE WHERE customer_id = ?";

		try (Connection conn = dataSource.getConnection();
				PreparedStatement ps1 = conn.prepareStatement(sql1);
				PreparedStatement ps2 = conn.prepareStatement(sql2)) {

			ps1.setInt(1, customerId);
			ps1.executeUpdate();

			ps2.setInt(1, customerId);
			ps2.executeUpdate();
		}
	}

	// Get all customers with account info
	public List<CustomerAccountDTO> getAllCustomerAccounts() throws SQLException {
		List<CustomerAccountDTO> list = new ArrayList<>();
		String sql = "SELECT c.customer_id, c.firstname, c.lastname, c.email, c.active, "
				+ "a.account_number, a.balance " + "FROM Customer c "
				+ "JOIN Accounts a ON c.customer_id = a.customer_id";

		try (Connection conn = dataSource.getConnection();
				Statement stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery(sql)) {

			while (rs.next()) {
				CustomerAccountDTO dto = new CustomerAccountDTO();
				dto.setCustomerId(rs.getInt("customer_id"));
				dto.setFirstName(rs.getString("firstname"));
				dto.setLastName(rs.getString("lastname"));
				dto.setEmail(rs.getString("email"));
				dto.setAccountNumber(rs.getString("account_number"));
				dto.setBalance(rs.getDouble("balance"));
				dto.setActive(rs.getBoolean("active")); // important!
				list.add(dto);
			}
		}
		return list;
	}

	public void updateActiveStatus(int customerId, boolean active) throws Exception {
		String sqlCustomer = "UPDATE Customer SET active = ? WHERE customer_id = ?";
		String sqlAccount = "UPDATE Accounts SET active = ? WHERE customer_id = ?";

		try (Connection conn = dataSource.getConnection();
				PreparedStatement psCust = conn.prepareStatement(sqlCustomer);
				PreparedStatement psAcc = conn.prepareStatement(sqlAccount)) {

			conn.setAutoCommit(false);

			psCust.setBoolean(1, active);
			psCust.setInt(2, customerId);
			psCust.executeUpdate();

			psAcc.setBoolean(1, active);
			psAcc.setInt(2, customerId);
			psAcc.executeUpdate();

			conn.commit();
		}
	}

	public void setCustomerActiveStatus(int customerId, boolean active) throws SQLException {
		String sql = "UPDATE Customer SET active = ? WHERE customer_id = ?";
		try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setBoolean(1, active);
			ps.setInt(2, customerId);
			ps.executeUpdate();
		}
	}

}
