#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <algorithm>
#include <cstring>
#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <string>
#include <vector>

using namespace std;

int main(int argc, char* argv[]) {

	if(argc != 2) {
		fprintf(stderr,"Incorrect number of arguments\n");
		return EXIT_FAILURE;
	}

	map<string,vector<string> > licenseMap;

	ifstream file(argv[1]);

	// Read info from input file, create map of license to packages
	int totalPackages = 0;
	string line;
	while(getline(file,line)) {
		string package = line.substr(0,41);
		package.erase(package.find_last_not_of(" \t\n\r\f\v") + 1);
		totalPackages++;

		string licenses = line.substr(41);
		licenses.erase(licenses.find_last_not_of(" \t\n\r\f\v") + 1);

		vector<string> tokens;
		stringstream check1(licenses);
		string intermediate;

		while(getline(check1,intermediate,':')) {
			if(intermediate.empty()) continue;
			tokens.push_back(intermediate);
		}

		for(int i = 0; i < tokens.size(); i++) {
			string token = tokens[i];
			licenseMap[token];
			licenseMap[token].push_back(package);
		}
	}

	// Generate output
	for(map<string,vector<string> >::const_iterator it = licenseMap.begin(); it != licenseMap.end(); it++) {
		string license = it->first;
		vector<string> packages = it->second;

		cout << license<< ": ";
		cout << packages.size();
		if(packages.size() == 1) cout << " package" << endl;
		else cout << " packages" <<  endl;


		for(int i = 0; i < license.size() + 11 + floor(log10(abs(packages.size()))) + 1; i++) {
			cout << "-";
		}
		cout << endl;

		for(int i = 0; i < packages.size(); i++) {
			cout << "\u2022 " << packages[i] << endl;
		}
		cout << endl;
	}

	// Create HTML files
	FILE *list;
	list = fopen("out.html","w");
	chdir("HTML");

	fprintf(list,"<html><body><h1>%d Licenses, %d Packages</h1><p><style>",licenseMap.size(),totalPackages);
	fprintf(list,"p{border-style: solid; border-wdith: 4px; border-left-width: 8px; border-right-wdith: 8px;}</style>");
	fprintf(list,"<br />");

	char cwd[1024];
	getcwd(cwd,sizeof(cwd));

	for(map<string,vector<string> >::const_iterator it = licenseMap.begin(); it != licenseMap.end(); it++) {
		string license = it->first;
		vector<string> packages = it->second;

		FILE *f;
		string name = license + ".html";
		replace(name.begin(),name.end(),' ','-');

		f = fopen(name.c_str(),"w");

		if(f == NULL) {
			fprintf(stderr,"Unable to create file %s\n", name.c_str());
			return EXIT_FAILURE;
		}

		fprintf(f,"<html><body><h1>");
		fprintf(f,license.c_str());
		fprintf(f,": %d ", packages.size());

		if(packages.size() == 1) fprintf(f,"package");
		else fprintf(f,"packages");

		fprintf(f,"</h1><style>");
		fprintf(f,"p{border-style: solid; border-width:4px; border-left-width;8px; border-right-width:8px;)");
		fprintf(f,"</style>");

		if(license != "unknown") {
			for(int i = 0; i < packages.size(); i++) {
				fprintf(f,"<a href=/Image/Licenses/");
				fprintf(f,packages[i].c_str());
				fprintf(f,"/copyrightFile.txt>");
				fprintf(f,packages[i].c_str());
				fprintf(f,"</a>");
				fprintf(f,"<br />");
			}
		}
		else {
			for(int i = 0; i < packages.size(); i++) {
				fprintf(f,packages[i].c_str());
				fprintf(f,"<br />");
			}
		}

		fprintf(f,"</p></textarea></body></html>");
		fclose(f);

		fprintf(list,"<a href=/Image/HTML/");
		//fprintf(list,cwd);
		//fprintf(list,"/");
		fprintf(list,name.c_str());
		fprintf(list,">");
		fprintf(list,license.c_str());
		fprintf(list,": %d",packages.size());

		if(packages.size() == 1) fprintf(list," package");
		else fprintf(list," packages");

		fprintf(list,"</a>");
		fprintf(list,"<br />");
	}

	fprintf(list,"</p></textarea></body></html>");
	fclose(list);

	return EXIT_SUCCESS;
}
