FROM registry1.dso.mil/ironbank/opensource/python39-stig-venv:v3.9

WORKDIR /app
COPY . /app

RUN /opt/python-env/bin/pip3 install --no-cache-dir -r requirements.txt

CMD ["/opt/python-env/bin/python3", "src/app.py"]
