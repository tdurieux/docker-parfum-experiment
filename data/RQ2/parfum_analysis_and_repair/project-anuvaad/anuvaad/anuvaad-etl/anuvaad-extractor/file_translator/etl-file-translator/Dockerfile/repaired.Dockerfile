FROM python:3.6-slim
RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential libssl-dev libffi-dev python3-dev wget && rm -rf /var/lib/apt/lists/*;
RUN mkdir /usr/share/man/man1

#RUN apt-get install -y software-properties-common
#RUN add-apt-repository --remove ppa:libreoffice/ppa
#RUN apt update
#RUN apt-cache policy libreoffice
#RUN apt-get install -y pdftohtml
RUN apt install --no-install-recommends -y libreoffice && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y poppler-utils && rm -rf /var/lib/apt/lists/*;

COPY / /app
WORKDIR /app
RUN pip3 install --no-cache-dir -r requirements.txt
COPY start.sh /usr/bin/start.sh
RUN chmod +x /usr/bin/start.sh
CMD ["/usr/bin/start.sh"]
