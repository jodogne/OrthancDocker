# Orthanc for Docker

[Docker Hub](https://hub.docker.com/u/jodogne) repository to build
[Orthanc](http://www.orthanc-server.com/) and its official
plugins. Orthanc is a lightweight, RESTful Vendor Neutral Archive for
medical imaging.

Summary of docker images hosted by this repository:

| Docker Image Name | Description |
| --- | --- |
| `jodogne/orthanc` | Docker image for the Orthanc core. This image is always kept in sync with the latest releases of the Orthanc project, with a basic configuration system that is inherited from the Debian packages. This image is most useful to software developers and researchers. |
| `jodogne/orthanc-plugins` | Docker image for the Orthanc core, together with its Web viewer, its PostgreSQL support, its DICOMweb implementation, and its whole-slide imaging viewer. |
| `jodogne/orthanc-python` | A heavier version of the `orthanc-plugins` image, as it embeds the Python 3.7 interpreter. This image is useful if you have an interest in the Python plugin. |

The content of this Docker repository is licensed under the AGPLv3+
license.
