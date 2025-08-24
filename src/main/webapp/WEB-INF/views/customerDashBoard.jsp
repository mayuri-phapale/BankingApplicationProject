<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<html>
<head>
<title>Customer Dashboard</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<style>
body {
	font-family: 'Segoe UI', sans-serif;
	background-color: #f4f6f9;
}

#sidebar {
	min-width: 250px;
	max-width: 250px;
	background-color: #1f2937;
	color: #fff;
	position: fixed;
	height: 100vh;
	padding-top: 20px;
}

#sidebar .nav-link {
	color: #fff;
	margin: 5px 0;
}

#sidebar .nav-link:hover {
	background: rgba(255, 255, 255, 0.2);
	border-radius: 5px;
}

#sidebar .nav-link i {
	margin-right: 10px;
}

.sidebar-bottom {
	color: #fff;
}

#content {
	margin-left: 250px;
	padding: 20px;
}


.navbar-custom {
	background-color: #ffffff;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	margin-bottom: 20px;
}


.dashboard-card {
	background-color: #f59e0b; /* same yellow as before */
	color: #fff;
	border-radius: 0.75rem;
	padding: 1rem 1.5rem;
	display: flex;
	align-items: center;
	justify-content-between;
}

.dashboard-card .icon {
	font-size: 2rem;
}

.dashboard-card .card-number {
	font-size: 1.5rem;
	font-weight: 700;
}
</style>

<body>

	<div id="sidebar" class="d-flex flex-column">
		<h3 class="text-center mb-4">🏦 MyBank</h3>
		<ul class="nav flex-column px-2">
			<li class="nav-item"><a class="nav-link"
				href="${pageContext.request.contextPath}/TransactionController?action=newTransaction">
					<i class="fas fa-user-plus"></i>New Transaction
			</a></li>
			<li class="nav-item"><a class="nav-link"
				href="${pageContext.request.contextPath}/CustomerController?form=passbook">
					<i class="fas fa-university"></i>PassBook
			</a></li>
			<li class="nav-item"><a class="nav-link"
				href="${pageContext.request.contextPath}/CustomerController?form=editProfile">
					<i class="fas fa-users"></i>Edit Profile
			</a></li>
		</ul>

		<!-- Customer Name at Bottom -->
		<div class="sidebar-bottom text-center mt-auto mb-3">
			<i class="fas fa-user-circle fa-2x me-2"></i> <span
				style="font-size: 1.3rem; text-transform: capitalize;">
				${sessionScope.customerFirstName} ${sessionScope.customerLastName} </span>
		</div>
	</div>

	<div id="content">
		<!-- Top Navbar -->
		<nav class="navbar navbar-expand-lg navbar-light navbar-custom">
			<div class="container-fluid">
				<span class="navbar-text"> Welcome, <strong>${sessionScope.customerFirstName}</strong></span>
				<div class="ms-auto">
					<form action="${pageContext.request.contextPath}/auth"
						method="post" class="d-inline">
						<input type="hidden" name="action" value="logout">
						<button type="submit" class="btn btn-danger btn-sm">Logout</button>
					</form>
				</div>
			</div>
		</nav>

		<c:if test="${not empty sessionScope.message}">
			<div id="alertMessage"
				class="alert ${sessionScope.messageType == 'success' ? 'alert-success' : 'alert-danger'} position-fixed top-0 end-0 m-3"
				role="alert" style="width: 300px;">${sessionScope.message}</div>
			<c:remove var="message" scope="session" />
			<c:remove var="messageType" scope="session" />
		</c:if>

		<div class="container mt-3">
			<div class="dashboard-card">
				<div class="icon">
					<i class="fas fa-wallet"></i>
				</div>
				<div class="ms-3 flex-grow-1">
					<div class="d-flex justify-content-between align-items-center mb-1">
						<div class="card-title fw-semibold text-uppercase">Total
							Balance</div>
						<div class="text-success fw-semibold">
							<i class="fas fa-arrow-up me-1"></i>5.2%
						</div>
					</div>
					<div class="card-number">₹${sessionScope.customerBalance}</div>
					<small class="text-light">Updated just now</small>
				</div>
			</div>
		</div>

		
		<div class="container mt-4">
			<div class="card shadow-sm rounded-3 p-4 bg-white">
				<h5 class="mb-3 fw-semibold text-uppercase">Account Details</h5>
				<div class="d-flex flex-wrap justify-content-between">
					<!-- Left Column -->
					<div class="flex-grow-1 me-4">
						<p>
							<strong>First Name:</strong> ${sessionScope.customerFirstName}
						</p>
						<p>
							<strong>Last Name:</strong> ${sessionScope.customerLastName}
						</p>
						<p>
							<strong>Address:</strong> ${sessionScope.customerAddress}
						</p>
						<p>
							<strong>Mobile:</strong> ${sessionScope.customerMobile}
						</p>
					</div>

					<!-- Right Column -->
					<div class="flex-grow-1">
						<p>
							<strong>Email:</strong> ${sessionScope.customerEmail}
						</p>
						<p>
							<strong>Account Type:</strong> Basic Savings Bank
						</p>
						<p>
							<strong>Balance:</strong> ₹${sessionScope.customerBalance}
						</p>
						<p>
							<strong>Currency:</strong> INR
						</p>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script>
		setTimeout(function() {
			var alert = document.getElementById('alertMessage');
			if (alert) {
				alert.style.display = 'none';
			}
		}, 3000);
	</script>

</body>
</html>
