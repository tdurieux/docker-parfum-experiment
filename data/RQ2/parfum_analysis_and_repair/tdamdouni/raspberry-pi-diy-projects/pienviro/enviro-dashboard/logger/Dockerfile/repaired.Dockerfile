FROM alexellis2/python2-gpio-armhf:2
RUN pip2 install --no-cache-dir envirophat
RUN apt-get update -qy && apt-get install --no-install-recommends -qy python-smbus && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir influxdb
ADD ./monitor.py ./monitor.py

ENTRYPOINT []
CMD ["python2", "monitor.py"]
