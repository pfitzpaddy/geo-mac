#!/bin/bash
# Geo My Mac
# Prerequisits;
#   Brew
#   Python
#   NodeJS
#   Xquartz: https://xquartz.macosforge.org/landing/

# Set/get db param
DB="immap"
if [ $1 ]; then
	DB=$1
fi

echo "-------GeoMyMac-------"
echo "Installing postgres..."
brew install postgres &> /dev/null
echo "Installing postgis spatial extensions..."
brew install postgis &> /dev/null
echo "Start the server..."
pg_ctl -D /usr/local/var/postgres stop
pg_ctl -D /usr/local/var/postgres start
echo "Create database $DB"
createdb $DB
psql -d $DB -c 'CREATE EXTENSION postgis;'

# Check if server is running
export PGDATA='/usr/local/var/postgres'
pg_ctl status
echo "Init db cluster..."
initdb /usr/local/var/postgres &> /dev/null
echo "Install GDAL with postgresql..."
brew install gdal --with-postgresql &> /dev/null
echo "Install TopoJSON..."
sudo npm install -g topojson &> /dev/null

# Install QGIS
# here's the big trick to success:
# set up python with dependencies for QGIS
# and export its path before the QGIS build so it can find it
echo "Configure QGIS 2.7 Python dependencies..."
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH
pip install numpy scipy matplotlib processing psycopg2 &> /dev/null

echo "Install QGIS, this will take time..."
echo "   /   /    "
echo "   \   \    "
echo "   /   /    "
echo " |--------------|——|"
echo " |              |  |"
echo " |  TEA TIME    |  |"
echo " |              |——|"
echo " \-------------/"
echo "-----------------"
brew tap osgeo/osgeo4mac
brew install qgis &> /dev/null

echo "Link QGIS to Applications..."
echo ""
brew linkapps qgis &> /dev/null
echo "GeoMyMac setup is complete, enjoy!"
