using System;
using System.Collections.Generic;

namespace advent12
{
    class Program
    {
        static void Main(string[] args)
        {
			string[] lines = System.IO.File.ReadAllLines(@"input12.txt");
			char[] delimiterChars = { ' ', ',' };
			var pipesMap = new Dictionary<int, List<int>>();

		    foreach (string line in lines) {
				string[] words = line.Split(delimiterChars);
				pipesMap.Add(Int32.Parse(words[0]), new List<int>());
				List<int> iList = new List<int>();
				for (int i = 2; i < words.Length; i += 2) {
					pipesMap[Int32.Parse(words[0])].Add(Int32.Parse(words[i]));
				}
			}
			HashSet<int> visited = visit(0, pipesMap, new HashSet<int>());
			Console.WriteLine("count = " + visited.Count);
			Console.WriteLine("groups = " + countGroups(pipesMap));
        }

		static HashSet<int> visit(int from, Dictionary<int, List<int>> pipesMap, HashSet<int> visited) {
			visited.Add(from);
			foreach (int connected in pipesMap[from]) {
				if (!visited.Contains(connected)) {
					visited = visit(connected, pipesMap, visited);
				}
			}
			return visited;
		}

		static int countGroups(Dictionary<int, List<int>> pipesMap) {
			HashSet<int> inAGroup = new HashSet<int>();
			int countGroups = 0;
			foreach (int k in pipesMap.Keys) {
				if (!inAGroup.Contains(k)) {
					HashSet<int> group = visit(k, pipesMap, new HashSet<int>());
					++countGroups;
					inAGroup.UnionWith(group);
				}
			}
			return countGroups;
		}
    }
}
