FROM ubuntu:16.04

RUN apt-get update

RUN apt-get install --no-install-recommends -y --force-yes build-essential wget git cmake && rm -rf /var/lib/apt/lists/*;

# Gazebo simulator & Eigen & Boost
RUN apt-get install --no-install-recommends -y --force-yes libprotobuf-dev libprotoc-dev protobuf-compiler libeigen3-dev gazebo7 libgazebo7-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y --force-yes libgtest-dev && rm -rf /var/lib/apt/lists/*;
RUN cd /usr/src/gtest; cmake CMakeLists.txt; make; cp *.a /usr/lib

RUN apt-get install --no-install-recommends -y --force-yes curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install --no-install-recommends -y --force-yes nodejs && rm -rf /var/lib/apt/lists/*;

# We only get QT5 because CGAL 4.7 has a CMAKE issue (should fix itself once ubuntu updates to 4.8)
RUN apt-get install --no-install-recommends -y --force-yes libcgal-dev libcgal-qt5-dev && rm -rf /var/lib/apt/lists/*;

# Needed for building the firmware
RUN apt-get install --no-install-recommends -y python-setuptools python-dev build-essential && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python-empy && rm -rf /var/lib/apt/lists/*;
RUN easy_install pip
RUN pip install --no-cache-dir catkin_pkg
RUN apt-get install --no-install-recommends -y libopencv-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python-jinja2 && rm -rf /var/lib/apt/lists/*;
