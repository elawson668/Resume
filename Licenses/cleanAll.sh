# Eric Lawson, 2018-08-14
#!/bin/bash
cd Image
./clean.sh
cd ../Java
./clean.sh
cd ..
echo "Cleaning Reports directory"
rm -rf Reports
