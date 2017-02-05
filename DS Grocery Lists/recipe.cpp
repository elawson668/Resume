#include <list>
#include <string>

#include "ingredient.h"
#include "recipe.h"

Recipe::Recipe(const std::string &n) { name = n; }

std::string Recipe::getName() const { return name; }

std::list<Ingredient> Recipe::getIngredients() const { return ingredients; }

void Recipe::addIngredient(const std::string &n, const int &u) {
	ingredients.push_back(Ingredient(n,u));
}