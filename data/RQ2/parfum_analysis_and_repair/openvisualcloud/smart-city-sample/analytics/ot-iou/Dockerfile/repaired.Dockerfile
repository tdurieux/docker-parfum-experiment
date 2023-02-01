FROM smtc_common
RUN pip3 install --no-cache-dir paho-mqtt==1.3.0
COPY *.py /home/
CMD  ["/home/ot.py"]

####
ARG  UID
USER ${UID}
####
