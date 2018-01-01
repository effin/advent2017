#include "stdafx.h"
#include <iostream>
#include <string>
#include <fstream>
#include <sstream>
#include <vector>
#include <algorithm>

using namespace std;

string tohex(vector<int> slice);
vector<int> rev(vector<int> slice, int start, int end);
string knothash(string inputstring);
int adv14_1(string input);
int adv14_2(string input);
int numberOfSetBits(int i);
vector<string> group(vector<string> grid, int i, int j, int g);

int main() {
	cout << adv14_1("hwlqcszp");
	cout << "\n" << adv14_2("hwlqcszp");
    return 0;
}

int adv14_1(string input) {
	int sum = 0;
	for (int i = 0; i < 128; i++) {
		string s = input + "-" + to_string(i);
		string hash = knothash(s);
		for (int j = 0; j < hash.length(); j = j + 1) {
			int val;
			stringstream ss;
			ss << hash[j];
			ss >> std::hex >> val;
			sum += numberOfSetBits(val);
		}
	}
	return sum;
}

int adv14_2(string input) {
	string hex = ".......#..#...##.#...#.#.##..####...#..##.#.#.####..##.####.#####";
	vector<string> grid;
	int sum = 0;
	for (int i = 0; i < 128; i = i + 1) {
		string s = input + "-" + to_string(i);
		string hash = knothash(s);
		string r = "";
		for (int j = 0; j < hash.length(); j = j + 1) {
			int val;
			stringstream ss;
			ss << hash[j];
			ss >> std::hex >> val;
			r += hex.substr(val * 4, 4);
		}
		grid.push_back(r);
	}
	int g = 0;
	for (int i = 0; i < 128; i = i + 1) {
		for (int j = 0; j < grid[i].length(); j = j + 1) {
			if (grid[i][j] == '#') {
				grid = group(grid, i, j, ++g);
			}
		}
	}
	return g;
}

vector<string> group(vector<string> grid, int i, int j, int g) {
	if (i >= 0 && j >= 0
		&& i < grid.size() && j < grid[i].length()
		&& grid[i][j] == '#') {
		grid[i].replace(j, 1, "-");
		grid = group(grid, i - 1, j, g);
		grid = group(grid, i, j - 1, g);
		grid = group(grid, i + 1, j, g);
		grid = group(grid, i, j + 1, g);
	}
	return grid;
}

int numberOfSetBits(int i) {
	i = i - ((i >> 1) & 0x55555555);
	i = (i & 0x33333333) + ((i >> 2) & 0x33333333);
	return (((i + (i >> 4)) & 0x0F0F0F0F) * 0x01010101) >> 24;
}

string tohex(vector<int> slice) {
	stringstream sstream;
	for (int i = 0; i < (slice.size()/16); i = i + 1) {
		int x = slice[16 * i];
		for (int j = 1; j < 16; j = j + 1) {
			x ^= slice[16 * i + j];
		}
		if (x < 16) {
			sstream << "0";
		}
		sstream << std::hex << x;
	}
	return sstream.str();
}

vector<int> rev(vector<int> slice, int start, int end) {
	int i = 0;
	int total = 1 + slice.size() - start + end;
	while (i < total / 2) {
		int i1 = start + i;
		int i2 = end - i;
		if (i1 >= slice.size()) {
			i1 = i1 % slice.size();
		}
		if (i2 < 0) {
			i2 = slice.size() + i2;
		}
		iter_swap(slice.begin() + i1, slice.begin() + i2);
		i += 1;
	}
	return slice;
}

string knothash(string inputstring) {
	vector<int> input;
	for (int i = 0; i < inputstring.length(); i = i + 1) {
		input.push_back(inputstring[i]);
	}
	input.push_back(17);
	input.push_back(31);
	input.push_back(73);
	input.push_back(47);
	input.push_back(23);
	vector<int> v;
	for (int i = 0; i < 256; i = i + 1) {
			v.push_back(i);
	}
	int pos = 0;
	int skip = 0;
	for (int r = 0; r < 64; r = r + 1) {
		for (int i = 0; i < input.size(); i = i + 1) {
			int n = input[i];
			int end = pos + n;
			if (end <= v.size()) {
				reverse(v.begin() + pos, v.begin() + end);
			}
			else {
				v = rev(v, pos, (end - 1) % v.size());
			}
			pos += n + skip;
			pos = pos % 256;
			skip += 1;
		}
	}
	return tohex(v);
}