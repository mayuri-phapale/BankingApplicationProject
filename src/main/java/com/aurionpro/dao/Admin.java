package com.aurionpro.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class Admin {
	public static void main(String[] args) {
		String url = "jdbc:mysql://localhost:3306/BankManagement";
		String dbUser = "root";
		String dbPass = "root";

		try (Connection conn = DriverManager.getConnection(url, dbUser, dbPass)) {
			String sql = "INSERT INTO users (email, password, role) VALUES (?, ?, ?)";
			PreparedStatement stmt = conn.prepareStatement(sql);

			String adminUsername = "admin";
			String adminPlainPassword = "admin123";
			String adminHashedPassword = PasswordUtil.hashPassword(adminPlainPassword);

			stmt.setString(1, adminUsername);
			stmt.setString(2, adminHashedPassword);
			stmt.setString(3, "admin");

			stmt.executeUpdate();

			System.out.println("✅ Admin user inserted with hashed password!");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
