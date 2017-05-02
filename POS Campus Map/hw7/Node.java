package hw7;

import java.util.*;

public class Node {
	
	public String name;
	public String id;
	public int x;
	public int y;
	
	/** @param name The name of the node
	 *  @param id The id of the node
	 *  @param x The x coordinate of the node
	 *  @param y The y coordinate of the node
	 *  @effects Creates a new node with the given information
	 */
	public Node(String name, String id, int x, int y) {
		this.name = name;
		this.id = id;
		this.x = x;
		this.y = y;
	}
	
	/** @return All of the node's information in one string
	 */
	/*
	public String toString() {
		return name  + "," + id + "," + x + "," + y;
	}
	*/
	
	/** @return The name and id of the node in one string 
	 */
	public String list() {
		return name + "," + id;
	}
	
	// A new comparator to compare nodes based on alphebetical order of names
	public static Comparator<Node> nodeCompare = new Comparator<Node>() {
		
		/** @param n1 Node 1
		 *  @param n2 Node 2
		 *  @returns The comparison between both node's names
		 */
		public int compare(Node n1, Node n2) {
			String n1Name = n1.name;
			String n2Name = n2.name;
			
			return n1Name.compareTo(n2Name);
		}
		
	};
	
	/** @param n1
	 *  @param n2
	 *  @return The distance between the two nodes
	 */
	public static double distance(Node n1, Node n2) {
		int x1 = n1.x;
		int y1 = n1.y;
		int x2 = n2.x;
		int y2 = n2.y;
		
		double dx = Math.abs(x1-x2);
		double dy = Math.abs(y1-y2);
		
		dx = dx * dx;
		dy = dy * dy;
		
		return Math.sqrt(dx + dy);
	}

}
