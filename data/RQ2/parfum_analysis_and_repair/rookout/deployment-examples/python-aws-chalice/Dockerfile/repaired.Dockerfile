FROM lambci/lambda:build-python2.7

ADD .chalice/config.json .chalice/config.json
ADD .chalice/config-reg-test.json .chalice/config-reg-test.json
ADD app.py requirements.txt ./

# Install app dependencies
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir 'chalice == 1.7.0'

ADD runTest.sh runTest.sh