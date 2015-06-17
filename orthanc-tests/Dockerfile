FROM jodogne/orthanc:0.8.6

MAINTAINER Sebastien Jodogne <s.jodogne@gmail.com>
LABEL Description="Environment to run the integration tests of Orthanc" Vendor="Sebastien Jodogne, University Hospital of Liege"

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install dcmtk python-imaging python-httplib2 dicom3tools && rm -rf /var/lib/apt/lists/*
