FROM node:14-alpine

# This image is only used for CI, to enable builds without needing to extract
# maps each time.

COPY ./containerfs/tc-wd/dbc /containerfs/tc-wd/dbc
COPY ./containerfs/tc-wd/maps /containerfs/tc-wd/maps
COPY ./containerfs/tc-wd/mmaps /containerfs/tc-wd/mmaps
COPY ./containerfs/tc-wd/vmaps /containerfs/tc-wd/vmaps