FROM registry1.dso.mil/ironbank/opensource/python39-stig-venv:v3.9

WORKDIR /app
COPY . /app
RUN /usr/local/bin/python3 -m ensurepip && \
    /usr/local/bin/python3 -m pip install --upgrade pip && \
    /usr/local/bin/pip3 install --no-cache-dir -r requirements.txt

CMD ["/usr/local/bin/python3", "src/app.py"]
