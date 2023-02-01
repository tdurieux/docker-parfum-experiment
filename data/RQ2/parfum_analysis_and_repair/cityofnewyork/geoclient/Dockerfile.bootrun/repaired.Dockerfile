#
# 1. Before running this image create a volume with Geosupport installed:
#
#   $ docker pull mlipper/geosupport-docker
#   ...
#   $ docker run -it --rm --mount source=vol-geosupport,target=/opt/geosupport mlipper/geosupport-docker
#
# 2. Build this image
#
#   # Assuming you've successfully built this project from source
#   # (e.g., using Dockerfile.build) and the following relative file path to
#   # to the default geoclient-service build artifact is valid:
#   # ./geoclient-service/build/libs/geoclient-service-<VERSION>-boot.jar
#
#   $ docker build -t geoclient -f Dockerfile .
#
#   OR
#
#   # Specify a non-default path to the geoclient-service Spring Boot jar file
#
#   $ docker build --build-arg JARFILE=./build/libs/gc.jar -t geoclient -f Dockerfile .
#
# 3. Run this image
#
#   $ docker run -d --name gcrun -p 8080:8080 --mount source=vol-geosupport,target=/opt/geosupport geoclient
#
# 4. Default service endpoint is http://localhost:8080/geoclient/v2
#
#   $ curl -XGET 'http://localhost:8080/geoclient/v2/search.json?input=Broadway%20and%20W%2042%20st%20Manhattan'
#