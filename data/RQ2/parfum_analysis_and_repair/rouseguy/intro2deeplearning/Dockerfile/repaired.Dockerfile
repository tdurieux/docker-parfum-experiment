FROM raghothams/py2.7-dev
RUN apt-get update && apt-get install --no-install-recommends -y python2.7 python-dev build-essential curl libatlas-base-dev gfortran git python-pip pkg-config libfreetype6-dev libjpeg-dev libpng-dev libhdf5-dev && rm -rf /var/lib/apt/lists/*;
COPY ./requirements_linux.txt ~/
COPY ./check_env.py ~/
WORKDIR ~/
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements_linux.txt
CMD python check_env.py
