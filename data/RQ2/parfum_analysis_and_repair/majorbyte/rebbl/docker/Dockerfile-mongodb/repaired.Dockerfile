FROM mongo:latest AS defaults

FROM mongo:latest AS imports
WORKDIR /usr/src/
ADD rebbl.archive /usr/src/rebbl.archive
ADD docker/mongodb.init.sh mongobroke.init.sh

# Converts DOS line endings to Unix
RUN tr -d '\r' < mongobroke.init.sh > mongodb.init.sh

RUN chmod +x mongodb.init.sh