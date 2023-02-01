FROM alexellis2/python-gpio-arm:v6-dev
RUN pip2 install --no-cache-dir redis
RUN pip2 install --no-cache-dir explorerhat
RUN sudo apt-get -qy --no-install-recommends install python-smbus && rm -rf /var/lib/apt/lists/*;

ADD *.py ./

CMD ["sudo", "-E", "python2", "app.py"]
