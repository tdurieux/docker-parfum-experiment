FROM ubuntu
RUN apt-get -q -y update && apt-get -q --no-install-recommends -y install python3 python3-pip sudo && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir Flask gunicorn
RUN useradd -m app
WORKDIR /home/app
CMD sudo -u app /usr/local/bin/gunicorn -b 0.0.0.0:5000 -w 4 app:app
ADD ./ /home/app/
RUN chmod -R ugo-w /home/app
