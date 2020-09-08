<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.util.ArrayList" %>

<html>
	<head>
		<style>
			.container {
			  font-family: 'Architects Daughter', cursive;
			  font-size: 1.5em;
			  text-align: center;
			  margin-top: 5%;
			}
			#navbarNav {
			  font-size: 1.7em;
			  margin-right:auto;
			  margin-left:auto;
			}
			#todo li {
			  list-style-type: none;
			  text-align: center;
			  padding: 20px;
			  margin-right: 40px;
			}
			#inputField {
				border: none;
			}
		</style>
		<link href="https://fonts.googleapis.com/css2?family=Architects+Daughter&display=swap" rel="stylesheet"> 
		<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
	</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <div id="navbarNav">
    <ul class="navbar-nav">
      <li class="nav-item">
        <a class="nav-link" href="http://localhost:8080/ToDo/toDoList.jsp">My List</a>
      </li>
      <li class="nav-item active">
        <a class="nav-link" href="#">Add</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="http://localhost:8080/ToDo/removeToDo.jsp">Remove</a>
      </li>
    </ul>
  </div>
</nav>
<div class="container">
	<form action="toDoList.jsp" name="theForm">
		<input placeholder="enter todo" id="inputField" name="addedToDo"/>
		<button type="button" id="butAdd" class="btn btn-success" onclick="beforeSubmit();">Add</button> 
	</form>
</div>
<script>

function beforeSubmit() {
	var title = document.getElementById('inputField').value;
    if(title.includes("\'")) {
      title = title.replace("\'", "&#39;");
    }
    
    if(title.includes("\"")) {
      title = title.replace("\"", "&#39;");
    }

    document.getElementById('inputField').value = title;
	document.theForm.submit();
}

</script>
</body>
</html>