FROM debian:wheezy-slim

MAINTAINER Sebastien Jodogne <s.jodogne@gmail.com>
LABEL Description="Atom-IT, lightweight server for IoT" Vendor="WSL"

WORKDIR /root/

ADD ./setup-debian.sh ./setup-debian.sh
RUN bash ./setup-debian.sh

ADD ./download-atomit.sh ./download-atomit.sh
RUN bash ./download-atomit.sh

ADD ./create-config.sh ./create-config.sh
RUN bash ./create-config.sh

RUN rm ./download-atomit.sh ./create-config.sh ./setup-debian.sh

VOLUME [ "/var/lib/atomit/db", "/etc/atomit" ]
EXPOSE 8042

ENTRYPOINT [ "AtomIT" ]
CMD [ "/etc/atomit/atomit.json" ]
