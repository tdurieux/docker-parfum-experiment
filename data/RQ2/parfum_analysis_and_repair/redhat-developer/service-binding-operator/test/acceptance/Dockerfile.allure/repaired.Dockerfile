FROM quay.io/pmacik/yhxue911-python-allure

COPY entrypoint.sh /entrypoint.sh

EXPOSE 8080

ENTRYPOINT [ "/entrypoint.sh" ]