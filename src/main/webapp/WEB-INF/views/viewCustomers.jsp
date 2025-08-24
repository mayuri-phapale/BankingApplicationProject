<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>View Customers</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
body {
	padding-top: 70px;
	background-color: #f8f9fa;
	font-family: 'Segoe UI', sans-serif;
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

.table-wrapper {
	padding: 20px;
}

.search-container {
	display: flex;
	justify-content: space-between;
	flex-wrap: wrap;
	margin-bottom: 15px;
	align-items: center;
}

.search-input {
	max-width: 450px;
	position: relative;
}

.search-input input {
	padding-left: 35px;
}

.search-input i {
	position: absolute;
	left: 10px;
	top: 50%;
	transform: translateY(-50%);
	color: #6c757d;
}

.filter-btns .btn {
	margin-left: 5px;
}

table th, table td {
	text-align: center;
	vertical-align: middle;
}
</style>
</head>
<body>


	<nav class="navbar navbar-dark bg-dark fixed-top">
		<div class="container-fluid">
			<span class="navbar-text text-white"> Welcome, <strong>${sessionScope.username}</strong></span>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="offcanvas" data-bs-target="#offcanvasMenu"
				aria-controls="offcanvasMenu">
				<span class="navbar-toggler-icon"></span>
			</button>
		</div>
	</nav>

	<!-- Offcanvas Sidebar -->
	<div class="offcanvas offcanvas-end text-bg-dark" tabindex="-1"
		id="offcanvasMenu" aria-labelledby="offcanvasMenuLabel"
		style="width: 250px;">
		<div class="offcanvas-header">
			<h5 class="offcanvas-title" id="offcanvasMenuLabel">Admin Menu</h5>
			<button type="button" class="btn-close btn-close-white"
				data-bs-dismiss="offcanvas" aria-label="Close"></button>
		</div>
		<div
			class="offcanvas-body d-flex flex-column justify-content-between h-100">
			<ul class="navbar-nav flex-column mb-3">
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
			<div class="mt-auto">
				<form action="${pageContext.request.contextPath}/auth" method="post">
					<input type="hidden" name="action" value="logout">
					<button type="submit" class="btn btn-danger w-100 mb-2">Logout</button>
				</form>
			</div>
		</div>
	</div>

	<!-- Table Wrapper -->
	<div class="table-wrapper container">
		<h2 class="mb-3">Customer Accounts</h2>

		<!-- Search and Filter -->
		<div class="search-container">
			<div class="search-input"
				style="flex-grow: 1; max-width: 500px; position: relative;">
				<i class="fas fa-search"></i> <input type="text" id="searchInput"
					class="form-control"
					placeholder="Search by First Name, Last Name, or Account Number">
			</div>
			<div class="filter-btns">
				<button class="btn btn-outline-primary btn-sm"
					onclick="filterStatus('all')">All</button>
				<button class="btn btn-outline-success btn-sm"
					onclick="filterStatus('active')">Active</button>
				<button class="btn btn-outline-danger btn-sm"
					onclick="filterStatus('inactive')">Inactive</button>
			</div>
		</div>

		<div class="table-responsive "
			style="border-radius: 10px; overflow: hidden; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);">
			<table class="table table-striped table-hover align-middle"
				id="customerTable" style="border-radius: 10px; overflow: hidden;">
				<thead class="table-light text-center"
					style="background: linear-gradient(135deg, #343a40, #495057); border-radius: 10px;">
					<tr>
						<th>First Name</th>
						<th>Last Name</th>
						<th>Account Number</th>
						<th>Balance</th>
						<th>Status</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="tempAccount" items="${Account_List}">
						<tr data-status="${tempAccount.active ? 'active' : 'inactive'}">
							<td>${tempAccount.firstName}</td>
							<td>${tempAccount.lastName}</td>
							<td>${tempAccount.accountNumber}</td>
							<td>${tempAccount.balance}</td>
							<td><c:choose>
									<c:when test="${tempAccount.active}">Active</c:when>
									<c:otherwise>Inactive</c:otherwise>
								</c:choose></td>
							<td>
								<div class="d-flex justify-content-center">
									<c:choose>
										<c:when test="${tempAccount.active}">
											<form method="post" action="AdminController"
												style="display: inline;">
												<input type="hidden" name="command" value="DELETE">
												<input type="hidden" name="customerId"
													value="${tempAccount.customerId}">
												<button type="submit" class="btn btn-sm btn-danger"
													onclick="return confirm('Are you sure you want to deactivate this customer?');">Delete</button>
											</form>
										</c:when>
										<c:otherwise>
											<form method="post" action="AdminController"
												style="display: inline;">
												<input type="hidden" name="command" value="REACTIVATE">
												<input type="hidden" name="customerId"
													value="${tempAccount.customerId}">
												<button type="submit" class="btn btn-sm btn-success">Reactivate</button>
											</form>
										</c:otherwise>
									</c:choose>
								</div>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script>
const table = document.getElementById('customerTable').getElementsByTagName('tbody')[0];
const searchInput = document.getElementById('searchInput');
let currentStatusFilter = 'all';

function filterTable() {
    const searchText = searchInput.value.toLowerCase();

    Array.from(table.rows).forEach(row => {
        const fn = row.cells[0].textContent.toLowerCase();
        const ln = row.cells[1].textContent.toLowerCase();
        const acc = row.cells[2].textContent.toLowerCase();
        const status = row.getAttribute('data-status');

        const matchesText = fn.includes(searchText) || ln.includes(searchText) || acc.includes(searchText);
        const matchesStatus = (currentStatusFilter === 'all') || (status === currentStatusFilter);

        row.style.display = matchesText && matchesStatus ? '' : 'none';
    });
}

function filterStatus(status) {
    currentStatusFilter = status;
    filterTable();
}

searchInput.addEventListener('input', filterTable);
</script>

</body>
</html>
