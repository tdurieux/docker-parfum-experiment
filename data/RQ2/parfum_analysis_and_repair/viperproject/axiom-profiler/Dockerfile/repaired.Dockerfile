FROM x11vnc/desktop:20.04

# Install mono
RUN apt update
RUN apt install --no-install-recommends -y gnupg ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" > /etc/apt/sources.list.d/mono-official-stable.list
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y mono-devel && rm -rf /var/lib/apt/lists/*;

# Compile the axiom profiler
USER ubuntu
COPY --chown=ubuntu:ubuntu . /home/ubuntu/axiom-profiler
WORKDIR /home/ubuntu/axiom-profiler
ADD --chown=ubuntu:ubuntu https://nuget.org/nuget.exe nuget.exe
RUN mono ./nuget.exe install Microsoft.Net.Compilers
RUN xbuild /p:Configuration=Release source/AxiomProfiler.sln
