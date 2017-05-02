import sys

clock = 1

def reverseGraph(a_list):
	n = len(a_list)
	r_list = []
	for i in range(n):
		r_list.append(([]))

	for i in range(len(a_list)):
		for j in a_list[i]:
			r_list[j].append(i)

	return r_list


def dfs1(g_list,u,visited,post):
	for v in range(0,len(g_list)):
		visited.append(False)

	for v in range(1,len(g_list)):
		if visited[v] == False:
			explore1(g_list,v,visited,post)

def explore1(g_list,u,visited,post):
	visited[u] = True
	for v in g_list[u]:
		if visited[v] == False:
			explore1(g_list,v,visited,post)
	postvisit(u,post)

def postvisit(u,post):
	global clock
	post[u] = clock
	clock += 1


def explore2(g_list,u,visited):
	visited[u] = True
	for v in g_list[u]:
		if visited[v] == False:
			explore2(g_list,v,visited)


f = sys.argv[1]

edges = []
for line in open(f):
	edge = line.strip().split()
	edges.append(edge)

a_list = []
for edge in edges:
	a_list.insert(int(edge[0]),([]))

for edge in edges:
	a_list[int(edge[0])].append(int(edge[1]))

temp = a_list[len(a_list) - 1]
while(temp == ([])):
	a_list.pop(len(a_list) - 1)
	temp = a_list[len(a_list) - 1]


visited = []

r_list = reverseGraph(a_list)

post = []
for i in range(len(a_list)):
	post.append(0)

dfs1(r_list,1,visited,post)

for i in range(0,len(visited)):
	visited[i] = False

sink = post.index(max(post))

while(False in visited):
	explore2(a_list,sink,visited)
	out = ""
	for i in range(1,len(visited)):
		if visited[i] == True:
			post[i] = -1
			out += str(i) + " "
	for i in range(1,len(visited)):
		if visited[i] == True:
			visited[i] = None
	print out
	sink = post.index(max(post))


















	