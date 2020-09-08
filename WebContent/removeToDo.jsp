<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.util.ArrayList, classSource.ToDo, java.sql.*" %>

<html>
	<head>
		<style>
			.container {
			  font-family: 'Architects Daughter', cursive;
			  font-size: 1.5em;
			}
			#navbarNav {
			  font-size: 1.7em;
			  margin-right:auto;
			  margin-left:auto;
			}
			#butSave {
			  font-size: 1em;
			  display: block;
			  margin-right:auto;
			  margin-left:auto;
			  margin-top: 20%;
			}
			#saveWarn {
			  font-size: 0.7em;
			  color: grey;
			  text-align: center;
			}
			#todo li {
			  list-style-type: none;
			  text-align: center;
			  padding: 20px;
			  margin-right: 40px;
			}
			.btn-danger {
			  margin-left: 3%;
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
      <li class="nav-item">
        <a class="nav-link" href="http://localhost:8080/ToDo/addToDo.jsp">Add</a>
      </li>
      <li class="nav-item active">
        <a class="nav-link" href="#">Remove</a>
      </li>
    </ul>
  </div>
</nav>

<div class="container">
	<ul class="todo" id="todo"></ul>
	<form action="toDoList.jsp" name="theForm">
		<input type="hidden" id="itemToRemove" value="" name="removeToDo"/>
	</form>
</div>
<script>
let jsToDoList = []
<% 
ArrayList<ToDo> toDoList = new ArrayList<>(); // list to store todo in
int count = 0;
String url = "jdbc:mysql://localhost:3306/todo";
String username = "root";
String password = "douglas";
String query = "SELECT * FROM to_do_list";
Class.forName("com.mysql.cj.jdbc.Driver"); 
Connection con = DriverManager.getConnection(url, username, password);
Statement st = con.createStatement();
ResultSet rs = st.executeQuery(query);
while (rs.next()) {
	toDoList.add(new ToDo(rs.getString(2), rs.getBoolean(3), rs.getInt(1)));
}

for(ToDo item: toDoList) {
	out.print("var toDoItem = {id: 0, title: '', isCompleted: false}");
	out.print("\ntoDoItem.id = " + item.getId());
	out.print(String.format("\ntoDoItem.title = \'%s\'", item.getTitle()));
	out.print(String.format("\ntoDoItem.isCompleted = %b", item.getIsCompleted()));
	out.print("\njsToDoList.push([toDoItem]);");
} %>	

function generateList() {
  let list = document.getElementById('todo');
  for (var i = 0; i < jsToDoList.length; i++) {
	let item = document.createElement('li');
	item.innerText = jsToDoList[i][0].title;
	let remove = document.createElement('button'); 
	remove.classList.add('remove');
	remove.innerText = 'X';
	remove.addEventListener("click", removeItem);
	remove.classList.add("btn");
	remove.classList.add("btn-danger");
	item.appendChild(remove); 
	list.appendChild(item);
  }
}
function removeItem() {
	  let item = this.parentNode
	  let title = item.innerText;
	  title = title.substring(0, title.length - 1);
	  console.log("removing " + title);
	  document.getElementById('itemToRemove').value = title;
	  let parent = item.parentNode;
	  parent.removeChild(item);
	  document.theForm.submit();
}

generateList();
</script>
</body>
</html>