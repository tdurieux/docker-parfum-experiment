# Note: Since git repositories are cloned, an active internet connection is required

# The predictions were performed on Debian 9 (stretch)
FROM debian:stretch

# Set the working directory to /app
WORKDIR /application

RUN apt update

# Add mono package repository and update repositories
RUN apt install --no-install-recommends -y -qq apt-transport-https dirmngr gnupg ca-certificates \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb https://download.mono-project.com/repo/debian stable-stretch main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
    && apt update && rm -rf /var/lib/apt/lists/*;

# Install git and wget
RUN apt install --no-install-recommends -y -qq git wget unzip mono-complete mono-devel nuget && rm -rf /var/lib/apt/lists/*;

# Install libgomp1 (dependency for z3)
RUN apt install --no-install-recommends -y -qq libgomp1 && rm -rf /var/lib/apt/lists/*;

# Download z3 (the library is needed for the constraint solver that is used inside SPL Conqueror)
RUN wget https://github.com/Z3Prover/z3/releases/download/z3-4.7.1/z3-4.7.1-x64-debian-8.10.zip \
    && unzip z3-4.7.1-x64-debian-8.10.zip \
    && rm z3-4.7.1-x64-debian-8.10.zip \
    && mv z3-4.7.1-x64-debian-8.10 z3 \
    && cp z3/bin/libz3.so /usr/lib/libz3.so

# Download SPL Conqueror and build it
RUN git clone --depth=1 https://github.com/se-passau/SPLConqueror.git \
    && cd SPLConqueror/SPLConqueror/ \
    && git submodule update --init \
    && nuget restore ./ \
    && msbuild /p:Configuration=Release /p:TargetFrameworkVersion="v4.5" /p:TargetFrameworkProfile="" ./SPLConqueror.sln \
    && cd ../..

# Install Python and its dependencies for the ML algorithms
RUN apt install --no-install-recommends -y -qq python3 virtualenv \
    && virtualenv --python=python3 python3-env \
    && . ./python3-env/bin/activate \
    && pip3 install --no-cache-dir scikit-learn==0.19 && rm -rf /var/lib/apt/lists/*;

