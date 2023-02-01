# Build TLS-Scanner
FROM maven:3-jdk-8 AS tls-scanner-build

RUN git clone --depth=1 --branch '3.1' https://github.com/RUB-NDS/TLS-Attacker.git && \
	git clone --depth=1 --recurse-submodules --branch '2.9' https://github.com/RUB-NDS/TLS-Scanner.git && \
	(cd /TLS-Attacker/ && mvn clean install -DskipTests=true) && \
	(cd /TLS-Scanner/ && mvn clean install -DskipTests=true)

# Build Grinder Framework