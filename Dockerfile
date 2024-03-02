FROM ubuntu:22.04

# Set noninteractive mode
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y wget bash curl ca-certificates nginx iproute2 zip unzip sudo \
    && apt-get install -y --no-install-recommends python3 python3-pip php gnupg2 \
    && apt-get install -y libjansson4 \
    && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:longsleep/golang-backports \
    && apt-get update \
    && apt-get install -y golang \
    && apt-get install -y make git lolcat figlet toilet \
    && apt-get install -y screen vim \
    && apt-get install -y iputils-ping \
    && rm -rf /var/lib/apt/lists/*

RUN adduser --home / container 
RUN echo "container:container" | chpasswd

# Accept root login
RUN echo "root:root" | chpasswd

# Add 'container' user to the root group
RUN usermod -aG root container

RUN mkdir -p /home/container
RUN chmod 777 -R /home/container

USER container
ENV USER container
ENV HOME /home/container
WORKDIR /

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
