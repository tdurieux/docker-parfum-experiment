FROM cdrx/pyinstaller-windows:python3-32bit

RUN apt-get update -y
RUN pip install --no-cache-dir --upgrade PyQt5
RUN pip install --no-cache-dir --upgrade sip
RUN mkdir /app
COPY run.sh /app

WORKDIR /src
RUN chmod uga+x /app/run.sh
CMD ["/app/run.sh"]
