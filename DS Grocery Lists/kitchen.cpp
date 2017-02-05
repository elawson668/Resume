#include <iostream>
#include <list>
#include <string>

#include "kitchen.h"
#include "ingredient.h"

std::list<Ingredient> Kitchen::getIngredients() { return ingredients; }

void Kitchen::addIngredient(const std::string &name, const int &units) {
	std::list<Ingredient>::iterator itr = ingredients.begin();
    while(itr != ingredients.end()) {
    	if(itr->getName() == name) { 
    		itr->addUnits(units);
    		return;
    	}
    	itr++;
    }
    ingredients.push_back(Ingredient(name,units));
}

void Kitchen::removeIngredient(const std::string &name, const int &units) {
	std::list<Ingredient>::iterator itr = ingredients.begin();
	while(itr != ingredients.end()) {
		bool skip = false;
		if(itr->getName() == name) {
			itr->removeUnits(units);
			if(itr->getUnits() == 0) {
				itr = ingredients.erase(itr);
				skip = true;
			}
		}
		if(skip == false) {
			itr++;
		}
	}
}

void Kitchen::printIngredients(std::ostream &ostr) {
	ostr << "In the kitchen:" << std::endl;
	ingredients.sort(sort_num);
	std::list<Ingredient>::const_iterator itr = ingredients.begin();
	while(itr != ingredients.end()) {
		if(itr->getUnits() > 1) {
			ostr << "  " << itr->getUnits() << " units of " << itr->getName() << std::endl;
		}
		else {
			ostr << "  " << itr->getUnits() << " unit of " << itr->getName() << std::endl;
		}
		itr++;
	}
}
