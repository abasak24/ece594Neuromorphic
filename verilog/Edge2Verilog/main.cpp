//
//  main.cpp
//  Edges2Verilog
//
//  Created by Tarik Tamyurek on 11/29/19.
//  Copyright © 2019 Tarik Tamyurek. All rights reserved.
//

#include <iostream>
#include <vector>
#include <fstream>
#include <sstream>

using namespace std;

// A utility function to add an edge in an
// undirected graph.
void addEdge(vector<int> adj[], int u, int v)
{
	adj[u].push_back(v);
	//adj[v].push_back(u);
}

// A utility function to print the adjacency list
// representation of graph
void printGraph(vector<int> adj[], int V)
{
	for (int v = 0; v < V; ++v)
	{
		cout << "\n Adjacency list of vertex "
			<< v << "\n head ";
		for (auto x : adj[v])
			cout << "-> " << x;
		printf("\n");
	}
}

int main(int argc, const char * argv[])
{
	if (argc < 3)
	{
		cout << "Not enough input arguments.\nFormat: start edge2verilog.exe GraphSize FileName\nExample: start edge2verilog.exe 28 edges.txt" << endl;
		getchar();
		return -1;
	}
	else if (argc > 3)
	{
		cout << "Too many input arguments.\nFormat: start edge2verilog.exe GraphSize FileName\nExample: start edge2verilog.exe 28 edges.txt" << endl;
		getchar();
		return 1;
	}
	string s = argv[1];
	int size = stoi(s);
	vector<int> *adj = new vector<int>[size];

	ifstream inputFile(argv[2]);
	cout << "Parsing Data From " << argv[2] << endl;
	string line;

	while (getline(inputFile, line))
	{
		istringstream is(line);
		string field;
		int node, adjNode;
		getline(is, field, ' ');
		node = stoi(field);
		getline(is, field, '\n');
		adjNode = stoi(field);
		addEdge(adj, node, adjNode);
	}

	ofstream outputFile;
	outputFile.open("snn_network.svh");

	outputFile << "localparam neuron_config_t CFG = '{1, 0, 0, 1, ALPHA};\n" << endl;
	outputFile << "localparam int S[T][N] = \n'{ '{";
	for (int i = 0; i < size-1; i++)
	{
		if (adj[i].size() == 0) outputFile << "1" << ", ";
		else outputFile << adj[i].size() << ", ";
	}
	int lastNeuronConnSize = adj[size - 1].size() != 0 ? adj[size - 1].size() : 1;
	outputFile << lastNeuronConnSize << "}};\n" << endl;

	for (int i = 0; i < size; i++)
	{
		outputFile << "defparam block[0].nb.neuron[" << i << "].syn.SPIKE = {";
		if (adj[i].size() == 0)
		{
			outputFile << "{" << "0" << ", " << i << "}";
		}
		for (int j = 0; j < adj[i].size(); j++)
		{
			if (j == adj[i].size() - 1) outputFile << "{" << "0" << ", " << adj[i][j] << "}";
			else outputFile << "{" << "0" << ", " << adj[i][j] << "}, ";
		}
		outputFile << "};" << endl;
	}

	outputFile.close();
	
	return 0;
}
