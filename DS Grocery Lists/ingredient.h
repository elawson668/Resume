#ifndef __ingredient_h_
#define __ingredient_h_

class Ingredient {

public:

	Ingredient(const std::string &n, const int &u);

	std::string getName() const;				// Return name

	int getUnits() const;						// Return units

	void addUnits(const int &u);				// Add units

	void removeUnits(const int &u);				// Remove units

	void print(std::ostream &ostr) const;		// Print ingredient info


private:

	std::string name;
	int units;

};

bool sort_name(const Ingredient& i1, const Ingredient& i2);	// Sort list of ingredients by name

bool sort_num(const Ingredient& i1, const Ingredient& i2);	// Sort list of ingredients by units

#endif