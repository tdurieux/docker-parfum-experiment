FROM _DOCKER_BASE_

COPY src/agent/kubernetes-agent/requirements.txt /
RUN pip install --no-cache-dir -r /requirements.txt
RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl

COPY src/agent/kubernetes-agent/src /app

WORKDIR /app

ENV KUBECONFIG /app/.kube/config
ENV PYTHONPATH /app:$PATHONPATH

CMD python main.py
