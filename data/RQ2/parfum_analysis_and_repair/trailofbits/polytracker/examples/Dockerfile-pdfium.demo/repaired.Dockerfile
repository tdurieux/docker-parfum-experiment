FROM trailofbits/polytracker
MAINTAINER Carson Harmon <carson.harmon@trailofbits.com>

WORKDIR /polytracker/the_klondike

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y tzdata \
 && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure tzdata \
 && ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
      git \
      pkg-config \
      sudo \
      software-properties-common \
      vim && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner" \
 && DEBIAN_FRONTEND=noninteractive apt-get update

WORKDIR /

RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
ENV PATH=$PATH:/depot_tools/
WORKDIR /polytracker/the_klondike/

RUN gclient config --unmanaged https://pdfium.googlesource.com/pdfium.git
RUN gclient sync

WORKDIR pdfium

RUN git reset --hard b1c9443db058e4116703a6dc719434c0e1f38700

RUN DEBIAN_FRONTEND=noninteractive ./build/install-build-deps.sh --no-prompt
RUN gn gen out/pdfium --args='clang_base_path="/polytracker/build/bin/polytracker" use_custom_libcxx = false treat_warnings_as_errors = false is_debug = true pdf_enable_v8 = false pdf_enable_xfa = false pdf_use_skia = false pdf_use_skia_paths = false pdf_is_standalone = true is_component_build = false clang_use_chrome_plugins = false  use_cxx11 = true use_custom_libcxx_for_host=false clang_version="7.1.0" disable_libfuzzer=true '
RUN cp -r /usr/lib/llvm-7/bin /polytracker/build/bin/polytracker/
RUN cp -r /usr/lib/llvm-7/include /polytracker/build/bin/polytracker/
RUN cp /polytracker/build/bin/polytracker/polyclang++ /polytracker/build/bin/polytracker/bin/clang++
RUN cp /polytracker/build/bin/polytracker/polyclang /polytracker/build/bin/polytracker/bin/clang
RUN head out/pdfium/toolchain.ninja
RUN echo "testing" > /PLACEHOLDER
RUN cp /polytracker/polytracker/custom_abi/pdfium_abi_list.txt /polytracker/build/bin/polytracker/abi_lists/polytrack_abilist.txt
RUN POLYPATH=/PLACEHOLDER ninja -C out/pdfium pdfium_test
