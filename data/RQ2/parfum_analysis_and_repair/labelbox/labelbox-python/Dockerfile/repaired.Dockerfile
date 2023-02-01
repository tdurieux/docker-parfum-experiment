FROM python:3.7

RUN pip install --no-cache-dir pytest pytest-cases pytest-rerunfailures
RUN apt-get -y update && apt install --no-install-recommends -y libsm6 \
                libxext6 \
                ffmpeg \
                libfontconfig1 \
                libxrender1 \
                libgl1-mesa-glx \
                libgeos-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/labelbox
COPY requirements.txt /usr/src/labelbox
RUN pip install --no-cache-dir -r requirements.txt
COPY . /usr/src/labelbox

RUN python setup.py install
