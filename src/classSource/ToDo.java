package classSource;

public class ToDo {
	private String title = "";
	private boolean isCompleted = false;
	private int id = 0;

	public ToDo(String title, boolean isCompleted, int id) {
		this.title = title;
		this.isCompleted = isCompleted;
		this.id = id;
	}
	
	public String getTitle() {
		return title;
	}
	
	public boolean getIsCompleted() {
		return isCompleted;
	}
	
	public int getId() {
		return id;
	}

	@Override
	public String toString() {
		return String.format("%s", title);
	}
}
