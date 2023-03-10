# this base image works in both CPU and GPU enabled environments
FROM substrafoundation/substra-tools:0.7.0

# install dependencies
RUN pip3 install --no-cache-dir sklearn

# add your metrics script to docker image
ADD metrics.py .

# define how script is run
ENTRYPOINT ["python3", "metrics.py"]
