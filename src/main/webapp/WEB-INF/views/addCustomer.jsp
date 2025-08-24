<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<title>Add Customer</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<style>
body {
	padding-top: 70px;
}

.card {
	border-radius: 10px;
}

.navbar {
	background-color: #1f2937 !important;
}

@media ( max-width : 576px) {
	.card {
		margin: 0 10px;
	}
}
</style>
</head>
<body class="bg-light">

	<nav class="navbar navbar-dark bg-dark fixed-top">
		<div class="container-fluid">
			<span class="navbar-text text-white"> Welcome, <strong>${sessionScope.username}</strong>
			</span> <a
				href="${pageContext.request.contextPath}/AdminController?form=dashboard"
				class="btn btn-outline-secondary btn-sm text-white">Dashboard</a>
		</div>
	</nav>

	<div class="container mt-4">
		<div class="row justify-content-center">
			<div class="col-lg-6 col-md-7 col-sm-10">
				<div class="card shadow-sm">
					<div class="card-header text-center">
						<h4 class="mb-0">Add Customer</h4>
					</div>
					<div class="card-body">
						<c:if test="${not empty message}">
							<div class="alert alert-danger">${message}</div>
						</c:if>

						<form id="addCustomerForm"
							action="${pageContext.request.contextPath}/AdminController"
							method="post" novalidate>
							<input type="hidden" name="command" value="ADD" />

							<div class="row mb-3">
								<div class="col">
									<label for="firstName" class="form-label">First Name</label> <input
										type="text"
										class="form-control ${errors.firstName != null ? 'is-invalid' : ''}"
										id="firstName" name="firstName"
										value="${form_data.firstName != null ? form_data.firstName : ''}"
										pattern="[A-Za-z]{2,50}" required>
									<div class="invalid-feedback">
										<c:choose>
											<c:when test="${errors.firstName != null}">${errors.firstName}</c:when>
											<c:otherwise>First name should contain only letters (2-50 characters)</c:otherwise>
										</c:choose>
									</div>
								</div>

								<div class="col">
									<label for="lastName" class="form-label">Last Name</label> <input
										type="text"
										class="form-control ${errors.lastName != null ? 'is-invalid' : ''}"
										id="lastName" name="lastName"
										value="${form_data.lastName != null ? form_data.lastName : ''}"
										pattern="[A-Za-z]{2,50}" required>
									<div class="invalid-feedback">
										<c:choose>
											<c:when test="${errors.lastName != null}">${errors.lastName}</c:when>
											<c:otherwise>Last name should contain only letters (2-50 characters)</c:otherwise>
										</c:choose>
									</div>
								</div>
							</div>


							<div class="row mb-3">
								<div class="col">
									<label for="email" class="form-label">Email</label> <input
										type="email"
										class="form-control ${errors.email != null ? 'is-invalid' : ''}"
										id="email" name="email"
										value="${form_data.email != null ? form_data.email : ''}"
										required>
									<div class="invalid-feedback">
										<c:choose>
											<c:when test="${errors.email != null}">${errors.email}</c:when>
											<c:otherwise>Enter a valid email</c:otherwise>
										</c:choose>
									</div>
								</div>

								<div class="col">
									<label for="password" class="form-label">Password</label> <input
										type="password"
										class="form-control ${errors.password != null ? 'is-invalid' : ''}"
										id="password" name="password" required>
									<div class="invalid-feedback">
										<c:choose>
											<c:when test="${errors.password != null}">${errors.password}</c:when>
											<c:otherwise>Password is required</c:otherwise>
										</c:choose>
									</div>
								</div>
							</div>


							<div class="mb-3">
								<label for="mobileNumber" class="form-label">Mobile
									Number</label> <input type="text"
									class="form-control ${errors.mobileNumber != null ? 'is-invalid' : ''}"
									id="mobileNumber" name="mobileNumber"
									value="${form_data.mobileNumber != null ? form_data.mobileNumber : ''}"
									pattern="\d{10}" required>
								<div class="invalid-feedback">
									<c:choose>
										<c:when test="${errors.mobileNumber != null}">${errors.mobileNumber}</c:when>
										<c:otherwise>Mobile number must be 10 digits</c:otherwise>
									</c:choose>
								</div>
							</div>

							<div class="mb-3">
								<label for="address" class="form-label">Address</label>
								<textarea
									class="form-control ${errors.address != null ? 'is-invalid' : ''}"
									id="address" name="address" rows="3" required minlength="5"
									maxlength="100">${form_data.address != null ? form_data.address : ''}</textarea>
								<div class="invalid-feedback">
									<c:choose>
										<c:when test="${errors.address != null}">${errors.address}</c:when>
										<c:otherwise>Address must be between 5 and 100 characters</c:otherwise>
									</c:choose>
								</div>
							</div>

							<button type="submit" class="btn btn-success">Add
								Customer</button>
							<a class="btn btn-secondary"
								href="${pageContext.request.contextPath}/AdminController?form=dashboard">Cancel</a>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
	<script>
(() => {
    'use strict';
    const form = document.getElementById('addCustomerForm');
    form.addEventListener('submit', function(event) {
        if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
        }
        form.classList.add('was-validated');
    }, false);
})();
</script>

</body>
</html>
