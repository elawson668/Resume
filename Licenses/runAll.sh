# Eric Lawson, 2018-08-14
#!/bin/bash 

# Create reports directories
if [ ! -d Reports ]; then
	mkdir Reports
	mkdir Reports/Image
	mkdir Reports/Image/Licenses
	mkdir Reports/Image/HTML
	mkdir Reports/Java
	mkdir Reports/Java/Licenses
	mkdir Reports/Java/HTML
fi

cp index.html Reports

# Run programs
cd Image
./run.sh
cd ../Java
./run.sh
cd ..

