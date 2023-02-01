from python:2.7.18

copy locustfile.py /root/
copy requirements.txt /root/
copy start.sh /root/

run pip install --no-cache-dir -r /root/requirements.txt

workdir /root/

