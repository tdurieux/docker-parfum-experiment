FROM daqf/aardvark:latest

RUN $AG update && $AG install python python-setuptools python-pip netcat

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir scapy

COPY subset/ipaddr/dhcp_tests.py .
COPY subset/ipaddr/test_dhcp .

CMD ["./test_dhcp"]
