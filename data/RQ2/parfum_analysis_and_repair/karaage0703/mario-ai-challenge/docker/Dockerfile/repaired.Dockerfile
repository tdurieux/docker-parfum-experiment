FROM pytorch/pytorch:1.10.0-cuda11.3-cudnn8-runtime

RUN apt-get -q update && \
	apt-get install -y --no-install-recommends gcc libc-dev curl && \
	curl -f -o /usr/local/bin/su-exec.c https://raw.githubusercontent.com/ncopa/su-exec/master/su-exec.c && \
	gcc -Wall /usr/local/bin/su-exec.c -o /usr/local/bin/su-exec && \
	chown root:root /usr/local/bin/su-exec && \
	chmod 0755 /usr/local/bin/su-exec && \
	apt-get clean -y && \
	rm -rf rm -rf /var/lib/apt/lists/*

RUN apt-get -q update && \
	apt-get install --no-install-recommends -y xvfb wget ffmpeg && \
	conda config --set channel_priority false && \
	conda update --all && \
	apt-get install --no-install-recommends -y python3-pip && \
	pip install --no-cache-dir -qq gdown && \
	pip install --no-cache-dir -qq imageio && \
	pip install --no-cache-dir -qq jupyterlab && \
	pip install --no-cache-dir -qq gym-super-mario-bros==7.3.0 && \
	pip install --no-cache-dir -qq pyvirtualdisplay && \
	pip install --no-cache-dir -qq stable-baselines3[extra]==1.3.0 && \
	apt-get clean -y && \
	rm -rf rm -rf /var/lib/apt/lists/*

COPY ./src/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["jupyter", "lab", "--no-browser", "--port=8888", "--ip=0.0.0.0", "--NotebookApp.token=''"]
