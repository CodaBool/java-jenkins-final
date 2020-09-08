<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.ArrayList, classSource.ToDo, java.util.Collections" %>
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
		</style>
		<link href="https://fonts.googleapis.com/css2?family=Architects+Daughter&display=swap" rel="stylesheet"> 
		<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
	</head>
<body>
<%
	ArrayList<ToDo> toDoList = new ArrayList<>(); // list to store todo in
	int count = 0;
	boolean shouldSave = false;
	String url = "jdbc:mysql://localhost:3306/todo";
	String username = "root";
	String password = "douglas";
	String query = "SELECT * FROM to_do_list";
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection(url, username, password);
	Statement st = con.createStatement();
	ResultSet rs = st.executeQuery(query);
	while (rs.next()) {
		toDoList.add(new ToDo(rs.getString(2), rs.getBoolean(3), rs.getInt(1)));
	}
	String reqAdd = request.getParameter("addedToDo");
	String reqRemove = request.getParameter("removeToDo");
%>
<%!
	public int saveToDo(ArrayList<ToDo> toDoList, Connection con) {
		int count = 0;
		try {
			try {
				String query = "drop table to_do_list";
				PreparedStatement ps = con.prepareStatement(query);
				ps.executeUpdate();
				ps.close();
			} catch (SQLException e) {
				System.out.println("Query deletion error");
			}
			
			try {
				Statement st = con.createStatement();
				String query = "CREATE TABLE `todo`.`to_do_list` (`id` INT NOT NULL, `title` VARCHAR(255) NULL, `is_completed` TINYINT NULL, PRIMARY KEY (`id`));";
				st.executeUpdate(query);
				st.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			String query = "insert into to_do_list values(?, ?, ?);";
			PreparedStatement ps = con.prepareStatement(query);
			for (ToDo item: toDoList) {
				ps.setInt(1, item.getId());
				ps.setString(2, item.getTitle());
				ps.setBoolean(3, item.getIsCompleted());
				ps.executeUpdate();
			}
			
			ps.close();
			
		} catch (SQLException e) {
			System.out.println("Query insert error");
		} 
		return count;
	}
%>
<%!
	public static void addToDo(ArrayList<ToDo> toDoList, String title, boolean isCompleted) { // add data to toDoList with isCompleted specified
		int highestId = 0;
		ArrayList<Integer> usedIds = new ArrayList<>();
		for (ToDo item: toDoList) {
			usedIds.add(item.getId());
		}
		if (usedIds.size() > 0) {
			highestId = Collections.max(usedIds);
		}

		toDoList.add(new ToDo(title, isCompleted, highestId + 1));
	}
%>
<%! 
	public static void removeToDo(ArrayList<ToDo> toDoList, String title) {
	    for (int i = 0; i < toDoList.size(); i++) {
	        if (toDoList.get(i).getTitle().equals(title)) {
	        	toDoList.remove(i);
	        }
	    } 
	}
%>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <div id="navbarNav">
    <ul class="navbar-nav">
      <li class="nav-item active">
        <a class="nav-link" href="#">My List</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="http://localhost:8080/ToDoApp/addToDo.jsp">Add</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="http://localhost:8080/ToDoApp/removeToDo.jsp">Remove</a>
      </li>
    </ul>
  </div>
</nav>
<div class="container">
  <ul class="todo" id="todo"></ul>
  <button type="button" class="btn btn-light" onclick="save()" id="butSave">Save</button>
  <p id="saveWarn">Up to Date list</p>
</div>
<script>
let jsToDoList = []
<% if (reqAdd != null) {
    if(reqAdd.contains("\'")) {
    	reqAdd = reqAdd.replace("\'", "&#39;");
    }
    if(reqAdd.contains("\"")) {
    	reqAdd = reqAdd.replace("\"", "&#39;");
    }
    
	out.print("\nconsole.log(\"req Added: " + reqAdd + "\");");
	addToDo(toDoList, reqAdd, false); 
	out.print("\nlet saveBut = document.getElementById('butSave');\nsaveBut.classList.add('btn-warning');\nsaveBut.classList.remove('btn-light');"); // add waring class to save button
	out.print("\nlet saveP = document.getElementById('saveWarn');\nsaveP.innerHTML = 'Please save the added To Do';");
}

for(ToDo item: toDoList) {
	out.print("\nvar toDoItem = {id: 0, title: '', isCompleted: false}");
	out.print("\ntoDoItem.id = " + item.getId());
	out.print(String.format("\ntoDoItem.title = \'%s\'", item.getTitle()));
	out.print(String.format("\ntoDoItem.isCompleted = %b", item.getIsCompleted()));
	out.print("\njsToDoList.push([toDoItem]);");
}  %>

let list = document.getElementById('todo');
for (var i = 0; i < jsToDoList.length; i++) {
	let item = document.createElement('li');
	item.innerHTML = jsToDoList[i][0].title;
	list.appendChild(item);
}

<% if (reqRemove != null) {
	out.print("\n\nconsole.log(\"req Removed: " + reqRemove + "\");");
	if (reqRemove.length() >= 1) {
		removeToDo(toDoList, reqRemove);
		out.print("\nlet listItems = document.getElementsByTagName(\"LI\");\n for (let li of listItems) {\n if (li.innerText == \"" + reqRemove + "\") {\n  let parent = li.parentNode;\n  parent.removeChild(li);\n }\n} ");
		out.print("\nlet saveP = document.getElementById('saveWarn');\nsaveP.innerHTML = 'Please save the removed To Do';");
		out.print("\nlet saveBut = document.getElementById('butSave');\nsaveBut.classList.add('btn-warning');\nsaveBut.classList.remove('btn-light');"); // add waring class to save button
	}
} %>	


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

function addToList() {
	let list = document.getElementById('todo');
	let item = document.createElement('li');
	item.innerText = document.getElementById('inputField').value;
	let remove = document.createElement('button');
	remove.classList.add('remove');
	remove.innerText = 'X';
	remove.addEventListener("click", removeItem);
	item.appendChild(remove); 
	list.appendChild(item);
}

const delay = ms => new Promise(res => setTimeout(res, ms));
async function save() {
	<%  saveToDo(toDoList, con); 
	out.print("\nconsole.log(\"Saving new toDoList\");");
	out.print("\nlet saveP = document.getElementById('saveWarn');\nsaveP.innerHTML = 'SAVING...takes 3 seconds';"); %>	
	await delay(3000);
	window.location = "http://localhost:8080/ToDoApp/toDoList.jsp"; // prevents readding old todo with POST
}
</script>
</body>
</html>