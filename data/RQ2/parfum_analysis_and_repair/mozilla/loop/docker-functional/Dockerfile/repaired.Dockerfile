# This definition can be found in
# https://dxr.mozilla.org/mozilla-central/source/testing/docker/desktop-test
FROM          taskcluster/desktop-test:0.1.8.20160218152601

# This makes pyperclip happy.
RUN apt-get update && apt-get install --no-install-recommends -y --force-yes xclip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir virtualenv virtualenvwrapper mozdownload

COPY          setup.sh /home/worker/bin/
RUN           chmod 755 /home/worker/bin/*

# Set up VNC
RUN           mkdir /home/worker/.vnc
RUN           x11vnc -storepasswd 1234 /home/worker/.vnc/passwd

RUN           mkdir -p artifacts/public

ENV           ARTIFACT_UPLOAD_PATH    /home/worker/artifacts/public
ENV           NEED_WINDOW_MANAGER     true
