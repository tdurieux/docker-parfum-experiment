FROM joyzoursky/python-chromedriver:3.9-selenium
# chrome debug port https://developers.google.com/web/updates/2017/04/headless-chrome#frontend
EXPOSE 9222/tcp
ARG  pypi="https://pypi.org/simple"
ENV  pypi=$pypi
WORKDIR /root
COPY ./packages /var/packages
RUN pip install --no-cache-dir --upgrade pip -q
RUN pip install --no-cache-dir $(find /var/packages -type f -name "*.whl") -i $pypi --extra-index-url https://pypi.org/simple --progress-bar off --pre omegaml && \
     pip install --no-cache-dir behave splinter ipdb

