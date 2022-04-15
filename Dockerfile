FROM ubuntu
RUN apt update && apt install -y openssh-client

COPY LICENSE README.md /
COPY entrypoint.sh /entrypoint.sh

WORKDIR /app

ENTRYPOINT ["entrypoint.sh"]
