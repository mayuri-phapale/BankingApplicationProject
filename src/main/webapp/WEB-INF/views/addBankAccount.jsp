<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<title>Add Bank Account</title>
<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<!-- Font Awesome for icons -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
body {
	background-color: #f8f9fa;
}

.card {
	border-radius: 10px;
}

.alert-info {
	font-size: 1rem;
}


.navbar {
	background-color: #1f2937 !important;
}

.navbar-nav .nav-link {
	color: white !important;
	padding: 10px;
}

.navbar-nav .nav-link:hover {
	background-color: rgba(255, 255, 255, 0.1);
}

.offcanvas {
	background-color: #1f2937 !important;
}

.customer-card {
	border-radius: 0.5rem;
	box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, .075);
}

.success-message {
	background: #d4edda;
	color: #155724;
	border-radius: 0.5rem;
	padding: 10px 15px;
	font-weight: 500;
	display: flex;
	align-items: center;
	gap: 10px;
}

.search-section {
	max-width: 500px;
}

.btn-generate {
	width: 100%;
}
</style>
</head>
<body>


	<nav class="navbar navbar-dark bg-dark fixed-top">
		<div class="container-fluid">
			<!-- Welcome Text -->
			<span class="navbar-text text-white"> Welcome, <strong>${sessionScope.username}</strong>
			</span>

			<button class="navbar-toggler" type="button"
				data-bs-toggle="offcanvas" data-bs-target="#offcanvasDarkNavbar"
				aria-controls="offcanvasDarkNavbar" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>

		
			<div class="offcanvas offcanvas-end text-bg-dark" tabindex="-1"
				id="offcanvasDarkNavbar" aria-labelledby="offcanvasDarkNavbarLabel"
				style="width: 250px;">
				<div class="offcanvas-header">
					<h5 class="offcanvas-title" id="offcanvasDarkNavbarLabel">Admin
						Menu</h5>

					<button type="button" class="btn-close btn-close-white"
						data-bs-dismiss="offcanvas" aria-label="Close"></button>


				</div>

				<hr class="border-light">

				<div
					class="offcanvas-body d-flex flex-column justify-content-between h-100">

					<!-- Menu Links -->
					<ul class="navbar-nav flex-column">
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

					


					<!-- Sidebar Buttons at Bottom -->
					<div class="mt-auto">
						<form action="${pageContext.request.contextPath}/auth"
							method="post">
							<input type="hidden" name="action" value="logout">
							<button type="submit" class="btn btn-danger w-100 mb-2">
								<i class="fas fa-sign-out-alt me-1"></i> Logout
							</button>
						</form>

					</div>

				</div>
			</div>
		</div>
	</nav>

	
	<div class="d-flex justify-content-center   bg-light"
		style="margin-top: 90px;">

		<div class="w-100" style="max-width: 600px;">
			<!-- Page Title -->
			<h3 class="text-center mb-4">Add Bank Account</h3>

			<!-- Search Customer Form -->
			<form action="AdminController" method="get" class="input-group mb-3">
				<input type="hidden" name="form" value="searchCustomer" /> <input
					type="text" name="customerId" class="form-control"
					placeholder="Enter Customer ID" required>
				<button type="submit" class="btn btn-primary">
					<i class="fas fa-search me-1"></i> Search
				</button>
			</form>

	
			<c:if test="${not empty error}">
				<div class="alert alert-danger text-center mb-3">${error}</div>
			</c:if>

			
			<c:if test="${not empty customer}">
				<div class="card shadow-sm">
					<div class="card-body">

						<h5 class="card-title text-center mb-3">Customer Details</h5>

						<ul class="list-group list-group-flush mb-3">
							<li class="list-group-item"><strong>ID:</strong>
								${customer.customerId}</li>
							<li class="list-group-item"><strong>Name:</strong>
								${customer.firstName} ${customer.lastName}</li>
							<li class="list-group-item"><strong>Email:</strong>
								${customer.email}</li>
							<li class="list-group-item"><strong>Mobile:</strong>
								${customer.mobileNumber}</li>
							<li class="list-group-item"><strong>Address:</strong>
								${customer.address}</li>
						</ul>

					
						<c:choose>
							<c:when test="${not empty message}">
								<div class="alert alert-success text-center">
									<i class="fas fa-check-circle me-1"></i> <strong>${message}</strong>
								</div>
							</c:when>
							<c:otherwise>
								<form action="AdminController" method="get" class="d-grid">
									<input type="hidden" name="form" value="generateAccount" /> <input
										type="hidden" name="customerId" value="${customer.customerId}" />
									<button type="submit" class="btn btn-success btn-generate">
										<i class="fas fa-plus-circle me-1"></i> Generate Account
										Number
									</button>
								</form>
							</c:otherwise>
						</c:choose>

					</div>
				</div>
			</c:if>
		</div>

	</div>



	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
