ARG TAG=latest
FROM harmonyservices/netcdf-to-zarr:$TAG

COPY requirements/core.txt requirements/core.txt

RUN pip3 install --no-cache-dir -r requirements/core.txt -r

ENTRYPOINT ["bash", "bin/test"]
