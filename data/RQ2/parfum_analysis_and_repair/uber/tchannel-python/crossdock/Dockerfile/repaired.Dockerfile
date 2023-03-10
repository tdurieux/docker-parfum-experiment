FROM python:2.7

ENV APPDIR /usr/src/app/
RUN mkdir -p ${APPDIR}
WORKDIR ${APPDIR}

# Application installation
COPY requirements-test.txt ${APPDIR}
COPY requirements.txt ${APPDIR}

COPY setup.py ${APPDIR}
COPY setup.cfg ${APPDIR}
COPY tchannel ${APPDIR}/tchannel/

# RUN pip install -U 'pip>=7,<8'
RUN pip install --no-cache-dir -r requirements-test.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN python setup.py install

COPY crossdock ${APPDIR}/crossdock/
COPY crossdock/setup.py ${APPDIR}/setup_crossdock.py
RUN python setup_crossdock.py install

CMD ["crossdock"]
EXPOSE 8080-8082