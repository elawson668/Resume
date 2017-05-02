package hw7;

import hw7.*;
import java.io.*;
import java.util.*;

public class CampusParser {
	
	// CampusParser does not represent an ADT
	
	/** @param nodes The empty set of nodes
	 *  @param edges The empty list of edges
	 *  @param names The empty map of names to nodes
	 *  @param ids The empty map of ids to nodes
	 *  @effects Reads in the nodes and edges and places them in the set, list, and maps
	 *  @throws IOException if the node and edge files don't exist
	 */
	public static void readData(Set<Node> nodes, ArrayList<ArrayList<String>> edges, 
								Map<String, Node> names, Map<String, Node> ids) 
			throws IOException {
		
		BufferedReader nodeReader = new BufferedReader(new FileReader("hw7/data/RPI_map_data_Nodes.csv"));
		String line = null;
		
		// Read in node data
        while((line = nodeReader.readLine()) != null) {      	
        	int first = line.indexOf(",");
        	String name = line.substring(0,first);
        	
        	int second = line.indexOf(",",first+1);
        	String id = line.substring(first+1,second);
        	
        	int third = line.indexOf(",",second+1);
        	int x = Integer.parseInt(line.substring(second+1,third));
        	
        	int y = Integer.parseInt(line.substring(third+1,line.length()));
        	
        	Node n = new Node(name,id,x,y);
        	
        	nodes.add(n);
        	
        	// Update maps
        	names.put(name, n);
        	ids.put(id, n);
        }
        
        BufferedReader edgeReader = new BufferedReader(new FileReader("hw7/data/RPI_map_data_Edges.csv"));
        line = null;
        
        while((line = edgeReader.readLine()) != null) {
        	int i = line.indexOf(",");
        	String id1 = line.substring(0,i);
        	String id2 = line.substring(i+1,line.length());
        	
        	Node n1 = null,n2 = null;
        	
        	// Find nodes corresponding to edge ids
        	Iterator<Node> itr = nodes.iterator();
        	while(itr.hasNext()) {
        		Node n = itr.next();
        		
        		if(n.id.equals(id1)) { 
        			n1 = n;
        		}
        		if(n.id.equals(id2)) {
        			n2 = n;
        		}
        	}
        	
        	double dist = Node.distance(n1,n2);
        	
        	// Create edges both ways
        	ArrayList<String> edge = new ArrayList<String>();
        	
        	edge.add(id1);
        	edge.add(id2);
        	edge.add(Double.toString(dist));
        	edges.add(edge);
        	
        	edge = new ArrayList<String>();
        	edge.add(id2);
        	edge.add(id1);
        	edge.add(Double.toString(dist));
        	edges.add(edge);
        	
        	
        }
        
       
	}

}
