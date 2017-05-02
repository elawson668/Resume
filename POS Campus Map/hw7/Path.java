package hw7;

import java.util.*;

public class Path {
	
	private ArrayList<ArrayList<String>> path;
	private double cost;
	
	// Representation Invariant:
	// Start of each edge is the dest of the previous edge
	// cost = sum of costs in path
	
	// Abstraction Function:
	// path is a list of edges from a start to a dest with edge weights
	
	
	/** @effects Creates a new empty path
	 */
	public Path() {
		path = new ArrayList<ArrayList<String>>();
		cost = 0;
		
		//checkRep();
	}
	
	/**
	 * @param p An existing path
	 * @effects Creates a new path using the info from an existing one
	 */
	public Path(Path p) {
		path = p.getPath();
		cost = p.getCost();
		
		//checkRep();
		
	}
	
	/*
	private void checkRep() {
		
		if(path.isEmpty()) {
			return;
		}
		
		float totalCost = Float.parseFloat(path.get(0).get(2));
		
		for(int i = 1; i < path.size(); i++) {
			totalCost += Float.parseFloat(path.get(i).get(2));
			
			String start = path.get(i).get(0);
			String prevDest = path.get(i-1).get(1);
			
			if(!(start.equals(prevDest))) {
				throw new RuntimeException("Path not correct");
			}
			
		}
		
		if(totalCost != cost) {
			System.out.println(cost);
			System.out.println(totalCost);
			throw new RuntimeException("Cost not correct");
		}
	}
	*/
	
	
	/** @param edge The edge to be added
	 *  @modifies this
	 *  @effects Adds edge to the end of the path
	 */
	public void addEdge(ArrayList<String> edge) {
		path.add(new ArrayList<String>(edge));
		cost += Double.parseDouble(edge.get(2));
		
		//checkRep();
	}
	
	/** @return A copy of the path
	 */
	public ArrayList<ArrayList<String>> getPath() {
		return new ArrayList<ArrayList<String>>(path);
	}
	
	/** @return The total cost of the path
	 */
	public double getCost() {
		return cost;
	}
	
}

