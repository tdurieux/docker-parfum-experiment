FROM python:3.8-slim-buster
LABEL maintainer="Breadlysm" \
    description="Original by Aiden Gilmartin. Maintained by Breadlysm"

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update
RUN apt-get -q -y install --no-install-recommends apt-utils gnupg1 apt-transport-https dirmngr curl && rm -rf /var/lib/apt/lists/*;

# Install Speedtest
RUN curl -f -s https://install.speedtest.net/app/cli/install.deb.sh --output /opt/install.deb.sh
RUN bash /opt/install.deb.sh
RUN apt-get update && apt-get -q --no-install-recommends -y install speedtest && rm -rf /var/lib/apt/lists/*;
RUN rm /opt/install.deb.sh

# Clean up
RUN apt-get -q -y autoremove && apt-get -q -y clean
RUN rm -rf /var/lib/apt/lists/*

# Copy and final setup
ADD . /app
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

# Excetution
CMD ["python", "main.py"]
