FROM tcloud.hub/base/python:3.8
RUN apt-get update && apt-get install --no-install-recommends vim -y && apt-get install -y --no-install-recommends sshpass && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /home/py_xops && mkdir -p ~/.pip/
COPY ./.pip/pip.conf ~/.pip/
WORKDIR /home/py_xops
COPY . /home/py_xops
RUN pip install --no-cache-dir -r /home/py_xops/requirements.txt
EXPOSE 8000
CMD ["python", "/home/py_xops/main.py", "-c", "/home/py_xops/api.cfg"]
