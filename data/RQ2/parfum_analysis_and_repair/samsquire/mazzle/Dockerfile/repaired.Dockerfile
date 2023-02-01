FROM ubuntu:latest
ENV HTTPS_PROXY "https://127.0.0.1:3128"
ENV https_proxy "https://127.0.0.1:3128"
ENV HTTP_PROXY "https://127.0.0.1:3128"
ENV http_proxy "https://127.0.0.1:3128"
RUN echo "Acquire::http::Proxy \"http://localhost:3128/\";" > /etc/apt/apt.conf.d/proxy.conf

RUN apt-get update
RUN apt-get install --no-install-recommends python3 python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends nodejs -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends npm -y && rm -rf /var/lib/apt/lists/*;
RUN mkdir /opt/devops-pipeline
COPY . /opt/devops-pipeline
WORKDIR /opt/devops-pipeline
RUN pip3 install --no-cache-dir -r requirements.txt
RUN cd devops_pipeline/web && npm run build

ENTRYPOINT ["python3", "/opt/devops-pipeline/devops_pipeline/devops-pipeline"]



