FROM resin/rpi-raspbian:jessie

RUN apt-get update -qy && apt-get install --no-install-recommends -qy \
    python \
    python-rpi.gpio \
    python-smbus && rm -rf /var/lib/apt/lists/*;

# Cancel out any Entrypoint already set in the base image.
ENTRYPOINT []

WORKDIR /root/

COPY library	library
WORKDIR /root/library
RUN python setup.py install

WORKDIR /root/
COPY examples	examples
WORKDIR /root/examples/

CMD ["python", "demo.py"]
