#ifndef __recipe_h_
#define __recipe_h_

class Recipe {

public:

	Recipe(const std::string &n);

	std::string getName() const;								// Return name

	std::list<Ingredient> getIngredients() const;				// Return list of ingredients in recipe

	void addIngredient(const std::string &n, const int &u);		// Add ingredient to recipe




private:

	std::string name;
	std::list<Ingredient> ingredients;

};

#endif
