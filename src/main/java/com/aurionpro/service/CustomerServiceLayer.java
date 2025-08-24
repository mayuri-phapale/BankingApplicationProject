package com.aurionpro.service;

import com.aurionpro.dao.CustomerDbUtil;
import com.aurionpro.model.Customer;
import com.aurionpro.model.CustomerAccountDTO;
import com.aurionpro.model.Transaction;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

public class CustomerServiceLayer implements ICustomerService {
	 private static final Pattern EMAIL_RX = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
	    private static final Pattern MOBILE_RX = Pattern.compile("^\\d{10}$"); 
	    private static final Pattern NAME_RX = Pattern.compile("^[A-Za-z]{2,50}$"); 
	    private static final Pattern ADDRESS_RX = Pattern.compile("^.{5,100}$"); 

    private CustomerDbUtil customerDbUtil;

    public CustomerServiceLayer(CustomerDbUtil customerDbUtil) {
        this.customerDbUtil = customerDbUtil;
    }

    @Override
    public void addCustomer(Customer customer) throws Exception {
        customerDbUtil.addCustomer(customer);
    }

    @Override
    public Customer getCustomerByEmail(String email) throws Exception {
        return customerDbUtil.getCustomerByEmail(email);
    }
    
    @Override
	public Customer getCustomerById(int id) throws Exception {
		return customerDbUtil.getCustomerById(id);
	}
    @Override
	public List<CustomerAccountDTO> getAllCustomerAccounts() throws Exception {
		return customerDbUtil.getAllCustomerAccounts();
	}
    
    
    
    @Override
	public void updateCustomer(Customer customer) throws Exception {
		customerDbUtil.updateCustomer(customer);
		
	}
    

	@Override
	public List<Transaction> getAllTransaction() throws Exception {
		return customerDbUtil.getAllTransactionAccounts();
	}
	

	@Override
	public List<Transaction> searchStudentsDb(String keyword) throws SQLException {
		return customerDbUtil.searchTransactionsDb(keyword);
	}

	@Override
	public void deactivateCustomer(int customerId) throws Exception {
		customerDbUtil.setCustomerActiveStatus(customerId, false);
	}

	@Override
	public void reactivateCustomer(int customerId) throws Exception {
		customerDbUtil.setCustomerActiveStatus(customerId, true);
	}



	@Override
	public Map<String, String> validateCustomer(String firstName, String lastName, String email, String password, String mobileNumber, String address) {
	    Map<String, String> errors = new HashMap<>();

	    if (firstName == null || firstName.isBlank()) {
	        errors.put("firstName", "First name is required");
	    } else if (!NAME_RX.matcher(firstName).matches()) {
	        errors.put("firstName", "First name should contain only letters (2-50 characters)");
	    }

	 
	    if (lastName == null || lastName.isBlank()) {
	        errors.put("lastName", "Last name is required");
	    } else if (!NAME_RX.matcher(lastName).matches()) {
	        errors.put("lastName", "Last name should contain only letters (2-50 characters)");
	    }

	    if (email == null || email.isBlank()) {
	        errors.put("email", "Email is required");
	    } else if (!EMAIL_RX.matcher(email).matches()) {
	        errors.put("email", "Email format is invalid");
	    }

	
	    if (password == null || password.isBlank()) {
	        errors.put("password", "Password is required");
	    } else if (password.length() < 6) {
	        errors.put("password", "Password must be at least 6 characters");
	    }


	    if (mobileNumber == null || mobileNumber.isBlank()) {
	        errors.put("mobileNumber", "Mobile number is required");
	    } else if (!MOBILE_RX.matcher(mobileNumber).matches()) {
	        errors.put("mobileNumber", "Mobile number must be 10 digits");
	    }

	
	    if (address == null || address.isBlank()) {
	        errors.put("address", "Address is required");
	    } else if (!ADDRESS_RX.matcher(address).matches()) {
	        errors.put("address", "Address must be between 5 and 100 characters");
	    }

	    return errors;
	}


    @Override
    public Map<String, String> validateeditCustomer(String firstName, String lastName, String mobileNumber, String address) {
        Map<String, String> errors = new HashMap<>();

 
        if (firstName == null || firstName.isBlank()) {
            errors.put("firstName", "First name is required");
        } else if (!NAME_RX.matcher(firstName).matches()) {
            errors.put("firstName", "First name should contain only letters (2-50 characters)");
        }

  
        if (lastName == null || lastName.isBlank()) {
            errors.put("lastName", "Last name is required");
        } else if (!NAME_RX.matcher(lastName).matches()) {
            errors.put("lastName", "Last name should contain only letters (2-50 characters)");
        }

    
        if (mobileNumber == null || mobileNumber.isBlank()) {
            errors.put("mobileNumber", "Mobile number is required");
        } else if (!MOBILE_RX.matcher(mobileNumber).matches()) {
            errors.put("mobileNumber", "Mobile number must be 10 digits");
        }

  
        if (address == null || address.isBlank()) {
            errors.put("address", "Address is required");
        } else if (!ADDRESS_RX.matcher(address).matches()) {
            errors.put("address", "Address must be between 5 and 100 characters");
        }

        return errors;
    }

    
   

	



	

	

	

	

	

	
}
