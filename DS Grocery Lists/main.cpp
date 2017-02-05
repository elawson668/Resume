#include <cassert>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <list>
#include <string>

#include "kitchen.h"
#include "ingredient.h"
#include "recipe.h"

// Helper functions
void readRecipe(std::istream &istr, std::ostream &ostr, std::list<Recipe> &recipes);
void addIngredients(std::istream &istr, std::ostream &ostr, Kitchen &kitchen);
void printRecipe(std::istream &istr, std::ostream &ostr, const std::list<Recipe> &recipes);
void makeRecipe(std::istream &istr, std::ostream &ostr, const std::list<Recipe> &recipes, Kitchen &kitchen);
void recipeSuggestions(std::ostream &ostr, const std::list<Recipe> &recipes, Kitchen &kitchen);
bool recipeInList(const std::list<Recipe> &recipes, const std::string &name);
int ingredientInList(const std::list<Ingredient> &ingredients, const std::string &name);

// The main loop parses opens the files for I/O & parses the input
int main(int argc, char* argv[]) {

  // Check the number of arguments.
  if (argc != 3) {
    std::cerr << "Usage: " << argv[0] << " in-file out-file\n";
    return 1;
  }
  // Open and test the input file.
  std::ifstream istr(argv[1]);
  if (!istr) {
    std::cerr << "Could not open " << argv[1] << " to read\n";
    return 1;
  }
  // Open and test the output file.
  std::ofstream ostr(argv[2]);
  if (!ostr) {
    std::cerr << "Could not open " << argv[2] << " to write\n";
    return 1;
  }

  // the kitchen & recipe list
  Kitchen kitchen;
  std::list<Recipe> recipes;

  // some variables to help with parsing
  char c;
  while (istr >> c) {
    if (c == 'r') {
      // READ A NEW RECIPE
      readRecipe(istr,ostr,recipes);

    } else if (c == 'a') {
      // ADD INGREDIENTS TO THE KITCHEN
      addIngredients(istr,ostr,kitchen);
      
    } else if (c == 'p') {
      // PRINT A PARTICULAR RECIPE
      printRecipe(istr,ostr,recipes);

    } else if (c == 'm') {
      // MAKE SOME FOOD
      makeRecipe(istr,ostr,recipes,kitchen);

    } else if (c == 'k') {
      // PRINT THE CONTENTS OF THE KITCHEN
      kitchen.printIngredients(ostr);

    } else if (c == 's') {
      // SUGGEST ALL RECIPES THAT CAN BE MADE INDIVIDUALLY FROM THE
      //   CURRENT CONTENTS OF THE KITCHEN
      recipeSuggestions(ostr,recipes,kitchen);
    } else {
      std::cerr << "unknown character: " << c << std::endl;
      exit(0);
    }
  }  
}


void readRecipe(std::istream &istr, std::ostream &ostr, std::list<Recipe> &recipes) {
  int units;
  std::string name, name2;  
  istr >> name;

  // Check if recipe exists 
  if(recipeInList(recipes,name)) {
    ostr << "Recipe for " << name << " already exists" << std::endl;
    while(1) {
      istr >> units;
      if(units == 0) break;
      istr >> name2;
    }
    return;
  }

  // build the new recipe
  Recipe r(name);
  while (1) {
    istr >> units;
    if (units == 0) break;
    assert (units > 0);
    istr >> name2;
    r.addIngredient(name2,units);
  }

  // add it to the list
  recipes.push_back(r);
  ostr << "Recipe for " << name << " added" << std::endl;
}


void addIngredients(std::istream &istr, std::ostream &ostr, Kitchen &kitchen) {
  int units;
  std::string name;
  int count = 0;
  while (1) {
    istr >> units;
    if (units == 0) break;
    assert (units > 0);
    istr >> name;
    // add the ingredients to the kitchen
    kitchen.addIngredient(name,units);
    count++;
  }
  if(count > 1) {
    ostr << count << " ingredients added to kitchen" << std::endl;
  }
  else{
    ostr << count << " ingredient added to kitchen" << std::endl;
  }
}


void printRecipe(std::istream &istr, std::ostream &ostr, const std::list<Recipe> &recipes) {
  std::string name;
  istr >> name;

  // Check if recipe exists
  if(recipeInList(recipes,name)) {
    ostr << "To make " << name << ", mix together:" << std::endl;
    std::list<Recipe>::const_iterator itr = recipes.begin();
    while(itr != recipes.end()) {
      if(itr->getName() == name) {
        std::list<Ingredient> ingredients = itr->getIngredients();
        ingredients.sort(sort_name);
        std::list<Ingredient>::const_iterator itr2 = ingredients.begin();
        while(itr2 != ingredients.end()) {
          if(itr2->getUnits() > 1) {
            ostr << "  " << itr2->getUnits() << " units of " << itr2->getName() << std::endl;
          }
          else {
            ostr << "  " << itr2->getUnits() << " unit of " << itr2->getName() << std::endl;
          }
          itr2++;
        }
      }
      itr++;
    }
  }
  else {
    ostr << "No recipe for " << name << std::endl;
  }
}


void makeRecipe(std::istream &istr, std::ostream &ostr, const std::list<Recipe> &recipes, Kitchen &kitchen) {
  std::string name;
  istr >> name;

  // Check if recipe exists
  if(recipeInList(recipes,name)) {

    // Create list of required ingredients
    std::list<Recipe>::const_iterator itr = recipes.begin();
    std::list<Ingredient> required;
    while(itr != recipes.end()) {
      if(name == itr->getName()) {
        required = itr->getIngredients();
      }
      itr++;
    }

    // Create list of ingredients in kitchen and ingredients still needed
    std::list<Ingredient> have = kitchen.getIngredients();
    std::list<Ingredient> need;
    std::list<Ingredient>::iterator itr2 = required.begin();
    while(itr2 != required.end()) {
      if(!(ingredientInList(have,itr2->getName()) >= itr2->getUnits())) {
        if(ingredientInList(have,itr2->getName()) == -1) {
          need.push_back(Ingredient(itr2->getName(), itr2->getUnits()));          
        }
        else {
          need.push_back(Ingredient(itr2->getName(), itr2->getUnits() - ingredientInList(have,itr2->getName())));  
        }
      }
      itr2++;
    }
    
    // If no ingredients needed, make recipe and adjust ingredient amounts in kitchen
    if(need.empty()) {
      ostr << "Made " << name << std::endl;
      std::list<Ingredient>::iterator itr3 = required.begin();
      while(itr3 != required.end()) {
        kitchen.removeIngredient(itr3->getName(),itr3->getUnits());
        itr3++;
      }
    }

    // If ingredients are needed, print them 
    else {
      ostr << "Cannot make " << name << ", need to buy:" << std::endl;
      need.sort(sort_name);
      std::list<Ingredient>::const_iterator itr3 = need.begin();
      while(itr3 != need.end()) {
        ostr << "  ";
        itr3->print(ostr);
        itr3++;
      }
    }
  }

  else {
    ostr << "Don't know how to make " << name << std::endl;
  }
}


void recipeSuggestions(std::ostream &ostr, const std::list<Recipe> &recipes, Kitchen &kitchen) {

  // Create list of possible recipe names, place recipes that can be made iniside
  std::list<std::string> possible;
  std::list<Ingredient> available = kitchen.getIngredients();
  std::list<Recipe>::const_iterator itr = recipes.begin();
  bool x;
  while(itr != recipes.end()) {
    std::list<Ingredient> required = itr->getIngredients();
    std::list<Ingredient>::const_iterator itr2 = required.begin();
    while(itr2 != required.end()) {
      x = true;
      if(!(ingredientInList(available,itr2->getName()) >= itr2->getUnits())) {
        x = false;
        break;
      }
      itr2++;
    }
    if(x == true) {
      possible.push_back(itr->getName());
    }
    itr++;
  }

  // Print if none can be made
  if(possible.empty()) {
    ostr << "No recipes can be prepared" << std::endl;
    return;
  }

  // Print recipes 
  possible.sort();
  if(possible.size() == 1) {
    ostr << "Recipe that can be prepared:" << std::endl;
  }
  else {
    ostr << "Recipes that can be prepared:" << std::endl;
  }
  std::list<std::string>::iterator itr3 = possible.begin();
  while(itr3 != possible.end()) {
    ostr << "  " << *itr3 << std::endl;
    itr3++;
  }
}

// Check if recipe is in a list of recipes
bool recipeInList(const std::list<Recipe> &recipes, const std::string &name) {
  std::list<Recipe>::const_iterator itr = recipes.begin();
  while(itr != recipes.end()) {
    if(itr->getName() == name) { return true; }
    itr++;
  }
  return false;
}

// Check if ingredient is in a list of ingredients, return units
int ingredientInList(const std::list<Ingredient> & ingredients, const std::string & name) {
  std::list<Ingredient>::const_iterator itr = ingredients.begin();
  while(itr != ingredients.end()) {
    if(itr->getName() == name) { return itr->getUnits(); }
    itr++;
  }
  return -1;
}















