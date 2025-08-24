package com.aurionpro.controller;

import com.aurionpro.model.Transaction;
import com.aurionpro.service.ITransactionService;
import com.aurionpro.service.TransactionServiceLayer;

import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import javax.sql.DataSource;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/TransactionController")
public class TransactionController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Resource(name = "jdbc/bank-source")
	private DataSource dataSource;

	private ITransactionService transactionService;

	@Override
	public void init() throws ServletException {
		transactionService = new TransactionServiceLayer(dataSource);
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null || !"customer".equals(session.getAttribute("role"))) {
			response.sendRedirect(request.getContextPath() + "/auth");
			return;
		}

		String action = request.getParameter("action");
		if (action == null)
			action = "viewAll";

		try {
			if ("newTransaction".equals(action)) {
				request.getRequestDispatcher("/WEB-INF/views/newTransaction.jsp").forward(request, response);
				return;
			}

			String accountNumber = (String) session.getAttribute("accountNumber");
			List<Transaction> transactions = transactionService.getCustomerTransactions(accountNumber);

			request.setAttribute("transaction_List", transactions);
			request.getRequestDispatcher("/WEB-INF/views/passbook.jsp").forward(request, response);

		} catch (Exception e) {
			throw new ServletException("Error in TransactionController doGet", e);
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null || !"customer".equals(session.getAttribute("role"))) {
			response.sendRedirect(request.getContextPath() + "/auth");
			return;
		}

		String fromAccount = (String) session.getAttribute("accountNumber");
		String action = request.getParameter("action");
		String amountStr = request.getParameter("amount");
		String receiver = request.getParameter("receiverAccountId");

		
		Map<String, String> errors = transactionService.validateTransaction(action, amountStr, receiver);
		request.setAttribute("prevAction", action);
		request.setAttribute("prevAmount", amountStr);
		request.setAttribute("prevReceiver", receiver);
		request.setAttribute("errors", errors);

		if (!errors.isEmpty()) {
			request.getRequestDispatcher("/WEB-INF/views/newTransaction.jsp").forward(request, response);
			return;
		}

		try {
			double amount = Double.parseDouble(amountStr);

			if ("credit".equals(action)) {
				transactionService.credit(fromAccount, amount);
				session.setAttribute("message", "✅ Amount credited successfully!");
				session.setAttribute("messageType", "success");
			} else if ("transfer".equals(action)) {
				transactionService.transfer(fromAccount, receiver, amount);
				session.setAttribute("message", "✅ Transfer successful!");
				session.setAttribute("messageType", "success");
			}

			
			session.setAttribute("balance", transactionService.getBalance(fromAccount));

			response.sendRedirect(request.getContextPath() + "/TransactionController?action=newTransaction");

		} catch (Exception e) {
			session.setAttribute("message", "❌ Transaction failed: " + e.getMessage());
			session.setAttribute("messageType", "error");
			response.sendRedirect(request.getContextPath() + "/TransactionController?action=newTransaction");
		}
	}
}
