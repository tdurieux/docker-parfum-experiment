# Dockerfile
FROM ubuntu:trusty

RUN apt-get update && apt-get install --no-install-recommends -y \
	python-stdeb \
	fakeroot \
	python-all \
    python-pip && rm -rf /var/lib/apt/lists/*;

COPY ./build-debs.py /build-debs.py
RUN chmod 777 /build-debs.py
RUN ls /build-debs.py
# we want to use python to run the python script...
ENTRYPOINT ["python", "/build-debs.py"]
CMD ["/var/wdir"]
