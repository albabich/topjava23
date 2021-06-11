<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Meal</title>
</head>
<body>
<h3><a href="index.html">Home</a></h3>
<hr>
<h2>${param.action=="create"? "Create": "Update"} Meal</h2>
<jsp:useBean id="meal" type="ru.javawebinar.topjava.model.Meal" scope="request"/>
<form method="post" action="meals">
    <input type="hidden" name="id" value="${meal.id}">
    DateTime: <input type="datetime-local" name="dateTime" value="${meal.dateTime}"><br><br>
    Description: <input type="text" name="description" value="${meal.description}"><br><br>
    Calories: <input type="number" name="calories" value="${meal.calories}"><br><br>
    <input type="submit" value="${param.action=="create"? "Create": "Update"}">
</form>
</body>
</html>