package com.aurionpro.controller;

import jakarta.annotation.Resource;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import com.aurionpro.model.Customer;
import com.aurionpro.model.CustomerAccountDTO;
import com.aurionpro.model.Transaction;
import com.aurionpro.service.AdminDashboardService;
import com.aurionpro.service.CustomerServiceLayer;
import com.aurionpro.service.ICustomerService;
import com.aurionpro.service.TransactionServiceLayer;
import com.aurionpro.dao.AccountDbUtil;
import com.aurionpro.dao.AdminDashboardDbUtil;
import com.aurionpro.dao.CustomerDbUtil;
import com.aurionpro.dao.PasswordUtil;

@WebServlet("/AdminController")
public class AdminController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private ICustomerService customerService;
	private AccountDbUtil accountUtil;

	@Resource(name = "jdbc/bank-source")
	private DataSource dataSource;

	@Override
	public void init() throws ServletException {
		super.init();
		try {
			accountUtil = new AccountDbUtil(dataSource);
			CustomerDbUtil customerDbUtil = new CustomerDbUtil(dataSource);
			customerService = new CustomerServiceLayer(customerDbUtil);
		} catch (Exception exc) {
			throw new ServletException(exc);
		}
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		if (session == null || !"admin".equals(session.getAttribute("role"))) {
			response.sendRedirect(request.getContextPath() + "/auth");
			return;
		}

		try {
			String form = request.getParameter("form");

			if (form == null) {
				request.getRequestDispatcher("/WEB-INF/views/adminHome.jsp").forward(request, response);
				return;
			}

			switch (form) {
			case "dashboard":
				showDashboard(request, response);
				break;
			case "addCustomer":
				request.getRequestDispatcher("/WEB-INF/views/addCustomer.jsp").forward(request, response);
				break;

			case "addBankAccount":
				request.getRequestDispatcher("/WEB-INF/views/addBankAccount.jsp").forward(request, response);
				break;

			case "searchCustomer":
				searchCustomerById(request, response);
				break;

			case "generateAccount":
				generateAccount(request, response);
				break;

			case "viewCustomer":
				viewCustomersAll(request, response);
				break;

			case "viewTransaction":
				viewAllTransaction(request, response);
				break;

			default:
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid GET command: " + form);
				break;
			}
		} catch (Exception exc) {
			throw new ServletException(exc);
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			String command = request.getParameter("command");

			if (command == null) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing command");
				return;
			}

			int customerId;
			switch (command.toUpperCase()) {
			case "ADD":
				addCustomer(request, response);
				break;

			case "DELETE": // Deactivate customer
				customerId = Integer.parseInt(request.getParameter("customerId"));
				customerService.deactivateCustomer(customerId);
				response.sendRedirect("AdminController?form=viewCustomer");
				break;

			case "REACTIVATE": // Reactivate customer
				customerId = Integer.parseInt(request.getParameter("customerId"));
				customerService.reactivateCustomer(customerId);
				response.sendRedirect("AdminController?form=viewCustomer");
				break;

			default:
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid POST command: " + command);
				break;
			}

		} catch (Exception exc) {
			throw new ServletException(exc);
		}
	}

	private void showDashboard(HttpServletRequest request, HttpServletResponse response) throws Exception {

		AdminDashboardDbUtil dashboardDao = new AdminDashboardDbUtil(dataSource);
		AdminDashboardService dashboardService = new AdminDashboardService(dashboardDao);

		// Metrics
		int totalCustomers = dashboardService.getTotalCustomers();
		int totalActiveCustomers = dashboardService.getTotalActiveCustomers();
		int totalInactiveCustomers = dashboardService.getTotalInactiveCustomers();
		int totalTransactions = dashboardService.getTotalTransactions();
		double totalBalance = dashboardService.getTotalBalance();

		TransactionServiceLayer transactionService = new TransactionServiceLayer(dataSource);
		List<Transaction> recentTransactions = transactionService.getLast10Transactions();
		request.setAttribute("recentTransactions", recentTransactions);

		// Set metrics for JSP
		request.setAttribute("totalCustomers", totalCustomers);
		request.setAttribute("totalActiveCustomers", totalActiveCustomers);
		request.setAttribute("totalInactiveCustomers", totalInactiveCustomers);
		request.setAttribute("totalTransactions", totalTransactions);
		request.setAttribute("totalBalance", totalBalance);

		request.getRequestDispatcher("/WEB-INF/views/adminHome.jsp").forward(request, response);
	}

	private void viewAllTransaction(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List<Transaction> transaction = customerService.getAllTransaction();
		request.setAttribute("transaction_List", transaction);
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/allTransaction.jsp");
		dispatcher.forward(request, response);
	}

	private void viewCustomersAll(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List<CustomerAccountDTO> customerAcc = customerService.getAllCustomerAccounts();
		request.setAttribute("Account_List", customerAcc);
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/viewCustomers.jsp");
		dispatcher.forward(request, response);
	}

	private void searchCustomerById(HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			int customerId = Integer.parseInt(request.getParameter("customerId"));
			Customer customer = customerService.getCustomerById(customerId);
			if (customer != null) {
				request.setAttribute("customer", customer);
			} else {
				request.setAttribute("error", "Customer not found!");
			}
		} catch (NumberFormatException e) {
			request.setAttribute("error", "Invalid Customer ID format!");
		}
		request.getRequestDispatcher("/WEB-INF/views/addBankAccount.jsp").forward(request, response);
	}

	private void addCustomer(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String firstName = safeTrim(request.getParameter("firstName"));
		String lastName = safeTrim(request.getParameter("lastName"));
		String email = safeTrim(request.getParameter("email"));
		String password = safeTrim(request.getParameter("password"));
		String mobileNumber = safeTrim(request.getParameter("mobileNumber"));
		String address = safeTrim(request.getParameter("address"));

		
		Map<String, String> errors = customerService.validateCustomer(firstName, lastName, email, password,
				mobileNumber, address);

		Map<String, String> formData = new HashMap<>();
		formData.put("firstName", firstName);
		formData.put("lastName", lastName);
		formData.put("email", email);
		formData.put("mobileNumber", mobileNumber);
		formData.put("address", address);

		if (!errors.isEmpty()) {
			
			request.setAttribute("errors", errors);
			request.setAttribute("form_data", formData);

			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/addCustomer.jsp");
			dispatcher.forward(request, response);
			return;
		}

		
		Customer exist = customerService.getCustomerByEmail(email);
		if (exist != null) {
			request.setAttribute("message", "Customer already exists!");
			request.setAttribute("errors", errors);
			request.setAttribute("form_data", formData);

			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/addCustomer.jsp");
			dispatcher.forward(request, response);
		} else {
			String hashedPassword = PasswordUtil.hashPassword(password);
			Customer newCustomer = new Customer(firstName, lastName, email, hashedPassword, mobileNumber, address);
			customerService.addCustomer(newCustomer);

			HttpSession session = request.getSession();
			session.setAttribute("message", "Customer added successfully!");
			session.setAttribute("messageType", "success");
			response.sendRedirect(request.getContextPath() + "/AdminController?form=dashboard");
		}
	}

	private void generateAccount(HttpServletRequest request, HttpServletResponse response) throws Exception {
		int customerId = Integer.parseInt(request.getParameter("customerId"));
		Customer customer = customerService.getCustomerById(customerId);
		request.setAttribute("customer", customer);

		String existingAccount = accountUtil.getAccountByCustomerId(customerId);
		if (existingAccount != null) {
			request.setAttribute("message", "Customer already has an account! Account No: " + existingAccount);
		} else {
			String accountNumber = accountUtil.createAccount(customerId);
			request.setAttribute("message", "Account created successfully! Account No: " + accountNumber);
		}

		request.getRequestDispatcher("/WEB-INF/views/addBankAccount.jsp").forward(request, response);
	}

	private static String safeTrim(String s) {
		return s == null ? null : s.trim();
	}
}
