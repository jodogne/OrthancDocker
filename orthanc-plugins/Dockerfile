FROM jodogne/base

MAINTAINER Sebastien Jodogne <s.jodogne@gmail.com>

ADD ./build.sh ./build.sh
RUN bash ./build.sh "default"

VOLUME [ "/var/lib/orthanc/db" ]
EXPOSE 4242
EXPOSE 8042

ENTRYPOINT [ "Orthanc" ]
CMD [ "/etc/orthanc/orthanc.json" ]
