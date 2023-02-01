from ubuntu:16.04

run apt-get update && apt-get install --no-install-recommends -y \
python3-pip \
git && rm -rf /var/lib/apt/lists/*;

run python3 --version

run pip3 install --no-cache-dir \
numpy==1.15

run pip3 install --no-cache-dir \
scipy==1.4.0

run pip3 install --no-cache-dir \
ushlex

run pip3 install --no-cache-dir \
pytest-shutil

run git clone https://github.com/FAKEBOB-adversarial-attack/FAKEBOB.git

env KALDI_ROOT="/kaldi"
run git clone https://github.com/kaldi-asr/kaldi.git $KALDI_ROOT

run cp /FAKEBOB/gmm-global-est-map.cc $KALDI_ROOT/src/gmmbin/
env makefile_path=$KALDI_ROOT"/src/gmmbin/Makefile"
run echo $makefile_path
run ls -la $makefile_path
run changed_content="$(awk '{gsub("BINFILES = ", "BINFILES = gmm-global-est-map \\\n           "); print}' $makefile_path)"; \
    echo "$changed_content" > $makefile_path; \
    echo ============; \
    cat $makefile_path



workdir $KALDI_ROOT/tools
run bash extras/install_mkl.sh
run apt-get install --no-install-recommends -y zlib1g-dev automake autoconf unzip sox gfortran libtool subversion python2.7 && rm -rf /var/lib/apt/lists/*;
run bash extras/check_dependencies.sh
#run CXX=g++-4.8 bash extras/check_dependencies.sh
env NUM_CPUS_TO_USE=24
#run make CXX=g++-4.8 -j $NUM_CPUS_TO_USE

run make -j $NUM_CPUS_TO_USE

workdir $KALDI_ROOT/src
run ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --shared
run cat $makefile_path
run make depend -j $NUM_CPUS_TO_USE
run make -j $NUM_CPUS_TO_USE

workdir /kaldi/egs/voxceleb/v1

run echo " \
export train_cmd=run.pl; \
export decode_cmd=run.pl; \
export mkgraph_cmd='run.pl'" > cmd.sh







