<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>


<html>
<head>
<title>Customer Dashboard</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
body {
	font-family: 'Segoe UI', sans-serif;
	background-color: #f8f9fa;
}

/* Sidebar */
#sidebar {
	width: 250px;
	background-color: #1f2937;
	color: #fff;
	position: fixed;
	height: 100vh;
	padding: 20px 0;
}

.sidebar-bottom {
	margin-left: 20px;
}

.sidebar-bottom-name {
	margin-left: 10px;
	text-transform: capitalize;
	font-size: 22px;
}

#sidebar .nav-link {
	color: #fff;
	padding: 12px 20px;
	margin: 5px 0;
	border-radius: 6px;
	cursor: pointer;
}

#sidebar .nav-link:hover {
	background-color: rgba(255, 255, 255, 0.1);
}

#sidebar .nav-link i {
	margin-right: 10px;
}

#sidebar .sidebar-bottom {
	margin-top: auto;
	padding: 10px;
	text-align: center;
}

/* Main content */
#content {
	margin-left: 250px;
	padding: 30px;
}

/* Cards */
.card {
	border-radius: 12px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.dashboard-header {
	margin-bottom: 25px;
}

.quick-actions a {
	margin-bottom: 8px;
}

.stats-card {
	text-align: center;
	padding: 20px;
}

.stats-card h3 {
	margin-bottom: 5px;
}

.stats-card p {
	font-size: 0.95rem;
	color: #555;
}

/* Transaction table */
.table thead {
	background-color: #e9ecef;
}

.table th, .table td {
	vertical-align: middle;
}

.card-header {
	font-weight: 600;
	letter-spacing: 0.5px;
}

.table-striped tbody tr:nth-of-type(odd) {
	background-color: #f8f9fa;
}
</style>
</head>
<body>

	<!-- Sidebar -->
	<div id="sidebar" class="d-flex flex-column">
		<h4 class="text-center mb-4">🏦 MyBankPortal</h4>
		<ul class="nav flex-column px-2">
			<li class="nav-item"><a class="nav-link"
				href="${pageContext.request.contextPath}/CustomerController"
				onclick="showHome()"><i class="fas fa-home"></i> Home</a></li>
			<li class="nav-item"><a class="nav-link"
				href="${pageContext.request.contextPath}/TransactionController?action=newTransaction"><i
					class="fas fa-money-bill-wave"></i> Transfer Money</a></li>
			<li class="nav-item"><a class="nav-link"
				href="${pageContext.request.contextPath}/CustomerController?form=passbook"><i
					class="fas fa-university"></i> PassBook</a></li>
			<li class="nav-item"><a class="nav-link"
				href="${pageContext.request.contextPath}/CustomerController?form=editProfile"><i
					class="fas fa-user-edit"></i> Edit Profile</a></li>
			<li class="nav-item"><a class="nav-link"
				onclick="loadAccountDetails()"><i class="fas fa-id-card"></i>
					Account Details</a></li>
		</ul>

		<div class="sidebar-bottom  d-flex text-center">
			<i class="fas fa-user-circle fa-2x me-2"></i>
			<div class="sidebar-bottom-name">${sessionScope.customerFirstName}
				${sessionScope.customerLastName}</div>
		</div>
	</div>

	<!-- Main Content -->
	<div id="content">
		<!-- Alerts -->
		<c:if test="${not empty sessionScope.messages}">
			<div id="alertMessage"
				class="alert ${sessionScope.messageType == 'success' ? 'alert-success' : 'alert-danger'} position-fixed top-0 end-0 m-3"
				role="alert" style="width: 300px;">${sessionScope.messages}</div>
			<c:remove var="messages" scope="session" />
			<c:remove var="messageType" scope="session" />
		</c:if>

		<!-- Top Navbar with Logout -->
		<div class="d-flex justify-content-between align-items-center mb-4">
			<div>
				<h2 id="welcomeMessage">Welcome,
					${sessionScope.customerFirstName}!</h2>
				<p>Here’s your account overview</p>
			</div>
			<form action="${pageContext.request.contextPath}/auth" method="post"
				class="d-inline">
				<input type="hidden" name="action" value="logout">
				<button type="submit" class="btn btn-danger">
					<i class="fas fa-sign-out-alt"></i> Logout
				</button>
			</form>
		</div>

		<!-- Dynamic content area -->
		<div id="dynamicContent">
			<!-- Home / Dashboard -->
			<div id="homeContent">

				<!-- Stats Cards -->
				<div class="row g-4 mb-4">
					<div class="col-md-4">
						<div class="card stats-card">
							<h3>₹${sessionScope.balance}</h3>
							<p>Total Balance</p>
						</div>
					</div>
					<div class="col-md-4">
						<div class="card stats-card">
							<h3>Basic Savings</h3>
							<p>Account Type</p>
						</div>
					</div>
					<div class="col-md-4">
						<div class="card stats-card text-center p-3">
							<h3>
								<c:choose>
									<c:when test="${customerAccount.active}">
					                    Active
					                </c:when>
									<c:otherwise>
					                    Active
					                </c:otherwise>
								</c:choose>
							</h3>
							<p>Account Status</p>
						</div>
					</div>

				</div>

				<!-- Quick Actions & Account Info -->
				<div class="row g-4 mb-4">
					<div class="col-md-6">
						<div class="card p-4">
							<h5>Account Summary</h5>
							<hr>
							<p>
								<strong>Account Number:</strong> ${sessionScope.accountNumber}

							</p>
							<p>
								<strong>Full Name:</strong>
								${fn:toUpperCase(sessionScope.customerFirstName)}
								${fn:toUpperCase(sessionScope.customerLastName)}
							</p>

							<p>
								<strong>Email:</strong> ${sessionScope.customerEmail}
							</p>
						</div>
					</div>
					<div class="col-md-6">
						<div class="card p-4">
							<h5>Quick Actions</h5>
							<hr>
							<a class="btn btn-primary w-100 mb-2"
								href="${pageContext.request.contextPath}/TransactionController?action=newTransaction">Transfer
								Money</a> <a class="btn btn-secondary w-100 mb-2"
								href="${pageContext.request.contextPath}/CustomerController?form=passbook">View
								Passbook</a> <a class="btn btn-info w-100"
								href="${pageContext.request.contextPath}/CustomerController?form=editProfile">Edit
								Profile</a>
						</div>
					</div>
				</div>

				<!-- Last 5 Transactions -->
				<div class="mt-5">
					<div class="card shadow-sm">
						<div class="card-header bg-primary text-white">
							<h5 class="mb-0">Recent Transactions</h5>
						</div>
						<div class="card-body p-0">
							<div class="table-responsive">
								<table class="table table-striped mb-0">
									<thead class="table-light text-uppercase">
										<tr>
											<th>Sr No.</th>
											<th>From Customer</th>
											<th>To Customer</th>
											<th>Type</th>
											<th>Amount (₹)</th>
											<th>Date & Time</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="txn" items="${recentTransactions}"
											varStatus="status">
											<tr>
												<!-- Serial number -->
												<td>${status.index + 1}</td>

												<!-- From Customer -->
												<td>${txn.fromCustomer}</td>

												<!-- To Customer -->
												<td>${txn.toCustomer}</td>

												<!-- Type -->
												<td class="text-capitalize">${txn.type}</td>

												<!-- Amount with color and sign -->
												<td><c:choose>
														<c:when test="${txn.type == 'CREDIT'}">
															<span style="color: green;"><strong>+₹${txn.amount}</strong></span>
														</c:when>
														<c:when test="${txn.type == 'TRANSFER'}">
															<span style="color: red;"><strong>-₹${txn.amount}</strong></span>
														</c:when>
														<c:otherwise>
										                    ₹${txn.amount}
										                </c:otherwise>
													</c:choose></td>

												<!-- Timestamp -->
												<td>${txn.timestamp}</td>
											</tr>
										</c:forEach>

										<c:if test="${empty recentTransactions}">
											<tr>
												<td colspan="6" class="text-center">No recent
													transactions found.</td>
											</tr>
										</c:if>
									</tbody>

								</table>
							</div>
						</div>
					</div>
				</div>

			</div>
		</div>
	</div>

	<script>
    // Session Data
    const customerAccountNumber = "${sessionScope.accountNumber}";
    const customerFirstName = "${sessionScope.customerFirstName}";
    const customerLastName = "${sessionScope.customerLastName}";
    const customerMobile = "${sessionScope.customerMobile}";
    const customerAddress = "${sessionScope.customerAddress}";
    const customerEmail = "${sessionScope.customerEmail}";
    const customerBalance = "${sessionScope.balance}";
    const accountStatus = "Active";
    const accountOpenedDate = "01-Jan-2023";

    // Load Account Details
    function loadAccountDetails() {
        const html = `
            <div class="card p-4">
                <h5>Account Details</h5>
                <hr>
                <p><strong>Account Number:</strong> ${accountNumber}</p>
                <p><strong>Full Name:</strong> ${customerFirstName} ${customerLastName}</p>
                <p><strong>Mobile Number:</strong> ${customerMobile}</p>
                <p><strong>Address:</strong> ${customerAddress}</p>
                <p><strong>Email Address:</strong> ${customerEmail}</p>
                <p><strong>Available Balance:</strong> ₹${balance}</p>
                <p><strong>Account Type:</strong> Basic Savings Bank (INR)</p>
            </div>
        `;
        document.getElementById('dynamicContent').innerHTML = html;
        document.getElementById('welcomeMessage').innerText = "Account Details";
    }

  
    function showHome() {
        document.getElementById('dynamicContent').innerHTML = document.getElementById('homeContent').outerHTML;
        document.getElementById('welcomeMessage').innerText = "Welcome, ${sessionScope.customerFirstName}!";
    }
    
    
 // Alert timeout
    setTimeout(() => {
    	let alert = document.getElementById('alertMessage');
    	if(alert) alert.style.display='none';
    	}, 3000);
</script>

</body>
</html>
