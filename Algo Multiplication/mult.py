import random
import sys
import timeit


def gradeschool(x,y):
	result = 0

	while(y != 0):
		if(y & 1):
			result = result + x

		x = x << 1;
		y = y >> 1;

	return result

def recur(x,y):
	if y == 0: return 0

	z = recur(x,(y >> 1))

	if(not y & 1):
		return z << 1
	else:
		return x + (z << 1)

def divcon(x,y):
	n = max(x.bit_length(),y.bit_length())

	if n == 1:
		if(x == 0 or y == 0):
			return 0
		return 1

	if(x == 0 or y == 0):
		return 0

	xl = x >> (n >> 1)
	xr = x - (xl << (n >> 1))
	yl = y >> (n >> 1) 
	yr = y - (yl << (n >> 1))

	p1 = divcon(xl,yl)
	p2 = divcon(xr,yr)
	p3 = divcon(xl+xr, yl+yr)

	return (p1 << ((n >> 1) << 1)) + ((p3 - p1 - p2) << (n >> 1)) + p2


d = int(sys.argv[1])

gstimes = [0] * 10
rtimes = [0] * 10
dctimes = [0] * 10

for r in range(10):
	start = 10 ** (d - 1)
	end = (10 ** d) - 1
	x = random.randint(start,end)
	y = random.randint(start,end)

	print "Run " + str(r + 1)
	print "x: " + str(x) + " y: " + str(y)

	start_time = timeit.default_timer()
	print "gradeschool:        " + str(gradeschool(x,y))
	gstimes[r] = timeit.default_timer() - start_time

	start_time = timeit.default_timer()
	print "recursive:          " + str(recur(x,y))
	rtimes[r] = timeit.default_timer() - start_time

	start_time = timeit.default_timer()
	print "divide and conquer: " + str(divcon(x,y))
	dctimes[r] = timeit.default_timer() - start_time

	print 

gssum = 0
rsum = 0
dcsum = 0
for r in range(10):
	gssum += gstimes[r]
	rsum += rtimes[r]
	dcsum += dctimes[r]

print "Gradeschool average:        " + str(gssum / 10)
print "Recursive average:          " + str(rsum / 10)
print "Divide and conquer average: " + str(dcsum / 10)
print







