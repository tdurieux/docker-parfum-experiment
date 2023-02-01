FROM python:3.6

#  Set the working directory
WORKDIR /app

#  Copy package requirements
COPY requirements.txt /app

RUN apt-get update
RUN apt-get install --no-install-recommends dialog apt-utils -y && rm -rf /var/lib/apt/lists/*;

#  Install tzdata and set timezone
RUN apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;
ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#  Install cifs-utils to mount Windows network share
RUN apt-get install --no-install-recommends -y cifs-utils && rm -rf /var/lib/apt/lists/*;

RUN apt-get update --fix-missing
RUN apt-get install --no-install-recommends -y iputils-ping && rm -rf /var/lib/apt/lists/*;

#  Required for pymssql
RUN apt-get update && apt-get install --no-install-recommends -y \
    freetds-bin \
    freetds-common \
    freetds-dev && rm -rf /var/lib/apt/lists/*;

#  Update python3-pip
RUN python -m pip install pip --upgrade
RUN python -m pip install wheel

#  Install python packages specified in requirements.txt
RUN pip install --no-cache-dir --trusted-host pypi.python.org -r requirements.txt