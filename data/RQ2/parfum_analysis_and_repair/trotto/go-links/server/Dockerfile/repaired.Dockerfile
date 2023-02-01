FROM google/cloud-sdk:slim

RUN DEBIAN_FRONTEND=noninteractive apt-get update --fix-missing && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
        python-pip && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app
WORKDIR /app

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app
