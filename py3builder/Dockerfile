FROM amd64/debian:bullseye
LABEL py3img="py3builder"

RUN apt update -y
RUN apt upgrade -y

RUN apt install -y build-essential python3 python3-dev gcc python3-pip python3-pyqt5 patchelf
RUN pip3 install Nuitka

COPY src/_req.txt /req.txt
RUN pip3 install -r /req.txt