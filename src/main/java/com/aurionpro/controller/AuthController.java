package com.aurionpro.controller;

import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import javax.sql.DataSource;

import com.aurionpro.model.Customer;
import com.aurionpro.service.AuthService;

@WebServlet("/auth")
public class AuthController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private AuthService authService;

	@Resource(name = "jdbc/bank-source")
	private DataSource dataSource;

	@Override
	public void init() throws ServletException {
		try {
			authService = new AuthService(dataSource);
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		if (action == null) {
			doGet(request, response);
			return;
		}

		if ("login".equalsIgnoreCase(action)) {
			login(request, response);
		} else if ("logout".equalsIgnoreCase(action)) {
			logout(request, response);
		}
	}

	private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession(false);
		if (session != null) {
			
			String message = "✅ Logout successful!";
			String messageType = "success";

			session.invalidate(); 

		
			HttpSession newSession = request.getSession(true);
			newSession.setAttribute("message", message);
			newSession.setAttribute("messageType", messageType);
		}
		response.sendRedirect(request.getContextPath() + "/auth");
	}

	private void login(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String role = request.getParameter("role");

		if (username != null)
			username = username.trim();
		if (role != null)
			role = role.trim().toLowerCase();

		boolean isValid = false;

		try {
			
			if ("customer".equals(role)) {
				isValid = authService.validateCustomer(username, password);
			} else if ("admin".equals(role)) {
				isValid = authService.validateAdmin(username, password);
			}

			if (isValid) {
				HttpSession session = request.getSession(true);
				session.setAttribute("username", username);
				session.setAttribute("role", role);
				session.setAttribute("messages", "✅ Login successful!");
				session.setAttribute("messageType", "success");

				if ("customer".equals(role)) {
				
					int customerId = authService.getCustomerId(username);
					String accountNumber = authService.getAccountNumber(customerId);
					session.setAttribute("customerId", customerId);
					double balance = authService.getBalance(customerId);
					session.setAttribute("accountNumber", accountNumber); // Implement getBalance in AuthService
					session.setAttribute("balance", balance);

					Customer customer = authService.getCustomerByUsername(username);
					session.setAttribute("customerFirstName", customer.getFirstName());
					session.setAttribute("customerLastName", customer.getLastName());

				
					response.sendRedirect(request.getContextPath() + "/CustomerController");
				} else if ("admin".equalsIgnoreCase(role)) {
					session.setAttribute("username", username);
					session.setAttribute("role", role);
					session.setAttribute("message", "✅ Login successful!!!");
					session.setAttribute("messageType", "success");
					response.sendRedirect(request.getContextPath() + "/AdminController?form=dashboard");
				}
			} else {
				request.setAttribute("errorMessage", "❌ Invalid email/username or password");
				request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
			}
		} catch (Exception e) {
			throw new ServletException("Login failed: " + e.getMessage(), e);
		}
	}

}
