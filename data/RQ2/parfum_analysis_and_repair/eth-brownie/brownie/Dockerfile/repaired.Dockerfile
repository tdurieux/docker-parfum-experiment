FROM python:3.7

# Set up code directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install linux dependencies
RUN apt-get update \
 && apt-get install --no-install-recommends -y libssl-dev npm && rm -rf /var/lib/apt/lists/*;

RUN npm install n -g \
 && npm install -g npm@latest && npm cache clean --force;
RUN npm install -g ganache && npm cache clean --force;

COPY requirements.txt .
COPY requirements-dev.txt .

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r requirements-dev.txt

WORKDIR /code
