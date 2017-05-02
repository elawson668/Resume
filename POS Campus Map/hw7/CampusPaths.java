package hw7;

import java.util.*;

import hw7.*;

public class CampusPaths {
	
	// CampusPaths does not represent an ADT
	
	/** @effects Prints a sorted list of the buildings
	 */
	public static void listBuildings() {
		ArrayList<String> buildings = CampusModel.listBuildings();
		
		for(int i = 0; i < buildings.size(); i++) {
			System.out.println(buildings.get(i));
		}
		
	}
	
	/** @param start The starting building
	 *  @param dest The destination building
	 *  @effects Prints the shortest path from short to dest
	 */
	public static void shortestPath(String start, String dest) {
		
		// Check if start and dest exist
		boolean unknown = false;
		if(!CampusModel.exists(start)) {
			unknown = true;
			System.out.println("Unknown building: [" + start + "]");
		}
		if(!start.equals(dest)) {
			if(!CampusModel.exists(dest)) {
				unknown = true;
				System.out.println("Unknown building: [" + dest + "]");
			}
		}
		if(unknown) {
			return;
		}
		
		
		String output = "";
		
		Path shortest = CampusModel.findPath(start,dest);
		ArrayList<ArrayList<String>> path = shortest.getPath();
		
		// Check if no path exists
		if(path.isEmpty()) {
			System.out.println("There is no path from " + start + " to " + dest + ".");
			return;
		}
		
		
		String startId = path.get(0).get(0);
		String destId = path.get(path.size() - 1).get(1);
		
		output += "Path from " + CampusModel.getName(startId) + " to " +
		          CampusModel.getName(destId) + ":\n";
		
		for(int i = 1; i < path.size(); i++) {
			String locId = path.get(i).get(1);
			
			String direction = CampusModel.getDirection(path.get(i).get(0),locId);
			
			output += "\tWalk " + direction + " to (" + CampusModel.getName(locId) + ")\n";
		}
		
		String totalCost = String.format("%.3f", shortest.getCost());
		
		output += "Total distance: " + totalCost + " pixel units.";
		
		System.out.println(output);
		
		
	}
	
	/** @effects Prints out the menu of commands
	 */
	public static void printCommands() {
		System.out.println("Type \"b\" to list all buildings");
		System.out.println("Type \"r\" to find shortest path");
		System.out.println("Type \"q\" to quit");
		System.out.println("Type \"m\" to print all commands");
	}
	
	public static void main(String args[]) {
		CampusModel.createGraph();
		
		Scanner reader = new Scanner(System.in);
		
		String in = "";
		while(true) {
			in = reader.nextLine();
			
			if(in.equals("b")) {
				listBuildings();
			}
			
			else if(in.equals("r")) {
				String start = "";
				String dest = "";
				
				System.out.print("First building id/name, followed by Enter: ");
				start = reader.nextLine();
				System.out.print("Second building id/name, followed by Enter: ");
				dest = reader.nextLine();
				
				shortestPath(start,dest);
			}
			
			else if(in.equals("m")) {
				printCommands();
			}
			
			else if(in.equals("q")) {
				return;
			}
			
			else {
				System.out.println("Unknown option");
			}
			
		}
	}
	

}
