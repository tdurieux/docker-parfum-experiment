FROM debian:buster-slim

ADD . /app
WORKDIR /app
RUN apt-get -y update \
 && apt-get -y --no-install-recommends install python3 python3-pip \
 && python3 -m pip install -r requirements.txt \
 && mkdir /app/output && rm -rf /var/lib/apt/lists/*;
VOLUME ["/app/output"]
CMD ["python3", "portfolio_manager.py", "--save_plot", "true"]
