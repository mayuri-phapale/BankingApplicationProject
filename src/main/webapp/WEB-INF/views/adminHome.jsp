<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin Dashboard</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
body {
	font-family: 'Segoe UI', sans-serif;
	background-color: #f3f4f6;
	margin: 0;
	padding: 0;
}

#sidebar {
	min-width: 250px;
	max-width: 250px;
	background-color: #1f2937;
	color: #fff;
	position: fixed;
	height: 100vh;
	padding-top: 20px;
	transition: all 0.3s;
}

#sidebar h3 {
	font-weight: 700;
	font-size: 1.5rem;
}

#sidebar .nav-link {
	color: #fff;
	margin: 5px 0;
	font-weight: 500;
	transition: 0.3s;
	text-transform: capitalize;
}

#sidebar .nav-link:hover {
	background: #374151;
	border-radius: 5px;
	padding-left: 15px;
}

#sidebar .nav-link i {
	margin-right: 10px;
}

#content {
	margin-left: 250px;
	padding: 40px 30px;
}

.dashboard-card {
	background: #fff;
	border-radius: 15px;
	transition: all 0.4s;
	cursor: pointer;
	padding: 30px 20px;
	text-align: center;
	color: #1f2937;
	font-weight: 600;
	box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

.dashboard-card i {
	font-size: 2rem;
	margin-bottom: 15px;
}

.dashboard-card:hover {
	transform: translateY(-8px);
	box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
}

.card-title {
	font-size: 1rem;
	margin-bottom: 5px;
	color: #1f2937;
}

.card-number {
	font-size: 1.8rem;
	font-weight: 700;
	color: #1f2937;
}

.table-container {
	margin-top: 40px;
	background: #fff;
	padding: 20px;
	border-radius: 15px;
	box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

.table-container h5 {
	margin-bottom: 20px;
	text-transform: capitalize;
}

.table .table-striped {
	border-radius: 15px;
}

@media ( max-width : 768px) {
	#sidebar {
		position: relative;
		width: 100%;
		height: auto;
	}
	#content {
		margin-left: 0;
		padding: 20px;
	}
}
</style>
</head>
<body>


	<div id="sidebar" class="d-flex flex-column">
		<h3 class="text-center mb-4">🏦 MyBank</h3>
		<ul class="nav flex-column px-2">
			<li class="nav-item"><a class="nav-link"
				href="${pageContext.request.contextPath}/AdminController?form=dashboard"><i
					class="fas fa-tachometer-alt"></i> Dashboard</a></li>
			<li class="nav-item"><a class="nav-link"
				href="${pageContext.request.contextPath}/AdminController?form=addCustomer"><i
					class="fas fa-user-plus"></i> Add Customer</a></li>
			<li class="nav-item"><a class="nav-link"
				href="${pageContext.request.contextPath}/AdminController?form=addBankAccount"><i
					class="fas fa-university"></i> Add Bank Account</a></li>
			<li class="nav-item"><a class="nav-link"
				href="${pageContext.request.contextPath}/AdminController?form=viewCustomer"><i
					class="fas fa-users"></i> View Customers</a></li>
			<li class="nav-item"><a class="nav-link"
				href="${pageContext.request.contextPath}/AdminController?form=viewTransaction"><i
					class="fas fa-money-check-alt"></i> View Transactions</a></li>
			
		</ul>
	</div>


	<div id="content">


		<c:if test="${not empty sessionScope.message}">
			<div id="alertMessage"
				class="alert ${sessionScope.messageType == 'success' ? 'alert-success' : 'alert-danger'} position-fixed top-0 end-0 m-3"
				role="alert" style="width: 300px;">${sessionScope.message}</div>
			<c:remove var="message" scope="session" />
			<c:remove var="messageType" scope="session" />
		</c:if>

		<div
			class="d-flex justify-content-between align-items-center mb-4 p-3 bg-white rounded shadow-sm">
			<h4 class="mb-0">
				Welcome, <span class="text-primary">${sessionScope.username}</span>!
			</h4>
			<form action="${pageContext.request.contextPath}/auth" method="post">
				<input type="hidden" name="action" value="logout">
				<button class="btn btn-danger btn-sm">Logout</button>
			</form>
		</div>


		<c:if test="${param.form eq 'dashboard'}">
			<div class="row g-4">
				<div class="col-md-3 col-sm-6">
					<div class="dashboard-card card-total-balance">
						<i class="fas fa-wallet"></i>
						<div class="card-title">Total Balance</div>
						<div class="card-number">₹${totalBalance}</div>
					</div>
				</div>
				<div class="col-md-3 col-sm-6">
					<div class="dashboard-card card-total-customers">
						<i class="fas fa-users"></i>
						<div class="card-title">Total Customers</div>
						<div class="card-number">${totalCustomers}</div>
					</div>
				</div>
				<div class="col-md-3 col-sm-6">
					<div class="dashboard-card card-active-customers">
						<i class="fas fa-user-check"></i>
						<div class="card-title">Active Customers</div>
						<div class="card-number">${totalActiveCustomers}</div>
					</div>
				</div>
				<div class="col-md-3 col-sm-6">
					<div class="dashboard-card card-inactive-customers">
						<i class="fas fa-user-times"></i>
						<div class="card-title">Inactive Customers</div>
						<div class="card-number">${totalInactiveCustomers}</div>
					</div>
				</div>
			</div>


			<div class="table-container mt-4">
				<h5>Recent Transactions (Last 10)</h5>
				<div
					style="border-radius: 10px; overflow: hidden; border: 1px solid #dee2e6;">
					<table class="table table-striped table-bordered text-center mb-0">
						<thead class="table-light">
							<tr>
								<th>Sr. No.</th>
								<th>Sender Account</th>
								<th>Receiver Account</th>
								<th>Type</th>
								<th>Amount</th>
								<th>Timestamp</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="transaction" items="${recentTransactions}"
								varStatus="status">
								<tr>
									<td>${status.index + 1}</td>
									<td>${transaction.fromCustomer}</td>
									<td><c:choose>
											<c:when test="${empty transaction.toCustomer}">-</c:when>
											<c:otherwise>${transaction.toCustomer}</c:otherwise>
										</c:choose></td>
									<td>${transaction.type}</td>
									<td><c:choose>
											<c:when test="${transaction.type eq 'TRANSFER'}">
												<span class="text-danger"><strong>-
														₹${transaction.amount}</strong></span>
											</c:when>
											<c:otherwise>
												<span class="text-success"><strong>+
														₹${transaction.amount}</strong></span>
											</c:otherwise>
										</c:choose></td>
									<td>${transaction.timestamp}</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<a
					href="${pageContext.request.contextPath}/AdminController?form=viewTransaction"
					class="btn btn-primary btn-sm mt-2">View Full Transactions</a>
			</div>




		</c:if>

		<!-- Dynamic Form Area -->
		<div id="dynamicForm" class="container mt-4">
			<c:if test="${param.form eq 'addCustomer'}">
				<jsp:include page="addCustomer.jsp" />
			</c:if>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
	<script>

		setTimeout(() => {
			let alert = document.getElementById('alertMessage');
			if(alert) alert.style.display='none';
			}, 3000);
		
		function loadForm(formName){ window.location.href='AdminController?form='+formName; }
</script>

</body>
</html>
