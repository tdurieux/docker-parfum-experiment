FROM public.ecr.aws/panorama/panorama-application
COPY src /panorama
RUN pip3 install --no-cache-dir opencv-python boto3
