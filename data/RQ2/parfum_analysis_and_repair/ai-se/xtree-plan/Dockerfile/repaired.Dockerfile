FROM ubuntu:latest
RUN export DEBIAN_FRONTEND=noninteractive
# Update APT
RUN apt-get update
# We need timezone for tk, so do that here
RUN apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;
# Set the timezone
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN apt-get install --no-install-recommends -y \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-tk && rm -rf /var/lib/apt/lists/*;
COPY . /
RUN pip3 install --no-cache-dir -r requirements.txt
CMD ["python3", "xtree_plan.py"]
