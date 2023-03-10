FROM public.ecr.aws/lambda/java:8

RUN yum install -y wget unzip libX11 && rm -rf /var/cache/yum

#  You could try using --skip-broken to work around the problem
#  ** Found 1 pre-existing rpmdb problem(s), 'yum check' output follows:
#  ImageMagick-6.9.10.68-3.22.amzn1.x86_64 has missing requires of libgs.so.8()(64bit)

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm && \
    yum install -y google-chrome-stable_current_x86_64.rpm && rm -rf /var/cache/yum

RUN CHROME_DRIVER_VERSION=$( curl -f -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

COPY target/dependency ${LAMBDA_TASK_ROOT}/lib/
COPY target/classes ${LAMBDA_TASK_ROOT}

CMD ["de.rieckpil.blog.InvokeWebDriver::handleRequest"]
