### Get Linux
FROM nvidia/cuda:10.0-base
RUN apt-get update && apt-get install --no-install-recommends -y gcc clinfo ocl-icd-libopencl1 opencl-headers ocl-icd-opencl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y cgroup-bin cgroup-lite libcgroup1 && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y libseccomp-dev libseccomp2 seccomp && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /etc/OpenCL/vendors && echo "libnvidia-opencl.so.1" >/etc/OpenCL/vendors/nvidia.icd

RUN apt-get update && apt-get install --no-install-recommends -y openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;

# Prepare judger.jar
COPY target/judger-0.0.1-SNAPSHOT-jar-with-dependencies.jar /judger.jar

# Compile Profiler and copy it into judger home
COPY CC-Profiler-Sandbox/ /CC-Profiler-Sandbox/
WORKDIR /CC-Profiler-Sandbox
RUN gcc -std=c99 -o profiler main.c sandbox.c profiler.c logger.c killer.c rules/general.c rules/c_cpp.c rules/c_cpp_file_io.c -lpthread -lseccomp
RUN mkdir -p /judger/run && cp profiler /judger/run/profiler

WORKDIR /

CMD java -jar judger.jar



