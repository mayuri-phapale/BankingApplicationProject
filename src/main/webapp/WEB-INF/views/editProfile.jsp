<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<title>Edit Profile</title>
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
<body class="bg-light">

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
						<h4 class="mb-0">Edit Profile</h4>
					</div>
					<div class="card-body">
						<c:if test="${not empty ERRORS}">
							<div class="alert alert-danger">Please fix the errors
								below.</div>
						</c:if>

						<form id="editProfileForm"
							action="${pageContext.request.contextPath}/CustomerController"
							method="post" novalidate>
							<input type="hidden" name="form" value="editProfile" /> <input
								type="hidden" name="customerId"
								value="${THE_Customer.customerId}" />

							<div class="mb-3">
								<label for="firstName" class="form-label">First Name</label> <input
									type="text"
									class="form-control ${ERRORS.firstName != null ? 'is-invalid' : ''}"
									id="firstName" name="firstName"
									value="${THE_Customer.firstName}" pattern="[A-Za-z]{2,50}"
									required>
								<div class="invalid-feedback">
									<c:choose>
										<c:when test="${ERRORS.firstName != null}">${ERRORS.firstName}</c:when>
										<c:otherwise>First name should contain only letters (2-50 characters)</c:otherwise>
									</c:choose>
								</div>
							</div>

							<div class="mb-3">
								<label for="lastName" class="form-label">Last Name</label> <input
									type="text"
									class="form-control ${ERRORS.lastName != null ? 'is-invalid' : ''}"
									id="lastName" name="lastName" value="${THE_Customer.lastName}"
									pattern="[A-Za-z]{2,50}" required>
								<div class="invalid-feedback">
									<c:choose>
										<c:when test="${ERRORS.lastName != null}">${ERRORS.lastName}</c:when>
										<c:otherwise>Last name should contain only letters (2-50 characters)</c:otherwise>
									</c:choose>
								</div>
							</div>

							<div class="mb-3">
								<label for="mobileNumber" class="form-label">Mobile
									Number</label> <input type="text"
									class="form-control ${ERRORS.mobileNumber != null ? 'is-invalid' : ''}"
									id="mobileNumber" name="mobileNumber"
									value="${THE_Customer.mobileNumber}" pattern="\d{10}" required>

								<div class="invalid-feedback">
									<c:choose>
										<c:when test="${ERRORS.mobileNumber != null}">${ERRORS.mobileNumber}</c:when>
										<c:otherwise>Mobile number must be 10 digits</c:otherwise>
									</c:choose>
								</div>
							</div>

							<div class="mb-3">
								<label for="address" class="form-label">Address</label>
								<textarea
									class="form-control ${ERRORS.address != null ? 'is-invalid' : ''}"
									id="address" name="address" rows="3" required minlength="5"
									maxlength="100">${THE_Customer.address}</textarea>
								<div class="invalid-feedback">
									<c:choose>
										<c:when test="${ERRORS.address != null}">${ERRORS.address}</c:when>
										<c:otherwise>Address must be between 5 and 100 characters</c:otherwise>
									</c:choose>
								</div>
							</div>

							<button type="submit" class="btn btn-success w-100">Update
								Profile</button>
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
        const form = document.getElementById('editProfileForm');
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
