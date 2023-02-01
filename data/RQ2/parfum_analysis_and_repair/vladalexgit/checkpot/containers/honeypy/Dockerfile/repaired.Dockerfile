FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y git python-dev python-pip iptables && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y


RUN git clone https://github.com/foospidy/honeypy.git

RUN pip install --no-cache-dir -r honeypy/requirements.txt

# bind ports

RUN git clone https://github.com/foospidy/ipt-kit.git

RUN python honeypy/Honey.py -ipt

RUN cp tmp/honeypy-ipt.sh /ipt-kit/

# TODO always run with --cap-add to bind remaining ports
# docker does not allow cap-add inside image files, can only be added at runtime

CMD cd ipt-kit && ./honeypy-ipt.sh && python /honeypy/Honey.py -d
#CMD (echo "start" && cat) | python honeypy/Honey.py
