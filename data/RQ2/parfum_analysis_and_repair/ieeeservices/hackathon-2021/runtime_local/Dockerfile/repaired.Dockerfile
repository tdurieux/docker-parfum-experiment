FROM python:3.8-slim
RUN apt-get update && apt-get -y --no-install-recommends install --reinstall build-essential python3-dev libopenblas-dev git wget && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir qiskit matplotlib
RUN pip install --no-cache-dir $(pip freeze 2>/dev/null| grep aqua | sed -e 's/==/[torch,pyscf]==/')
RUN pip install --no-cache-dir https://github.com/rpmuller/pyquante2/archive/master.zip
RUN pip install --no-cache-dir cvxopt
RUN mkdir /runtime
WORKDIR /runtime
COPY ./program_starter.py .
COPY ./sample_program.py program.py
RUN chmod -R go+rw /runtime
RUN chmod +x program_starter.py
CMD /bin/bash
