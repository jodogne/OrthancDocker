FROM debian:trixie-slim

LABEL orth.opencontainers.image.authors="s.jodogne@gmail.com"
LABEL Description="Orthanc, free DICOM server" Vendor="The Orthanc project"

RUN apt-get -y clean && apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install wget locales wget libopenslide0 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /root/

ADD ./setup-locales.sh ./setup-locales.sh
RUN bash ./setup-locales.sh

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

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
