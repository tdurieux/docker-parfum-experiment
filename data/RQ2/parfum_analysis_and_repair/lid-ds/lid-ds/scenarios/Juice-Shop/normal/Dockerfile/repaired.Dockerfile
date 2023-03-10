FROM debian:10

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget python3 python3-pip wget unzip xvfb udev && rm -rf /var/lib/apt/lists/*;

# chrome in debian
RUN echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list
RUN wget https://dl-ssl.google.com/linux/linux_signing_key.pub
RUN apt-key add linux_signing_key.pub

# install chrome
RUN apt-get update && apt-get install --no-install-recommends -y google-chrome-stable git && rm -rf /var/lib/apt/lists/*;

# python related
RUN pip3 install --no-cache-dir --upgrade pip setuptools
RUN pip3 install --no-cache-dir selenium
RUN pip3 install --no-cache-dir 'urllib3==1.23' --force-reinstall
RUN pip3 install --no-cache-dir pyvirtualdisplay
RUN pip3 install --no-cache-dir requests
RUN pip3 install --no-cache-dir numpy

RUN wget https://chromedriver.storage.googleapis.com/2.42/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip -d /usr/bin
RUN chmod +x /usr/bin/chromedriver

ADD userAction.py /home/userAction.py
ADD files /home/files/
WORKDIR /home/

ENTRYPOINT ["python3", "-u", "userAction.py"]
CMD []
