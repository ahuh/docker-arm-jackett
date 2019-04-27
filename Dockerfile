# Jackett
#
# Version 1.0

FROM balenalib/rpi-raspbian:buster
LABEL maintainer "ahuh"

# Volume config: home directory for execution user, contains ServerConfig.json and configuration dirs (generated at first start if needed)
VOLUME /config
# Volume downloads
VOLUME /downloads

# Set execution user (PUID/PGID)
ENV AUTO_UPDATE=\
    PUID=\
    PGID=
# Set xterm for nano
ENV TERM xterm

# Copy custom bashrc to root (ll aliases)
COPY root/ /root/

# Update packages and install software
RUN apt-get update \
	&& apt-get install -y libcurl4-openssl-dev wget unzip nano \
	&& apt-get install -y mono-complete mono-devel ca-certificates-mono \
	&& apt-get install -y dumb-init \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
	
# Download and manually install Jackett
RUN mkdir -p /opt/jackett \
	&& mkdir -p /etc/jackett \
 	&& export JACKETT_VERSION=$(curl -k -sX GET "https://api.github.com/repos/Jackett/Jackett/releases/latest" | tac | awk '/tag_name/{print $4;exit}' FS='[""]') \
	&& echo $JACKETT_VERSION > /etc/jackett/jackett_version \
	&& curl -k -o /tmp/jacket.tar.gz -L https://github.com/Jackett/Jackett/releases/download/$JACKETT_VERSION/Jackett.Binaries.Mono.tar.gz \
	&& tar xf /tmp/jacket.tar.gz -C /opt/jackett --strip-components=1

# Create and set user & group for impersonation
RUN groupmod -g 1000 users \
    && useradd -u 911 -U -d /config -s /bin/false abc \
    && usermod -G users abc
	
# Copy scripts
COPY jackett/ /etc/jackett/

# Make scripts executable
RUN chmod +x /etc/jackett/*.sh

# Expose port
EXPOSE 9117

# Launch Jackett at container start
CMD ["dumb-init", "/etc/jackett/start.sh"]

