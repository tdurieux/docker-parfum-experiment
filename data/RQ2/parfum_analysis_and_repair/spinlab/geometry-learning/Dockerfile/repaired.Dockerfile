FROM geodata/gdal:2.1.3

RUN apt-get update && apt-get install --no-install-recommends -y curl unzip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir shapely numpy
WORKDIR /data/prep