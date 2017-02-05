#ifndef __kitchen_h_
#define __kitchen_h_

#include "ingredient.h"

class Kitchen {

public:

	std::list<Ingredient> getIngredients();							// Return list of ingredients

	void addIngredient(const std::string &n, const int &u);			// Add ingredient to list

	void removeIngredient(const std::string &n, const int &u);		// Remove ingredient from list

	void printIngredients(std::ostream &ostr);						// Print ingredients in kitchen

private:

	std::list<Ingredient> ingredients;

};

#endif