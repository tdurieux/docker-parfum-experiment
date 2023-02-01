FROM python:3.6-stretch

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y software-properties-common vim && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y build-essential python-dev python3-pip python3-venv && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y git telnet curl && rm -rf /var/lib/apt/lists/*;

# update pip
RUN python3.6 -m pip install pip --upgrade
RUN python3.6 -m pip install wheel

WORKDIR /home

COPY . .

RUN pip install --no-cache-dir -r requirements_test.txt
RUN pip install --no-cache-dir python-dotenv
