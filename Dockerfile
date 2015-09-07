FROM phusion/baseimage
MAINTAINER Higherpass <git@higherpass.com>

ENV DEBIAN_FRONTEND noninteractive

# Install Packages
RUN apt-get update \
  && apt-get install -y \
    prosody

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Startup scripts based on phusion/baseimage
RUN mkdir /etc/service/prosody
ADD ./scripts/prosody /etc/service/prosody/run
RUN chmod +x /etc/service/prosody/run

# Configure Prosody
RUN sed -i 's/daemonize = true;/daemonize = false;/g' /etc/prosody/prosody.cfg.lua
RUN sed -i 's/allow_registration = false;/allow_registration = true;/g' /etc/prosody/prosody.cfg.lua
RUN sed -i 's/localhost\.crt/localhost\.cert/g' /etc/prosody/prosody.cfg.lua

# Create PID file directory
RUN mkdir -p /var/run/prosody
RUN chown prosody.prosody /var/run/prosody

# Allow external connections
EXPOSE 5222
#USER prosody
CMD ["/sbin/my_init"]
