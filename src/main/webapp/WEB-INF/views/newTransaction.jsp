<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<title>New Transaction</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
body {
	padding-top: 70px;
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

.offcanvas {
	background-color: #1f2937 !important;
}

.navbar-nav .nav-link {
	color: white !important;
	padding: 10px;
}

.navbar-nav .nav-link:hover {
	background-color: rgba(255, 255, 255, 0.1);
}

@media ( max-width : 576px) {
	.card {
		margin: 0 10px;
	}
}
</style>
</head>
<body class="bg-light text-dark">

	<!-- Navbar code (unchanged) -->
	<nav class="navbar navbar-dark bg-dark fixed-top">
		<div class="container-fluid">
			<span class="navbar-text text-white"> Welcome, <strong>${sessionScope.customerFirstName}</strong>
			</span>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="offcanvas" data-bs-target="#offcanvasDarkNavbar">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="offcanvas offcanvas-end text-bg-dark"
				id="offcanvasDarkNavbar" style="width: 250px;">
				<div class="offcanvas-header">
					<h5 class="offcanvas-title">Customer Menu</h5>
					<button type="button" class="btn-close btn-close-white"
						data-bs-dismiss="offcanvas"></button>
				</div>
				<hr class="border-light">
				<div
					class="offcanvas-body d-flex flex-column justify-content-between h-100">
					<ul class="navbar-nav flex-column">
						<li class="nav-item"><a class="nav-link"
							href="${pageContext.request.contextPath}/CustomerController">Home</a></li>
						<li class="nav-item"><a class="nav-link"
							href="${pageContext.request.contextPath}/TransactionController?action=newTransaction">Transfer
								Money</a></li>
						<li class="nav-item"><a class="nav-link"
							href="${pageContext.request.contextPath}/CustomerController?form=passbook">PassBook</a></li>
						<li class="nav-item"><a class="nav-link"
							href="${pageContext.request.contextPath}/CustomerController?form=editProfile">Edit
								Profile</a></li>
					</ul>
					<div class="mt-auto">
						<form action="${pageContext.request.contextPath}/auth"
							method="post">
							<input type="hidden" name="action" value="logout">
							<button type="submit" class="btn btn-danger w-100 mb-2">Logout</button>
						</form>
					</div>
				</div>
			</div>
		</div>
	</nav>

	<div class="container mt-4">
		<div class="row justify-content-center">
			<div class="col-lg-6 col-md-7 col-sm-10">
				<div class="card shadow-sm">
					<div class="card-header text-center">
						<h4 class="mb-0">New Transaction</h4>
					</div>
					<div class="card-body">

						<c:if test="${not empty sessionScope.accountNumber}">
							<div class="alert alert-info text-center mb-4">
								<strong>Account:</strong> ${sessionScope.accountNumber} | <strong>Balance:</strong>
								₹<span id="accountBalance">${sessionScope.balance}</span>
							</div>
						</c:if>

						<!-- Error message container -->
						<div id="formError" class="alert alert-danger text-center d-none"></div>

						<form id="transactionForm"
							action="${pageContext.request.contextPath}/TransactionController"
							method="post">
							<div class="mb-3">
								<label for="transactionType" class="form-label">Transaction
									Type</label> <select class="form-select" id="transactionType"
									name="action" required>
									<option value="">--Select Transaction Type--</option>
									<option value="credit"
										${prevAction == 'credit' ? 'selected' : ''}>Credit
										(Self Deposit)</option>
									<option value="transfer"
										${prevAction == 'transfer' ? 'selected' : ''}>Transfer</option>
								</select>
							</div>

							<div class="mb-3">
								<label for="amount" class="form-label">Amount</label> <input
									type="number" class="form-control" id="amount" name="amount"
									min="1" placeholder="Enter amount" required
									value="${prevAmount != null ? prevAmount : ''}">
							</div>

							<div class="mb-3">
								<label for="receiverAccount" class="form-label">Receiver
									Account Number (for transfer)</label> <input type="text"
									class="form-control" id="receiverAccount"
									name="receiverAccountId"
									placeholder="Enter receiver account number"
									value="${prevReceiver != null ? prevReceiver : ''}">
							</div>

							<button type="submit" class="btn btn-success w-100">Submit
								Transaction</button>
						</form>

						<!-- Success/Error Messages from session -->
						<c:if test="${not empty sessionScope.message}">
							<div
								class="mt-3 alert ${sessionScope.messageType == 'success' ? 'alert-success' : 'alert-danger'} text-center">
								${sessionScope.message}</div>
							<c:remove var="message" scope="session" />
							<c:remove var="messageType" scope="session" />
						</c:if>

					</div>
				</div>
			</div>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		const transactionSelect = document.getElementById('transactionType');
		const receiverInput = document.getElementById('receiverAccount');
		const amountInput = document.getElementById('amount');
		const accountNumber = '${sessionScope.accountNumber}';
		const accountBalanceEl = document.getElementById('accountBalance');
		const formErrorEl = document.getElementById('formError');
		const transactionForm = document.getElementById('transactionForm');

		transactionSelect.addEventListener('change', function() {
			receiverInput.disabled = (this.value === 'credit');
			if (this.value === 'credit')
				receiverInput.value = '';
		});

		window.addEventListener('load', function() {
			receiverInput.disabled = (transactionSelect.value === 'credit');
		});

		transactionForm
				.addEventListener(
						'submit',
						function(e) {
							formErrorEl.classList.add('d-none');
							formErrorEl.innerText = '';

							const balance = parseFloat(accountBalanceEl.innerText) || 0;
							const amount = parseFloat(amountInput.value) || 0;
							const transactionType = transactionSelect.value;
							const receiver = receiverInput.value.trim();

							if (transactionType === 'transfer') {
								if (receiver === '') {
									e.preventDefault();
									formErrorEl.innerText = 'Please enter receiver account number for transfer.';
									formErrorEl.classList.remove('d-none');
									return;
								}

								if (receiver === accountNumber) {
									e.preventDefault();
									formErrorEl.innerText = 'You cannot transfer to your own account!';
									formErrorEl.classList.remove('d-none');
									return;
								}

								if (amount > balance) {
									e.preventDefault();
									formErrorEl.innerText = 'Insufficient balance! Your current balance is ₹'
											+ balance.toFixed(2);
									formErrorEl.classList.remove('d-none');
									return;
								}
							}
						});
	</script>

</body>
</html>
