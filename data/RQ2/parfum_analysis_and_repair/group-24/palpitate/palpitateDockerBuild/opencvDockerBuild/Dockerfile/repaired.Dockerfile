from ubuntu:latest

run echo "Building Palpitate docker image"

run apt-get update
run apt-get install --no-install-recommends -y -q wget curl && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y -q build-essential && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y -q cmake && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y -q python2.7 python2.7-dev && rm -rf /var/lib/apt/lists/*;
run wget 'https://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg' && /bin/sh setuptools-0.6c11-py2.7.egg && rm -f setuptools-0.6c11-py2.7.egg

# insall pip
run apt-get install --no-install-recommends -y -q python-setuptools python-dev build-essential && rm -rf /var/lib/apt/lists/*;
run easy_install pip
run pip install --no-cache-dir --upgrade pip

# install numpy for OpenCV
run pip install --no-cache-dir numpy
run apt-get install --no-install-recommends -y -q libavformat-dev libavcodec-dev libavfilter-dev libswscale-dev && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y -q libjpeg-dev libpng-dev libtiff-dev libjasper-dev zlib1g-dev libopenexr-dev libxine-dev libeigen3-dev libtbb-dev && rm -rf /var/lib/apt/lists/*;

# install git
run apt-get install --no-install-recommends -y -q git && rm -rf /var/lib/apt/lists/*;

# run build_opencv.sh script in container
run echo "Build OpenCV"
add build_opencv.sh /build_opencv.sh
run /bin/sh /build_opencv.sh
run rm -rf /build_opencv.sh
run echo "Finished building OpenCV"

EXPOSE 5000
