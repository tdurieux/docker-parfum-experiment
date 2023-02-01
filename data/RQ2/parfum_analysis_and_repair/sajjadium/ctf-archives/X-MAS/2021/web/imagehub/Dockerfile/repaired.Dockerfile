FROM debian:stable-slim
RUN apt-get update
RUN apt-get install --no-install-recommends nano apt-utils -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y
RUN apt-get install --no-install-recommends curl python3 python3-pip gunicorn3 nginx xvfb -y && rm -rf /var/lib/apt/lists/*;
COPY nginx.conf /etc/nginx/nginx.conf
RUN useradd ctf

RUN pip3 install --no-cache-dir flask requests selenium pyvirtualdisplay flask_hcaptcha

RUN apt-get install --no-install-recommends wget unzip -y && \
	wget https://chromedriver.storage.googleapis.com/95.0.4638.54/chromedriver_linux64.zip && \
	unzip chromedriver_linux64.zip && \
	mv chromedriver /usr/bin/chromedriver && rm -rf /var/lib/apt/lists/*;

RUN echo 'deb http://download.opensuse.org/repositories/home:/ungoogled_chromium/Debian_Bullseye/ /' | tee /etc/apt/sources.list.d/home-ungoogled_chromium.list > /dev/null
RUN curl -f -s 'https://download.opensuse.org/repositories/home:/ungoogled_chromium/Debian_Bullseye/Release.key' | gpg --batch --dearmor | tee /etc/apt/trusted.gpg.d/home-ungoogled_chromium.gpg > /dev/null
RUN apt update
RUN apt install --no-install-recommends -y ungoogled-chromium && rm -rf /var/lib/apt/lists/*;

COPY files/ /chall
RUN chmod -R 555 /chall
RUN chown -R root:root /chall

COPY bot/ /bot
RUN chmod -R 555 /bot
RUN chown -R ctf:ctf /bot

COPY ./start.sh /start.sh
RUN chmod 555 /start.sh
RUN chown root:root start.sh

ENTRYPOINT /start.sh
