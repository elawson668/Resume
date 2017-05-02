package hw7;

import java.io.*;
import java.util.*;

import hw7.*;

public class CampusModel {
	
	private static Graph2 campus;
	private static Map<String,Node> names;
	private static Map<String,Node> ids;
	
	// CampusModel does not represent an ADT
	
	/** @effects Create the graph
	 */
	public static void createGraph() {
		Set<Node> nodes = new HashSet<Node>();
		ArrayList<ArrayList<String>> edges = new ArrayList<ArrayList<String>>();
		
		// Maps from a name to a node and an id to a node
		names = new HashMap<String,Node>();
		ids = new HashMap<String,Node>();
		
		try {
			CampusParser.readData(nodes,edges,names,ids);
		} catch (IOException e) {e.printStackTrace();}
		
		campus = new Graph2(nodes,edges);

	}
	
	/** @param startId The id of the starting building
	 *  @param destId The id of the destination building
	 *  @return The shortest path from start to dest
	 */
	private static Path djikstra(String startId, String destId) {
		PriorityQueue<Path> active = new PriorityQueue<Path>(new PathCompare());
		Set<String> finished = new HashSet<String>();
		
		Path finalPath = new Path();
		
		ArrayList<ArrayList<String>> edges = campus.getEdges();
		ArrayList<ArrayList<String>> nmEdges = new ArrayList<ArrayList<String>>();
		
		// Create path from start to itself with weight 0.0, insert into queue
		Path initialPath = new Path();
		ArrayList<String> initialEdge = new ArrayList<String>();
		initialEdge.add(startId);
		initialEdge.add(startId);
		initialEdge.add("0");
		initialPath.addEdge(initialEdge);
		
		active.add(initialPath);
		
		
		while(!active.isEmpty()) {
			
			// Remove min weight path from queue
			Path minPath = active.remove();
			
			ArrayList<ArrayList<String>> path = minPath.getPath();
			String minDest = path.get(path.size() - 1).get(1);
			
			// If minDest is final dest, shortest path found
			if(minDest.equals(destId)) {
				finalPath = minPath;
				break;
			}
			
			// if minDest is finished, skip it
			if(finished.contains(minDest)) {
				continue;
			}
			
			// Find all minDest,child edges
			for(int i = 0; i < edges.size(); i++) {
				if(edges.get(i).get(0).equals(minDest)) {
					nmEdges.add(edges.get(i));
				}
			}
			
			// For all minDest,child edges
			for(int i  = 0; i < nmEdges.size(); i++) {
				
				ArrayList<String> edge = nmEdges.get(i);
				String child = edge.get(1);
				
				// If child not finished
				if(!finished.contains(child)) {
					
					// Create new path = minPath + edge, add to queue
					Path newPath = new Path(minPath);
					newPath.addEdge(edge);
					
					active.add(newPath);

				}
				
			}
			
			// minDest is finished
			finished.add(minDest);			
		}
		
		return finalPath;
	}
	
	/** @param s The name/id of the start
	 *  @param d The name/id of the dest
	 *  @return The shortest path from start to dest
	 */
	public static Path findPath(String s, String d) {
		
		// Find nodes corressponding to name/id
		Node start = ids.get(s);
		if(start == null) {
			start = names.get(s);
		}
		
		Node dest = ids.get(d);
		if(dest == null) {
			dest = names.get(d);
		}
		
		String sId = start.id;
		String dId = dest.id;
		
		return djikstra(sId,dId);
		
	}
	
	/** @return A sorted list of all buildings in the graph
	 */
	public static ArrayList<String> listBuildings() {
		
		ArrayList<String> buildings = new ArrayList<String>();
		
		Iterator<Node> itr = campus.listNodes();
		while(itr.hasNext()) {
			buildings.add(itr.next().list());
		}
		
		// Remove intersections from list
		for(int i = buildings.size() - 1; i >= 0; i--) {
			if(buildings.get(i).substring(0,1).equals(",")) {
				buildings.remove(i);
			}
		}
		
		return buildings;
	}
	
	/** @param id The id of the building
	 *  @return The name of the building
	 */
	public static String getName(String id) {
		String name = ids.get(id).name;
		if(name.equals("")) {
			name = "Intersection " + id;
		}
		return name;
	}
	
	/** @param node A building
	 *  @return Whether or not the building is present in the graph
	 */
	public static boolean exists(String node) {
		boolean isName = true;
		if(names.get(node) == null) {
			isName = false;
		}
		
		boolean isId = true;
		if(ids.get(node) == null) {
			isId = false;
		}
		
		if(isId) {
			if(ids.get(node).name.equals("")) {
				isId = false;
			}
		}
		
		return (isName || isId);
	
	}
	
	/** @param id1 The id of the first building
	 *  @param id2 The id of the second building
	 *  @return The direction of the second building from the first building
	 */
	public static String getDirection(String id1, String id2) {
		Node n1 = ids.get(id1);
		Node n2 = ids.get(id2);
		
        double angle; // = Math.toDegrees(Math.acos((n1.y-n2.y)/distance(n1.x,n1.y,n2.x,n2.y)));
        if (n1.x < n2.x) { // We are in the East semicircle
            angle = Math.toDegrees(Math.acos((n1.y-n2.y)/Node.distance(n1,n2)));
            if (0 <= angle && angle < 22.5) 
                return "North";
            else if (22.5 <= angle && angle < 67.5)
                return "NorthEast";
            else if (67.5 <= angle && angle < 112.5)
                return "East";
            else if (112.5 <= angle && angle < 157.5)
                return "SouthEast";
            else 
                return "South";
        }
        else {
            angle = Math.toDegrees(Math.acos(-(n1.y-n2.y)/Node.distance(n1,n2)));
            if (0 <= angle && angle < 22.5) 
                return "South";
            else if (22.5 <= angle && angle < 67.5)
                return "SouthWest";
            else if (67.5 <= angle && angle < 112.5)
                return "West";
            else if (112.5 <= angle && angle < 157.5)
                return "NorthWest";
            else 
                return "North";
        }
	}
	
	/*
	public static void main(String args[]) {
		createGraph();
		
		
		Iterator<Node> itr = campus.listNodes();
		
		while(itr.hasNext()) {
			System.out.println(itr.next());
		}
		
		
		ArrayList<ArrayList<String>> edges = campus.getEdges();
		for(int i = 0; i < edges.size(); i++) {
			ArrayList<String> edge = edges.get(i);
			System.out.println(edge);
		}
		
		
		Path p = findPath("Troy Building","11");
		
		ArrayList<ArrayList<String>> path = p.getPath();
		System.out.println(path);
	
	}
	*/

}
