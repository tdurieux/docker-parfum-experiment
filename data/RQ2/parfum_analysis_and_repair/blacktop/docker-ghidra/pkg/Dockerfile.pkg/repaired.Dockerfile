FROM gradle:jdk11 as builder

ENV GITHUB_URL https://github.com/NationalSecurityAgency/ghidra.git

RUN apt-get update && apt-get install --no-install-recommends -y curl git bison flex build-essential unzip cmake clang-8 && rm -rf /var/lib/apt/lists/*;

RUN echo "[+] Cloning Ghidra..." \
    && git clone ${GITHUB_URL} /root/git/ghidra

WORKDIR /root/git/ghidra

COPY gradle.patch /tmp/gradle.patch

RUN echo "[+] Patching gradle..." \
    && git apply /tmp/gradle.patch

RUN echo "[+] Downloading dependencies..." \
    && gradle --init-script gradle/support/fetchDependencies.gradle init

RUN echo "[+] Building Ghidra..." \
    && gradle buildNatives_linux64 \
    && gradle sleighCompile \
    && gradle buildGhidra
# && gradle buildNatives_linux64 \
# && gradle buildNatives_osx64 \
# # && gradle buildNatives_win64 \
# && gradle sleighCompile \
# && gradle buildGhidra -PallPlatforms

##########################################################################################
FROM busybox

LABEL maintainer "https://github.com/blacktop"

COPY --from=builder /root/git/ghidra/build/dist /ghidra