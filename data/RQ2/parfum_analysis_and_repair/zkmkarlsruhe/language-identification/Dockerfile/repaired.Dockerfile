FROM tensorflow/tensorflow:latest-devel-gpu

### ==== update ====
RUN apt-get install -y --fix-missing
RUN apt-get update
#RUN apt-get upgrade -y

### ==== lid specific installs ====
RUN apt-get install --no-install-recommends -y \
    ffmpeg sox libasound-dev python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install --upgrade pip

### ==== Pip ====
COPY requirements.txt /requirements.txt
# enum34 did not let us install latest kapre
RUN pip uninstall -y enum34
RUN pip install --no-cache-dir -r requirements.txt

### ==== cleanup ====
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ENV PYTHONPATH="${PYTHONPATH}:/work/src"

WORKDIR /work/src

