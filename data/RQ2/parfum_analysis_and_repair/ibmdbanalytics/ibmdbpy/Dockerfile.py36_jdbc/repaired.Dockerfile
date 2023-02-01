FROM python:3.6-stretch
RUN apt-get update && apt-get install --no-install-recommends -y \
	ksh \
	unzip \
	default-jre \
&& rm -rf /var/lib/apt/lists/*

COPY mv_to_docker/ibm_data_server_driver_package_linuxx64_v11.1.tar.gz /tmp/ibm_data_server_driver_package_linuxx64_v11.1.tar.gz
RUN tar -zxf /tmp/ibm_data_server_driver_package_linuxx64_v11.1.tar.gz -C /tmp && rm /tmp/ibm_data_server_driver_package_linuxx64_v11.1.tar.gz
ENV CLASSPATH /tmp/dsdriver/java/db2jcc.jar
RUN /bin/ksh /tmp/dsdriver/installDSDriver

COPY mv_to_docker/requirements_jdbc.txt /tmp/requirements.txt
RUN pip install --no-cache-dir pip --upgrade
RUN pip install --no-cache-dir setuptools --upgrade
RUN pip install --no-cache-dir -r /tmp/requirements.txt
COPY . /code
RUN pip install --no-cache-dir -e /code
WORKDIR /code/ibmdbpy/tests
