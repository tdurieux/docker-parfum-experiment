FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y \
	gcc g++ git zlib1g-dev pciutils kmod \
	python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir meson pyelftools ninja
RUN mkdir -p /scratch/patches

ADD patches/* /scratch/patches/

ADD build_script.sh /scratch/build_script.sh

CMD /scratch/build_script.sh


