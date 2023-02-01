FROM gitpod/workspace-full

USER gitpod

RUN pip3 install --no-cache-dir -U platformio && npm install html-minifier-terser -g && npm cache clean --force;