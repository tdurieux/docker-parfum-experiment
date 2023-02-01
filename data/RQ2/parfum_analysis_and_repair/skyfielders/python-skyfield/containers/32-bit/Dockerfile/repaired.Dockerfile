FROM 32bit/ubuntu:16.04
RUN apt update
RUN apt install --no-install-recommends -y -y build-essential python3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y -y python3-numpy python3-pandas python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir argparse certifi jplephem mock pytz sgp4 unittest2
RUN pip3 install --no-cache-dir https://github.com/brandon-rhodes/assay/archive/master.zip
RUN echo 'PYTHONPATH=.. assay --batch skyfield.tests' > /root/.bash_history
CMD cd skyfield/ci && /bin/bash
