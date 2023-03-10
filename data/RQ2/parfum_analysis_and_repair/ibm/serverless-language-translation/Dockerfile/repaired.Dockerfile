FROM ubuntu:16.04
RUN apt-get update -y && \
    apt-get install --no-install-recommends git curl -y && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://clis.ng.bluemix.net/install/linux | sh
COPY . /root/
RUN . /root/cfcreds.env && \
    bx login -u ${CF_USERNAME} -p ${CF_PASSWORD} -a https://api.ng.bluemix.net && \
    bx plugin install cloud-functions -f
RUN /root/setup.sh
