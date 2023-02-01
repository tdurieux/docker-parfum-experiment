FROM python:3.7.3

WORKDIR /pyshella-toolkit
COPY . .
RUN apt-get update && apt-get install --no-install-recommends -y supervisor && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/log/supervisor && mkdir shared
COPY toolkit.conf /etc/supervisor/conf.d/toolkit.conf
CMD ["./toolkit.sh"]
