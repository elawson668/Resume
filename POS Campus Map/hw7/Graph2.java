package hw7;

import java.util.*;

public class Graph2 {
	
	private Set<Node> nodes;
	private ArrayList<ArrayList<String>> edges;

	// Representation Invariant:
	// For every edge in edges: edge[0],edge[1] are in nodes
	
	
	// Abstraction Function:
	// G = {nodes,edges | nodes = {n_1,n_2,...,n_k}, edges = {(a,b,l)|a,b are in nodes}}
	
	/** @param nodes The set of nodes
	 *  @param edges The list of edges
	 *  @effects creates a new Graph with given nodes,edges,labels
	 */
	public Graph2(Set<Node> nodes, ArrayList<ArrayList<String>> edges) {
		this.nodes = new HashSet<Node>(nodes);
		this.edges = new ArrayList<ArrayList<String>>(edges);
		
		//checkRep();
	}

	/** 
	 * Checks that the representation invariant holds (if any)
	 */
	/*
	private void checkRep() throws RuntimeException {
		boolean complies = true;
		
		for(int i = 0; i < edges.size(); i++) {
			String left = edges.get(i).get(0);
			String right = edges.get(i).get(1);
			
			Iterator<Node> itr = nodes.iterator();
			boolean leftExists = false;
			boolean rightExists = false;
			while(itr.hasNext()) {
				Node n = itr.next();
				if(n.id.equals(left)) {
					leftExists = true;
				}
				if(n.id.equals(right)) {
					rightExists = true;
				}
			}
			
			if(!(leftExists && rightExists)) {
				complies = false;
			}
		}
		
		if(!complies) {
			throw new RuntimeException("Representation invariant broken");
		}
	}
	*/
	
	/** @return An iterator which returns the nodes in alphabetical order
	 */
	public Iterator<Node> listNodes() {
		if(nodes.isEmpty()) {
			return null;
		}
		
		ArrayList<Node> sorted = new ArrayList<Node>();
		
		Iterator<Node> it = nodes.iterator();
		while(it.hasNext()) {
			sorted.add(it.next());
		}
		
		Collections.sort(sorted, Node.nodeCompare);
		
		return sorted.iterator();
		
		
	}
	
	
	/** @return The size of the graph
	 **/
	/*
	public int getSize() {
		return edges.size();
	}
	*/
	
	/** @return The order of the graph
	 */
	/*
	public int getOrder() {
		return nodes.size();
	}
	*/
	
	/** @return A copy of nodes
	 */
	/*
	public Set<Node> getNodes() {
		Set<Node> nodescpy = new HashSet<Node>(nodes);
		return nodescpy;
	}
	*/
	
	/** @return A copy of edges
	 */
	public ArrayList<ArrayList<String>> getEdges() {
		ArrayList<ArrayList<String>> edgescpy = new ArrayList<ArrayList<String>>(edges);
		return edgescpy;
	}
	
	
}
