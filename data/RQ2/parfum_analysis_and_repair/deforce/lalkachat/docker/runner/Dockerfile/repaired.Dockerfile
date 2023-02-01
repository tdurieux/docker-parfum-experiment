FROM python:3.8

RUN apt-get update && apt-get install -y --no-install-recommends \
        libgtk-3-dev && rm -rf /var/lib/apt/lists/*;

COPY requires_linux.txt /root/
RUN pip install --no-cache-dir -r /root/requires_linux.txt

# Dependencies for Testing
RUN apt-get update && apt-get install -y --no-install-recommends \
        npm && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir git-lint pep8 pylint==1.9.3 junit-xml
RUN npm install -g csslint webpack webpack-merge webpack-cli && npm cache clean --force;
