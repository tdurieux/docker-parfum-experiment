FROM mesosphere/python-base:16.04
MAINTAINER Mesosphere, Inc. <support@mesosphere.io>
RUN pip install --no-cache-dir --upgrade dogapi requests mandrill prettytable
RUN apt-get update && apt-get install --no-install-recommends -y python-mysql.connector && rm -rf /var/lib/apt/lists/*;