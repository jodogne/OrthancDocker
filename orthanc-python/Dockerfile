FROM jodogne/orthanc-plugins:1.7.2

MAINTAINER Sebastien Jodogne <s.jodogne@gmail.com>
LABEL Description="Orthanc, free DICOM server, with plugins and Python" Vendor="The Orthanc project"

RUN apt-get -y clean && apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python3.7 libpython3.7 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ADD ./download-python.sh ./download-python.sh
RUN bash ./download-python.sh

RUN rm ./download-python.sh

VOLUME [ "/var/lib/orthanc/db" ]
EXPOSE 4242
EXPOSE 8042

ENTRYPOINT [ "Orthanc" ]
CMD [ "/etc/orthanc/" ]
