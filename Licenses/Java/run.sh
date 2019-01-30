# Eric Lawson, 2018-08-14
#!/bin/bash
echo "Running Java licenses"

echo "Cloning Ext repository"
if [ ! -d Ext ]; then
  # clone repository with Java licenses (ommited)
else
  cd Ext
  # pull repository with Java licenses (omitted)
  #hg update tip
  cd ..
fi

echo "Compiling license.cpp"
g++ licenseJava.cpp
mkdir HTML
./dpkg-licenses > input.txt

echo "Creating HTML report"
./a.out input.txt > out.txt

echo "Moving output files"
cp -r HTML/* ../Reports/Java/HTML
cp out.txt out.html ../Reports/Java

echo "Java licenses completed"
