FROM dockersecplayground/alpine:latest
RUN apk add --no-cache --update iptables python
COPY getif /getif
COPY firewall.py /firewall.py
COPY firewall.sh /firewall.sh
LABEL \
	type="router" \
      actions.firewall.command="/firewall.sh" \ 
      actions.firewall.description="Exec an iptable rule (-i arg filled with IP of interface, \
      it will be replaced with proper interface " \ 
      actions.firewall.args.rule.val='-A FORWARD ' \
      actions.firewall.args.rule.type="text"

