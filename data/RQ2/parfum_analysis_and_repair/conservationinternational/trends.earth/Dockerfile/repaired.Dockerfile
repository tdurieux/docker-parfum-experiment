FROM qgis/qgis:latest

RUN apt-get install --no-install-recommends unzip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir numba
RUN pip3 install --no-cache-dir invoke
RUN pip3 install --no-cache-dir boto3
RUN ln -s /usr/bin/pip3 /usr/bin/pip
