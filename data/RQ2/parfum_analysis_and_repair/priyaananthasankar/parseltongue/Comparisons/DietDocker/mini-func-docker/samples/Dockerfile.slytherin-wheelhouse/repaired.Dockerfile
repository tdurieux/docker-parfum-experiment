FROM prananth/experiment:dev
RUN apk add --no-cache openblas-dev
# Copy Function files
COPY . /home/site/wwwroot

RUN cd /home/site/wwwroot
RUN pip3 install --no-cache-dir numpy scipy pandas
RUN pip3 install --no-cache-dir -r requirements.txt
