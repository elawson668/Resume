# Eric Lawson, 2018-08-14
#!/bin/bash
echo "Running Image licenses"

echo "Compiling license.cpp"
g++ licenseImage.cpp
mkdir HTML
./dpkg-licenses > input.txt
echo "Creating HTML report"
./a.out input.txt > out.txt

echo "Moving output files"
cp -r HTML/* ../Reports/Image/HTML
cp out.txt out.html ../Reports/Image

echo "Image licenses completed"
