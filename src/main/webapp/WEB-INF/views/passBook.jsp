<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>Customer Passbook</title>
<meta charset="UTF-8">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
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
</style>
<body class="bg-light">


	<nav class="navbar navbar-dark bg-dark fixed-top">
		<div class="container-fluid">
			<span class="navbar-text text-white"> Welcome, <strong>${sessionScope.customerFirstName}
					${sessionScope.customerLastName}</strong>
			</span> <a
				href="${pageContext.request.contextPath}/CustomerController?form=dashboard"
				class="btn btn-outline-light"> ⬅ Back to Dashboard </a>
		</div>
	</nav>

	<br>
	<br>
	<br>

	<div class="container mt-4">
		<h3 class="mb-3"> Passbook</h3>
		<p>
			<strong>Account Number:</strong>
			${sessionScope.customerAccountNumber}
		</p>

		
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

		<!-- Transactions Table -->
		<div class="row">
			<div class="col-12">
				<c:if test="${empty transaction_List}">
					<div class="alert alert-warning text-center">No transactions
						found for this account.</div>
				</c:if>

				<c:if test="${not empty transaction_List}">
					<table class="table table-striped table-bordered text-center"
						id="transactionsTable">
						<thead class="table-dark">
							<tr>
								<th>#</th>
								<th>Sender Account</th>
								<th>Receiver Account</th>
								<th>Type</th>
								<th>Amount (₹)</th>
								<th>Date & Time</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="txn" items="${transaction_List}"
								varStatus="status">
								<tr>
									<td>${status.index + 1}</td>
									<td>${txn.fromCustomer}</td>
									<td><c:choose>
											<c:when test="${empty txn.toCustomer}">-</c:when>
											<c:otherwise>${txn.toCustomer}</c:otherwise>
										</c:choose></td>
									<td class="text-capitalize">${txn.type}</td>
									<td><c:choose>
											<c:when
												test="${txn.type == 'TRANSFER' || txn.type == 'DEBIT'}">
												<span class="text-danger"><strong>-
														${txn.amount}</strong></span>
											</c:when>
											<c:otherwise>
												<span class="text-success"><strong>+
														${txn.amount}</strong></span>
											</c:otherwise>
										</c:choose></td>
									<td><fmt:formatDate value="${txn.timestamp}"
											pattern="dd-MM-yyyy HH:mm:ss" /></td>
								</tr>
							</c:forEach>
							<tr id="noResultsRow" style="display: none">
								<td colspan="6">No results found</td>
							</tr>
						</tbody>
					</table>
				</c:if>
			</div>
		</div>
	</div>

	<!-- Bootstrap & JS -->
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
				const date = rows[i].cells[5].textContent.substring(0, 10); // yyyy-MM-dd

				let show = true;

				if (accountInput && !sender.includes(accountInput)
						&& !receiver.includes(accountInput)) {
					show = false;
				}
				if (typeInput && type !== typeInput) {
					show = false;
				}
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
