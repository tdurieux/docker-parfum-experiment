FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

LABEL IMAGE="dicom-init"
LABEL VERSION="0.1.3"
LABEL CI_IGNORE="False"

RUN apt-get update && apt-get install -y --no-install-recommends \
    dcmtk \
    python3 \
    python3-pip \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl --header "DEPLOY-TOKEN: EaexsV_q2BKG8BeurRT8" --output /test-dicoms.zip "https://gitlab.hzdr.de/api/v4/projects/2521/packages/generic/test-data/0.0.4/init-dicoms.zip" \
    && mkdir -p /dicom_test_data && unzip /test-dicoms.zip -d /dicom_test_data && rm -rf test-dicoms.zip

COPY files/requirements.txt /
RUN python3 -m pip install --no-cache-dir -r /requirements.txt && rm /requirements.txt 

COPY files/start.py /start.py

CMD ["python3","-u","/start.py"]