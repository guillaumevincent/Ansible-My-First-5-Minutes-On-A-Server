FROM python:2.7

RUN apt-get update && apt-get install -y \
  sudo \
  openssh-server

RUN pip install ansible==2.1.0

COPY . /tests
WORKDIR /tests

CMD ["/bin/bash"]