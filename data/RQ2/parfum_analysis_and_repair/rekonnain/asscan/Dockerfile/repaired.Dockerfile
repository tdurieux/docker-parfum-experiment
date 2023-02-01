FROM kalilinux/kali-rolling
RUN apt-get update ; apt-get -y --no-install-recommends install metasploit-framework; rm -rf /var/lib/apt/lists/*; apt-get -y --no-install-recommends install enum4linux
RUN apt-get -y --no-install-recommends install golang; rm -rf /var/lib/apt/lists/*; go get github.com/ffuf/ffuf; cp /root/go/bin/ffuf /usr/local/bin
RUN apt-get -y --no-install-recommends install python3-pip xvfb xdotool bc imagemagick python3-tornado masscan expect rdesktop && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir vncdotool; pip3 install --no-cache-dir webscreenshot
RUN mkdir ass
COPY install-phantomjs.sh ass/
RUN cd ass; bash install-phantomjs.sh
RUN apt-get -y --no-install-recommends install npm && rm -rf /var/lib/apt/lists/*;
RUN npm -g config set user root
RUN npm install -g npm && npm cache clean --force;
RUN npm i --unsafe-perm -g wappalyzer && npm cache clean --force;
# wappalyzer depends on something, not sure what, it's a browser so let's solve it by brute force
RUN apt-get -y --no-install-recommends install $(apt-cache depends chromium | grep Depends | sed "s/.*ends:\ //" | tr '\n' ' ') && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install freerdp2-x11 smbmap && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-venv; rm -rf /var/lib/apt/lists/*; python3 -m pip install pipx
RUN pipx ensurepath
RUN pipx install crackmapexec
RUN mkdir resources
ADD common.py notes.py results.py scheduler.py server.py log.py reporting.py scanners.py scrapers.py autosslrdp.exp helpers.py ass/
ADD RDP-screenshotter.sh ass/
ADD resources/quickhits.txt ass/resources/
ADD ui /ass/ui
ADD scanners /ass/scanners
RUN mkdir -p /ass/results
RUN chmod +x ./ass/server.py
CMD [ "sh", "-c",  "cd ass;./server.py 8888 0.0.0.0" ]
