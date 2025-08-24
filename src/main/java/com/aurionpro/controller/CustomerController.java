package com.aurionpro.controller;

import com.aurionpro.model.Customer;
import com.aurionpro.model.Transaction;
import com.aurionpro.service.CustomerServiceLayer;
import com.aurionpro.service.ICustomerService;
import com.aurionpro.service.ITransactionService;
import com.aurionpro.service.TransactionServiceLayer;
import com.aurionpro.dao.CustomerDbUtil;

import jakarta.annotation.Resource;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import javax.sql.DataSource;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/CustomerController")
public class CustomerController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Resource(name = "jdbc/bank-source")
	private DataSource dataSource;

	private ICustomerService customerService;
	private ITransactionService transactionService;

	@Override
	public void init() throws ServletException {
		transactionService = new TransactionServiceLayer(dataSource);
		CustomerDbUtil customerDbUtil = new CustomerDbUtil(dataSource);
		customerService = new CustomerServiceLayer(customerDbUtil);
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			HttpSession session = request.getSession(false);

			if (session == null || !"customer".equals(session.getAttribute("role"))) {
				response.sendRedirect(request.getContextPath() + "/auth");
				return;
			}

			String form = request.getParameter("form");

			if (form == null || "dashboard".equals(form)) {
				loadDashboard(request, response, session);
				return;
			}

			switch (form) {
			case "editProfile":
				loadEditProfile(request, response, session);
				break;

			case "passbook":
				viewPassbook(request, response);
				break;

			case "transferMoney":
				request.getRequestDispatcher("/WEB-INF/views/newTransaction.jsp").forward(request, response);
				break;

			default:
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid GET command: " + form);
				break;
			}

		} catch (Exception e) {
			throw new ServletException("Error in CustomerController doGet", e);
		}
	}

	private void loadDashboard(HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {
		int customerId = (int) session.getAttribute("customerId");
		Customer customer = customerService.getCustomerById(customerId);
		String accountNumber = transactionService.getAccountByCustomerId(customerId);
		double balance = transactionService.getBalance(accountNumber);

		// Use attribute names consistent with JSP
		session.setAttribute("customerFirstName", customer.getFirstName());
		session.setAttribute("customerLastName", customer.getLastName());
		session.setAttribute("customerMobile", customer.getMobileNumber());
		session.setAttribute("customerAddress", customer.getAddress());
		session.setAttribute("customerEmail", customer.getEmail());
		session.setAttribute("accountNumber", accountNumber);
		session.setAttribute("balance", balance);

		List<Transaction> recentTransactions = transactionService.getLast5Transactions(accountNumber);
		request.setAttribute("recentTransactions", recentTransactions);

		request.getRequestDispatcher("/WEB-INF/views/customerHome.jsp").forward(request, response);

	}

	private void loadEditProfile(HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {
		int customerId = (int) session.getAttribute("customerId");
		Customer customer = customerService.getCustomerById(customerId);
		request.setAttribute("THE_Customer", customer);
		request.getRequestDispatcher("/WEB-INF/views/editProfile.jsp").forward(request, response);
	}

	private void viewPassbook(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		String accountNumber = (String) session.getAttribute("accountNumber");

		try {
			List<Transaction> transactions = transactionService.getCustomerTransactions(accountNumber);
			request.setAttribute("transaction_List", transactions);
			request.setAttribute("accountNumber", accountNumber);

			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/passBook.jsp");
			dispatcher.forward(request, response);
		} catch (Exception e) {
			throw new ServletException("Error loading passbook", e);
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("form");
		if ("editProfile".equals(action)) {
			try {
				updateCustomer(request, response);
			} catch (Exception e) {
				throw new ServletException("Error updating profile", e);
			}
		} else {
			doGet(request, response);
		}
	}

	private void updateCustomer(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String customerIdStr = safeTrim(request.getParameter("customerId"));
		String firstName = safeTrim(request.getParameter("firstName"));
		String lastName = safeTrim(request.getParameter("lastName"));
		String mobileNumber = safeTrim(request.getParameter("mobileNumber"));
		String address = safeTrim(request.getParameter("address"));

		Map<String, String> errors = customerService.validateeditCustomer(firstName, lastName, mobileNumber, address);

		if (!errors.isEmpty()) {
			Customer invalidCustomer = new Customer(parseIntSafe(customerIdStr, -1), firstName, lastName, mobileNumber,
					address);
			request.setAttribute("errors", errors); // must match JSP
			request.setAttribute("THE_Customer", invalidCustomer);
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/editProfile.jsp");
			dispatcher.forward(request, response);
			return;
		}

		int customerId = Integer.parseInt(customerIdStr);
		Customer updatedCustomer = new Customer(customerId, firstName, lastName, mobileNumber, address);
		customerService.updateCustomer(updatedCustomer);

		// Update session attributes
		HttpSession session = request.getSession();
		session.setAttribute("customerFirstName", updatedCustomer.getFirstName());
		session.setAttribute("customerLastName", updatedCustomer.getLastName());
		session.setAttribute("customerMobile", updatedCustomer.getMobileNumber());
		session.setAttribute("customerAddress", updatedCustomer.getAddress());

		response.sendRedirect(request.getContextPath() + "/CustomerController?form=dashboard");
	}

	private int parseIntSafe(String value, int defaultValue) {
		try {
			return Integer.parseInt(value.trim());
		} catch (Exception e) {
			return defaultValue;
		}
	}

	private static String safeTrim(String s) {
		return s == null ? null : s.trim();
	}
}
