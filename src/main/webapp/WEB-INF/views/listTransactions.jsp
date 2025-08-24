<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Transaction History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">
    <h3>Transaction History</h3>

    <c:choose>
        <c:when test="${empty transactions}">
            <p>No transactions found.</p>
        </c:when>
        <c:otherwise>
            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Account</th>
                        <th>Type</th>
                        <th>Amount</th>
                        <th>Description</th>
                        <th>Date/Time</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${transactions}" var="t" varStatus="s">
                        <tr>
                            <td>${s.count}</td>
                            <td>${t.accountNumber}</td>
                            <td>${t.type}</td>
                            <td>${t.amount}</td>
                            <td>${t.description}</td>
                            <td>${t.createdAt}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>

    <a href="${pageContext.request.contextPath}/CustomerController" class="btn btn-secondary">Back</a>
</body>
</html>
