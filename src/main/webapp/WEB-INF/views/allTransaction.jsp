<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<title>Pass Book</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<!-- Font Awesome for icons -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<style>
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
</style>
<body class="bg-light">
	<nav class="navbar navbar-dark bg-dark fixed-top">
		<div class="container-fluid">
			<!-- Welcome Text -->
			<span class="navbar-text text-white"> Welcome, <strong>${sessionScope.username}</strong>
			</span>

			<!-- Offcanvas Toggle Button -->
			<button class="navbar-toggler" type="button"
				data-bs-toggle="offcanvas" data-bs-target="#offcanvasDarkNavbar"
				aria-controls="offcanvasDarkNavbar" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>

			<!-- Offcanvas Menu -->
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

					<!-- Horizontal Line -->


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
	<br>
	<br>
	<br>
	<div class="container mt-4">
		<h3>All Transactions</h3>

	
		<div class="row mb-3">
			<div class="col-md-4">
				<input type="text" id="searchAccount" class="form-control"
					placeholder="Search by sender/receiver" onkeyup="filterTable()">
			</div>
			<div class="col-md-3">
				<select id="searchType" class="form-select" onchange="filterTable()">
					<option value="">All Types</option>
					<option value="CREDIT">CREDIT</option>
					<option value="TRANSFER">TRANSFER</option>
				</select>
			</div>
			<div class="col-md-2">
				<input type="date" id="fromDate" class="form-control"
					onchange="filterTable()">
			</div>
			<div class="col-md-2">
				<input type="date" id="toDate" class="form-control"
					onchange="filterTable()">
			</div>
		</div>

		<div class="row">
			<div class="col-12">
				<table class="table table-striped table-bordered text-center"
					id="transactionsTable">
					<thead class="table-dark">
						<tr>
							<th>Sr. No.</th>
							<th>Sender Account</th>
							<th>Receiver Account</th>
							<th>Type</th>
							<th>Amount</th>
							<th>Date</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="transaction" items="${transaction_List}"
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
										<c:when test="${transaction.type == 'TRANSFER'}">
											<span class="text-danger"><strong>-
													${transaction.amount}</strong></span>
										</c:when>
										<c:otherwise>
											<span class="text-success"><strong>+
													${transaction.amount}</strong></span>
										</c:otherwise>
									</c:choose></td>
								<td>${transaction.timestamp}</td>
							</tr>
						</c:forEach>
						<tr id="noResultsRow" style="display: none">
							<td colspan="6">No results found</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>


	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

	<script>
		function filterTable() {
			const accountInput = document.getElementById('searchAccount').value
					.toUpperCase();
			const typeInput = document.getElementById('searchType').value
					.toUpperCase();
			const fromDate = document.getElementById('fromDate').value;
			const toDate = document.getElementById('toDate').value;

			const table = document.getElementById('transactionsTable');
			const rows = table.getElementsByTagName('tbody')[0]
					.getElementsByTagName('tr');
			let found = false;

			for (let i = 0; i < rows.length; i++) {
				if (rows[i].id === 'noResultsRow')
					continue;

				const sender = rows[i].cells[1].textContent.toUpperCase();
				const receiver = rows[i].cells[2].textContent.toUpperCase();
				const type = rows[i].cells[3].textContent.toUpperCase();
				const date = rows[i].cells[5].textContent;

				let show = true;

				// Filter by account
				if (accountInput && !sender.includes(accountInput)
						&& !receiver.includes(accountInput)) {
					show = false;
				}

				// Filter by type
				if (typeInput && type !== typeInput) {
					show = false;
				}

				// Filter by date
				if (fromDate && date < fromDate)
					show = false;
				if (toDate && date > toDate)
					show = false;

				rows[i].style.display = show ? "" : "none";
				if (show)
					found = true;
			}

			document.getElementById('noResultsRow').style.display = found ? "none"
					: "";
		}
	</script>
</body>
</html>
