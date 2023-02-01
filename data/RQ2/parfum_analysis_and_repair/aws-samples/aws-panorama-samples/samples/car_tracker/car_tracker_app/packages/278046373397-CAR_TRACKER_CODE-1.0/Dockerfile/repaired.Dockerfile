FROM public.ecr.aws/panorama/panorama-application
COPY src /panorama

ARG DEBIAN_FRONTEND=noninteractive
RUN python3 -m pip install -U scipy
RUN pip3 install --no-cache-dir opencv-python boto3