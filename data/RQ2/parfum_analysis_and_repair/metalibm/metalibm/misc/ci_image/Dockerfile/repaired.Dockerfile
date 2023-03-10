FROM ubuntu:18.04 AS ml_ci_base_deps

RUN apt-get update

RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 python3-setuptools libpython3-dev python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libmpfr-dev libmpfi-dev libfplll-dev libxml2-dev wget && rm -rf /var/lib/apt/lists/*;

FROM ml_ci_base_deps AS ml_ci_base

RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
# install sollya's dependency

# install sollya
WORKDIR  /home/


# RUN apt install -y libsollya-dev sollya
# sollya weekly release (which implement sollya_lib_obj_is_external_data
# contrary to sollya 7.0 release)
RUN wget https://gforge.inria.fr/frs/download.php/file/37749/sollya-7.0.tar.gz && tar -xzf sollya-7.0*
WORKDIR /home/sollya-7.0/
RUN mkdir -p /app/local/python3/ && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j8 && make install

RUN pip3 install --no-cache-dir git+https://gitlab.com/metalibm-dev/pythonsollya

# checking pythonsolya install
RUN pip3 install --no-cache-dir bigfloat
RUN apt-get install -y --no-install-recommends python3-six && rm -rf /var/lib/apt/lists/*;
RUN LD_LIBRARY_PATH="/usr/local/lib/" python3 -c "import sollya"

# installing gappa
WORKDIR /home/
RUN apt-get install --no-install-recommends -y libboost-dev && rm -rf /var/lib/apt/lists/*;
RUN wget https://gforge.inria.fr/frs/download.php/file/37624/gappa-1.3.3.tar.gz
RUN tar -xzf gappa-1.3.3.tar.gz && rm gappa-1.3.3.tar.gz
WORKDIR /home/gappa-1.3.3/
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN ./remake
RUN ./remake install


#
WORKDIR /home/
#RUN wget https://github.com/ghdl/ghdl/releases/download/v0.37/ghdl-0.37-ubuntu16-mcode.tgz
#RUN tar -xzf ghdl-0.37-ubuntu16-mcode.tgz

RUN apt install -y --no-install-recommends libgnat-8 && rm -rf /var/lib/apt/lists/*;
# debian packages does not come with ieee libraries (not GPL ?)
# RUN wget http://ftp.fr.debian.org/debian/pool/main/g/ghdl/ghdl_0.35+git20181129+dfsg-3_amd64.deb
# RUN wget http://ftp.fr.debian.org/debian/pool/main/g/ghdl/ghdl-mcode_0.35+git20181129+dfsg-3_amd64.deb
# RUN dpkg -i ghdl_0.35+git20181129+dfsg-3_amd64.deb ghdl-mcode_0.35+git20181129+dfsg-3_amd64.deb

WORKDIR /home/ghdl/
RUN wget https://github.com/ghdl/ghdl/releases/download/v0.37/ghdl-0.37-buster-mcode-synth.tgz
RUN tar -xzf ghdl-0.37-buster-mcode-synth.tgz && rm ghdl-0.37-buster-mcode-synth.tgz
# testing ghdl
RUN PATH=/home/ghdl/bin/:$PATH ghdl --version

# installing papi (required for performance counter access)
RUN apt install --no-install-recommends -y libpapi-dev && rm -rf /var/lib/apt/lists/*;

FROM ml_ci_base AS ml_ci_test


# installing ASMDE (metalibm dependency) directly
RUN pip3 install --no-cache-dir git+https://github.com/nibrunie/asmde

WORKDIR /home/
RUN git clone https://github.com/kalray/metalibm.git -b rtl_dequantizer
WORKDIR /home/metalibm/
ENV LD_LIBRARY_PATH=/usr/local/lib/:/home/ghdl/lib/
ENV PATH=/home/ghdl/bin/:$PATH
ENV ML_SRC_DIR=/home/metalibm/
ENV PYTHONPATH=/home/metalibm/

RUN python3 ./valid/hw_non_regression.py
RUN python3 ./valid/soft_unit_test.py
RUN python3 ./valid/rtl_unit_test.py


