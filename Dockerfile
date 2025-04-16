FROM registry1.dso.mil/ironbank/opensource/python39-stig-venv:v3.9

WORKDIR /app
COPY . /app
RUN find / -name "python*" && find / -name "pip*"
