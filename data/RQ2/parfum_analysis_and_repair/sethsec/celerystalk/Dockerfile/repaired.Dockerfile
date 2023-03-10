FROM kalilinux/kali-rolling

LABEL name celerystalk
RUN apt-get update && \
    apt-get install --no-install-recommends -yqq git wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt

RUN	git clone https://github.com/sethsec/celerystalk.git && \
	cd celerystalk && \
	cd setup && \
    	./install.sh

CMD ["bash"]