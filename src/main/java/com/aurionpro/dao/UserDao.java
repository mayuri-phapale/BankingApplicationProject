package com.aurionpro.dao;

import com.aurionpro.model.User;
import java.sql.*;
import javax.sql.DataSource;

public class UserDao {
	private DataSource dataSource;

	public UserDao(DataSource theDataSource) {
		dataSource = theDataSource;
	}

	public User findByUsername(String username) throws SQLException {
		String sql = "SELECT * FROM users WHERE username=?";
		try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, username);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				int id = rs.getInt("id");
				String name = rs.getString("username");
				String password = rs.getString("password");
				String role = rs.getString("role");
				return new User(id, name, password, role);
			}
		}
		return null;
	}

	public void registerUser(String username, String password, String role) throws SQLException {
		String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
		try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, username);
			ps.setString(2, PasswordUtil.hashPassword(password));
			ps.setString(3, role.toLowerCase());
			ps.executeUpdate();
		}
	}
}
