package com.aurionpro.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.aurionpro.model.Customer;
import com.aurionpro.model.CustomerAccountDTO;
import com.aurionpro.model.Transaction;

public interface ICustomerService {

	void addCustomer(Customer customer) throws Exception;

	Customer getCustomerByEmail(String email) throws Exception;

	Customer getCustomerById(int id) throws Exception;

	List<CustomerAccountDTO> getAllCustomerAccounts() throws Exception;

	List<Transaction> getAllTransaction() throws Exception;

	void updateCustomer(Customer customer) throws Exception;

	List<Transaction> searchStudentsDb(String keyword) throws SQLException;

	void deactivateCustomer(int customerId) throws Exception;

	void reactivateCustomer(int customerId) throws Exception;

	Map<String, String> validateCustomer(String firstName, String lastName, String email, String password,
			String mobileNumber, String address);

	Map<String, String> validateeditCustomer(String firstName, String lastName, String mobileNumber, String address);
}
