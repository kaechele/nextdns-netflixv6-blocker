FROM fedora:latest

EXPOSE 53
EXPOSE 53/udp

RUN dnf -y install wget 
RUN wget -qO /etc/yum.repos.d/nextdns.repo https://nextdns.io/yum.repo
RUN dnf -y install bind-utils dnsmasq nextdns

COPY nextdns-run /usr/local/bin/nextdns-run
COPY dnsmasq.conf /etc/dnsmasq.conf
COPY block-aaaa-netflix.conf /etc/dnsmasq.d/block-aaaa-netflix.conf

HEALTHCHECK --interval=60s --timeout=10s --start-period=5s --retries=1 \
	CMD dig +time=20 @127.0.0.1 -p 53 probe-test.dns.nextdns.io && dig +time=20 @127.0.0.1 -p 8053 probe-test.dns.nextdns.io

CMD ["/usr/local/bin/nextdns-run"]
