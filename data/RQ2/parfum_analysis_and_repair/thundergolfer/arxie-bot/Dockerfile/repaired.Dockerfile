FROM python:2.7-slim
ADD . /src
WORKDIR /src
RUN apt-get -qq update
RUN apt-get install --no-install-recommends -y gcc build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python-numpy && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r requirements.txt
CMD python -m bot.app
