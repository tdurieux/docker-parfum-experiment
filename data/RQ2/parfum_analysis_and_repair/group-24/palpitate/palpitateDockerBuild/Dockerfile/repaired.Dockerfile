from palpitate/ffmpeg-image

run echo "Building Palpitate docker image"

# install flask for server
run pip install --no-cache-dir flask

run apt-get install --no-install-recommends -y -q libhdf5-serial-dev && rm -rf /var/lib/apt/lists/*;

run pip install --no-cache-dir openpyxl
run pip install --no-cache-dir xlrd
run pip install --no-cache-dir h5py

# Install Keras
run apt-get install --no-install-recommends -y -q python-numpy python-scipy && rm -rf /var/lib/apt/lists/*;
run apt-get install -y --no-install-recommends --upgrade python-scipy && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y -q libhdf5-serial-dev && rm -rf /var/lib/apt/lists/*;
add build_keras.sh /build_keras.sh
run /bin/sh /build_keras.sh
run rm -rf /build_keras.sh

run apt-get install --no-install-recommends -y -q libblas-dev liblapack-dev libatlas-base-dev gfortran && rm -rf /var/lib/apt/lists/*;
run /usr/bin/yes | pip install --no-cache-dir --upgrade scipy

run pip install --no-cache-dir tables
run pip install --no-cache-dir sklearn
run pip install --no-cache-dir pyzmq

WORKDIR /home

EXPOSE 5000
