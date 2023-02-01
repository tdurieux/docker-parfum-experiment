FROM lambci/lambda:build-python3.8

ENV AWS_DEFAULT_REGION us-west-2
RUN yum install -y rsync && rm -rf /var/cache/yum
RUN mkdir /asset-input
WORKDIR /asset-input
ADD . .

#RUN pip3 install -r requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt -t /asset-output
RUN rsync -r . /asset-output
WORKDIR /asset-output
RUN zip -9yr lambda.zip .