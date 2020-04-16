FROM debian:stable-slim

MAINTAINER Sebastien Jodogne <s.jodogne@gmail.com>
LABEL Description="Orthanc, free DICOM server" Vendor="The Orthanc project"

WORKDIR /root/

ADD ./setup-locales.sh ./setup-locales.sh
RUN bash ./setup-locales.sh

ADD ./download-orthanc.sh ./download-orthanc.sh
RUN bash ./download-orthanc.sh

ADD ./create-config.sh ./create-config.sh
RUN bash ./create-config.sh

RUN rm ./setup-locales.sh ./download-orthanc.sh ./create-config.sh

VOLUME [ "/var/lib/orthanc/db" ]
EXPOSE 4242
EXPOSE 8042

ENTRYPOINT [ "Orthanc" ]
CMD [ "/etc/orthanc/" ]

# https://groups.google.com/d/msg/orthanc-users/qWqxpvCPv8g/Z8huoA5FDAAJ
ENV MALLOC_ARENA_MAX 5
