package hw7;

import java.util.*;
import hw7.*;

public class PathCompare implements Comparator<Path> {
	
	// A comparator to compare paths based on total cost
	@Override
	public int compare(Path p1, Path p2) {
		return Double.compare(p1.getCost(), p2.getCost());
	}

}
