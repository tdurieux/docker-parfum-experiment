FROM ubuntu

RUN apt update && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y qemu-kvm libvirt-daemon-system libvirt-clients virtinst cpu-checker libguestfs-tools libosinfo-bin make unzip python3-pip jq git && rm -rf /var/lib/apt/lists/*;

WORKDIR /

RUN curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install

RUN git clone --depth 1 -b maas-support https://github.com/spectrocloud/image-builder.git && cd image-builder && git checkout c9db040785766b6bc9f0cfcb16ef6a2b4075a5fc


WORKDIR /image-builder/images/capi

ENV PATH=/image-builder/images/capi/.local/bin:$PATH
ENV PATH=/root/.local/bin:$PATH

RUN make deps-qemu

COPY buildmaasimage.sh ./buildmaasimage.sh

RUN chmod a+x ./buildmaasimage.sh

