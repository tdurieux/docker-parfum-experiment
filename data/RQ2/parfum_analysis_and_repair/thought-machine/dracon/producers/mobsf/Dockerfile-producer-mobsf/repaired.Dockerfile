FROM opensecurity/mobile-security-framework-mobsf:v3.1.1 as mobsf

COPY /entrypoint /

WORKDIR /
ENTRYPOINT ["/entrypoint"]