package com.aurionpro.service;

import java.util.List;

import com.aurionpro.dao.AdminDashboardDbUtil;
import com.aurionpro.model.Transaction;

public class AdminDashboardService {
	private AdminDashboardDbUtil dao;

	public AdminDashboardService(AdminDashboardDbUtil dao) {
		this.dao = dao;
	}

	public int getTotalCustomers() throws Exception {
		return dao.getTotalCustomers();
	}

	public int getTotalActiveCustomers() throws Exception {
		return dao.getTotalActiveCustomers();
	}

	public int getTotalInactiveCustomers() throws Exception {
		return dao.getTotalInactiveCustomers();
	}

	public int getTotalTransactions() throws Exception {
		return dao.getTotalTransactions();
	}

	public double getTotalBalance() throws Exception {
		return dao.getTotalBalance();
	}

	public List<Transaction> getLast10Transactions() throws Exception {
		return dao.getLast10Transactions();
	}

}
