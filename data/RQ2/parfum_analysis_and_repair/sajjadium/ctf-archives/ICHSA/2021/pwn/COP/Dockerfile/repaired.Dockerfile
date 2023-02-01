FROM ubuntu:18.04 as builder
RUN apt update
RUN apt install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
WORKDIR /root/
COPY chalenge.c chalenge.h ./
RUN gcc chalenge.c -Os -static -o game

FROM ubuntu:18.04

# Add socat
RUN apt update
RUN apt install --no-install-recommends -y socat && rm -rf /var/lib/apt/lists/*;

# Copy application source
WORKDIR /home/challenge
COPY --from=builder /root/game ./
COPY flag.txt ./

# Set non-root user
RUN adduser "--disabled-password"  user
USER user

# Set port
EXPOSE 6666

CMD ["socat","-T60", "TCP-LISTEN:6666,reuseaddr,fork", "EXEC:'/home/challenge/game'"]
