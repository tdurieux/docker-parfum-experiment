FROM rust:latest
RUN apt-get update
RUN apt-get install --no-install-recommends -y python3.9 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-venv && rm -rf /var/lib/apt/lists/*;
RUN cd /opt &&  git clone https://github.com/saidvandeklundert/pyo3.git
RUN cd /opt/pyo3/pyo3 && cargo update
RUN python3 -m venv /opt/venv
RUN . /opt/venv/bin/activate && pip install --no-cache-dir -r /opt/pyo3/requirements.txt


