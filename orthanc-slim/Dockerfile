FROM debian:wheezy-slim

MAINTAINER Sebastien Jodogne <s.jodogne@gmail.com>
LABEL Description="Slim image for Orthanc using LSB" Vendor="Osimis S.A."

WORKDIR /root/

ADD ./setup-locales.sh ./setup-locales.sh
RUN bash ./setup-locales.sh

ADD ./download-lsb.sh ./download-lsb.sh
RUN bash ./download-lsb.sh

ADD ./create-config.sh ./create-config.sh
RUN bash ./create-config.sh

RUN rm ./setup-locales.sh ./download-lsb.sh ./create-config.sh

VOLUME [ "/var/lib/orthanc/db" ]
EXPOSE 4242
EXPOSE 8042

ENTRYPOINT [ "Orthanc" ]
CMD [ "/etc/orthanc/" ]
