FROM mrupgrade/deadsnakes:2.6
RUN apt update && apt install --no-install-recommends -y -y build-essential python2.6-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir numpy==1.11.3
RUN pip install --no-cache-dir argparse certifi jplephem mock pytz sgp4 unittest2
RUN pip install --no-cache-dir https://github.com/brandon-rhodes/assay/archive/master.zip
RUN echo 'PYTHONPATH=.. assay --batch skyfield.tests' > /root/.bash_history
CMD cd skyfield/ci && /bin/bash
