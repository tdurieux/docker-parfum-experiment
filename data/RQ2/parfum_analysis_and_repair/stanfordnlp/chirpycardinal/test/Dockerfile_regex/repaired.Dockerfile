FROM python:3.7-slim-buster

RUN apt-get update -y && apt-get install --no-install-recommends -y gcc g++ curl make && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm -g config set user root
RUN npm install -g ask-cli && npm cache clean --force;
RUN pip install --no-cache-dir pip --upgrade
RUN pip install --no-cache-dir awscli

RUN mkdir -p /root/app
COPY requirements.txt /root/app/requirements.txt
RUN pip install --no-cache-dir -r /root/app/requirements.txt

COPY . /root/app
RUN mv /root/app/.aws ~/
RUN ls /root/app
RUN cd /root/app && python -m unittest discover -s chirpy -p '*.py' -v