#include <fstream>
#include <iomanip>
#include <iostream>
#include <vector>
#include <cstdlib>
#include <cstring>

// Replace the specified char in the data with the other specified char
void replace(std::vector<std::string>& data, char& remove, char& change) {
	for(int row = 0; row < data.size(); row++) {
		for(int col = 0; col < data[row].size(); col++) {
			if(data[row][col] == remove) {
				data[row][col] = change;
			}
		}
	}	
}

// Perform the dilation operation on the data
void dilation(std::vector<std::string>& data, char& fore) {
	for(int row = 0; row < data.size(); row++) {
		for(int col = 0; col < data[row].size(); col++) {
			if(data[row][col] == fore) {             // Skip if fore char is already there
				continue;
			}
			if(!(row - 1 < 0)) {                     // Edge detection
				if(data[row-1][col] == fore) {
					data[row][col] = ' ';            // Mark the spots that need to be changed
				}
			}
			if(!(row + 1 >= data.size())) {
				if(data[row+1][col] == fore) {
					data[row][col] = ' ';
				}
			}
			if(!(col - 1 < 0)) {
				if(data[row][col-1] == fore) {
					data[row][col] = ' ';
				}
			}
			if(!(col - 1 >= data[row].size())) {
				if(data[row][col+1] == fore) {
					data[row][col] = ' ';
				}
			}
		}
	}

	// Replace the marked spots with the fore char
	for(int row = 0; row < data.size(); row++) {
		for(int col = 0; col < data[row].size(); col++) {
			if(data[row][col] == ' ') {
				data[row][col] = fore;
			}
		}
	}
}

// Perform the erosion operation on the data
void erosion(std::vector<std::string>& data, char& fore, char& back) {
	for(int row = 0; row < data.size(); row++) {
		for(int col = 0; col < data[row].size(); col++) {
			if(data[row][col] == back) {              // Skip if back char is already there
				continue;
			}
			if(!(row - 1 < 0)) {                      // Edge detection
				if(data[row-1][col] == back) {
					data[row][col] = ' ';             // Mark the spots that need to be changed
				}
			}
			if(!(row + 1 >= data.size())) {
				if(data[row+1][col] == back) {
					data[row][col] = ' ';
				}
			}
			if(!(col - 1 < 0)) {
				if(data[row][col-1] == back) {
					data[row][col] = ' ';
				}
			}
			if(!(col - 1 >= data[row].size())) {
				if(data[row][col+1] == back) {
					data[row][col] = ' ';
				}
			}
		}
	}

	// Replace the marked spots with the back char
	for(int row = 0; row < data.size(); row++) {
		for(int col = 0; col < data[row].size(); col++) {
			if(data[row][col] == ' ') {
				data[row][col] = back;
			}
		}
	}
}

// Perform the floodfill operation on the data
void floodfill(std::vector<std::string>& data, int& frow, int& fcol, char& change) {
	char orig = data[frow][fcol];                                // determine original char
	data[frow][fcol] = ' ';                                      // mark initial spot

	bool repeat = true;                                          // boolean to determine if loop must be repeated
	while(repeat == true) {
		int count = 0;                                           // count of how many spots have been marked in this iteration 
		for(int row = 0; row < data.size(); row++) {                
			for(int col = 0; col < data[row].size(); col++) {
				if(data[row][col] == orig) {                     // if spot has the original and has an adjacent marked spot, mark it 
					if(data[row-1][col] == ' ') {
						data[row][col] = ' ';
						count++;
					}
					if(data[row+1][col] == ' ') {
						data[row][col] = ' ';
						count++;
					}
					if(data[row][col-1] == ' ') {
						data[row][col] = ' ';
						count++;
					}
					if(data[row][col+1] == ' ') {
						data[row][col] = ' ';
						count++;
					}												
				}
			}
		}
		if(count == 0) {                                         // if no spots have been marked this iteration, end loop
			repeat = false;
		}
	}
		
	// Replace the marked spots and the original spot with the change char
	for(int row = 0; row < data.size(); row++) {
		for(int col = 0; col < data[row].size(); col++) {
			if(data[row][col] == ' ') {
				data[row][col] = change;
			}
		}
	}	
	data[frow][fcol] = change;
}

int main(int argc, char* argv[]) {
	// Check if correct number of arguments
	if(argc < 5 or argc > 7) {
		std::cerr << "Incorrect number of arguments";
		return 1;
	}

	// Check if files are successfullcol opened
	std::ifstream input(argv[1]);
	std::ofstream output(argv[2]);
	if(!input.good()) {
		std::cerr << "Cannot open file " << argv[1] << "\n";
		return 1;
	}
	if(!output.good()) {
		std::cerr << "Cannot open file" << argv[2] << "\n";
		return 1;
	}

	// Read info from input file, put into a vector of strings
	std::vector<std::string> data;
	while(!input.eof()) {
		std::string input_line;
		input >> input_line;
		data.push_back(input_line);
	}

	// Read info from command line, call replace function 
	if(strcmp(argv[3], "replace") == 0) {
		char remove = argv[4][0];
		char change = argv[5][0];
		replace(data,remove,change);
	}

	// Read info from command line, call dilation function
	else if(strcmp(argv[3], "dilation") == 0) {
		char fore = argv[4][0];
		dilation(data,fore);
	}
	
	// Read info from command line, call erosion function 
	else if(strcmp(argv[3], "erosion") == 0) {
		char fore = argv[4][0];
		char back = argv[5][0];
		erosion(data,fore,back);
	}

	// Read info from command line, call floodfill function 
	else if(strcmp(argv[3], "floodfill") == 0) {
		int frow = atoi(argv[4]);
		int fcol = atoi(argv[5]);
		char change = argv[6][0];
		floodfill(data,frow,fcol,change);
	}

	// Write data into output file
	output << data[0];
	for (int row = 1; row < data.size(); row++) {
		output << "\n" << data[row];
	}

	return 0;
}



