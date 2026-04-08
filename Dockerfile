FROM ubuntu/squid:latest

# Copy config and whitelist into the correct location inside the container
COPY squid.conf /etc/squid/squid.conf
COPY whitelist.txt /etc/squid/whitelist.txt

# Fix permissions (Squid runs as user "proxy")
RUN chown proxy:proxy /etc/squid/squid.conf /etc/squid/whitelist.txt && \
    chmod 644 /etc/squid/squid.conf /etc/squid/whitelist.txt

# Squid will auto-create cache dirs on first start