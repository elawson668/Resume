#include <iostream>
#include <string>

#include "ingredient.h"

Ingredient::Ingredient(const std::string &n, const int &u) {
	name = n;
	units = u;
}

std::string Ingredient::getName() const { return name; }

int Ingredient::getUnits() const { return units; }

void Ingredient::addUnits(const int &u) { units += u; }

void Ingredient::removeUnits(const int &u) { units -= u; }

void Ingredient::print(std::ostream &ostr) const {
	if(units > 1) {
		ostr << units << " units of " << name << std::endl;
	}
	else {
		ostr << units << " unit of " << name << std::endl;
	}
}

bool sort_name(const Ingredient& i1, const Ingredient& i2) {
	return i1.getName() < i2.getName();
}

bool sort_num(const Ingredient& i1, const Ingredient& i2) {
	if(i1.getUnits() == i2.getUnits()) {
		return sort_name(i1,i2);
	}
	return i1.getUnits() < i2.getUnits();
}
