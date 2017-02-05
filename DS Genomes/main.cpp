#include <cstring>
#include <fstream>
#include <iostream>
#include <map>
#include <string>
#include <vector>

int main() {

	std::string genome;									// String representing the genome
	std::map<std::string,std::vector<int> >  kmers;		// Map of kmers; first is the kmer, second is a vector of its locations
	int k;												// Kmer size

	std::string command;
	std::cin >> command;

	while(command != "quit") {

		// Genome command
		if(command == "genome") {
			std::string f;
			std::cin >> f;
			std::ifstream file(f.c_str());
			while(!file.eof()) {
				std::string temp;
				file >> temp;
				genome += temp;
			}
		}

		// Kmer command
		else if(command == "kmer") {
			std::cin >> k;
			// Loop through all kmers in genome, add to map or add location 
			for(int i = 0; i < genome.size() - k; i++) {
				kmers[genome.substr(i,k)].push_back(i);
			}
		}

		// Query command
		else if(command == "query") {
			int mis;	// Number of mismatches allowed
			std::string query;
			std::cin >> mis >> query;

			std::cout << "Query:" << " " << query << std::endl;

			std::string seed = query.substr(0,k);	// Set seed
			std::map<std::string,std::vector<int> >::const_iterator locs_it = kmers.find(seed);	// Location of the seed in map
 
			bool found = false;		// Bool representing if any acceptable results are found
			// If the seed does not exist in the genome, there is no match
			if(locs_it == kmers.end()) {
				std::cout << "No Match" << std::endl;
			}
			else {
				// Access the vector of locations 
				std::vector<int> locs = locs_it->second;
				// Loop through all locations 
				for(int i = 0; i < locs.size(); i++) {
					int loc = locs[i];		// Access current location
					int misses = 0;			// Number of mismatches so far
					// Loop through query, count mismatches 
					for(int j = 0; j < query.size(); j++) {
						if(genome[loc+j] != query[j]) {
							misses++;
						}
					}
					// If too many mismatches, move to next location
					if(misses > mis) {
						continue;
					}
					// Print if acceptable location found
					else {
						found = true;
						std::cout << locs[i] << " " << misses << " " << genome.substr(locs[i],query.size()) << std::endl;
					}
				}
			}

			// If no acceptable locations were found, there is no match
			if(!found && locs_it != kmers.end()) {
				std::cout << "No Match" << std::endl;
			}
		}
		std::cin >> command;
	}
	return 1;
}



