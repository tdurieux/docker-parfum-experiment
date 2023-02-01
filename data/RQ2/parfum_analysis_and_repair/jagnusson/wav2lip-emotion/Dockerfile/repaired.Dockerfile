FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y sudo vim wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --allow-change-held-packages libcudnn7 libcudnn7-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libglib2.0-0 libsm6 libxrender1 libxext6 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsndfile-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y less && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip python3-dev python3-wheel && rm -rf /var/lib/apt/lists/*;
# required to fix opencv fail with skbuild (https://stackoverflow.com/questions/63448467/installing-opencv-fails-because-it-cannot-find-skbuild)
RUN pip3 install --no-cache-dir --upgrade pip setuptools

# required to make dlib work (https://stackoverflow.com/questions/48503646/where-should-i-install-cmake/51856073)
RUN apt-get install --no-install-recommends -y build-essential cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgtk-3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-all-dev && rm -rf /var/lib/apt/lists/*;

# addditonal dependencies for scripts
RUN apt-get install --no-install-recommends -y parallel && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y pv && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y imagemagick && rm -rf /var/lib/apt/lists/*;
