<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Login</title>
<!-- Bootstrap 5 CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<!-- Bootstrap Icons -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>

<body class="bg-light">

	<!-- Navbar -->
	<nav class="navbar navbar-dark bg-dark">
		<div class="container">
			<a class="navbar-brand" href="#"><i class="bi bi-bank"></i>
				MyBankPortal</a>
		</div>
	</nav>

	<!-- Login Form Container -->
	<div class="d-flex align-items-center justify-content-center vh-100"
		style="margin-top: -58px;">
		<c:if test="${not empty sessionScope.message}">
			<div id="alertMessage"
				class="alert ${sessionScope.messageType == 'success' ? 'alert-success' : 'alert-danger'} 
         position-fixed top-0 end-0 m-3"
				role="alert" style="width: 300px;">${sessionScope.message}</div>
			<c:remove var="message" scope="session" />
			<c:remove var="messageType" scope="session" />
		</c:if>

		<div class="card shadow-lg p-4"
			style="width: 400px; border-radius: 15px;">
			<h3 class="text-center mb-3">Login</h3>

			<!-- Error message -->
			<c:if test="${not empty errorMessage}">
				<div class="alert alert-danger text-center">${errorMessage}</div>
			</c:if>

			<!-- Login Form -->
			<form method="post" action="${pageContext.request.contextPath}/auth">
				<input type="hidden" name="action" value="login">

				<!-- Username / Email -->
				<div class="mb-3">
					<label class="form-label">Email / Username</label> <input
						type="text" name="username" class="form-control"
						placeholder="Enter email or username" required>
				</div>

				<!-- Password -->
				<div class="mb-3">
					<label class="form-label">Password</label> <input type="password"
						name="password" class="form-control" placeholder="Enter password"
						required>
				</div>

				<!-- Role -->
				<div class="mb-3">
					<label class="form-label">Role</label> <select name="role"
						class="form-select" required>
						<option value="" disabled selected>-- Select Role --</option>
						<option value="admin">Admin</option>
						<option value="customer">Customer</option>
					</select>
				</div>

				<!-- Submit Button -->
				<div class="d-grid">
					<button type="submit" class="btn btn-primary">Login</button>
				</div>
			</form>
		</div>
	</div>

	<!-- Bootstrap 5 JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-ndDqU0Gzau9qJ1lfW4pNLlhNTkCfHzAVBReH9diLvGRem5+R9g2FzA8ZGN954O5Q"
		crossorigin="anonymous"></script>
	<script>
		setTimeout(function() {
			const alert = document.getElementById('alertMessage');
			if (alert)
				alert.style.display = 'none';
		}, 3000);
	</script>

</body>
</html>
