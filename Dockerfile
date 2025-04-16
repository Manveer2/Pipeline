FROM registry1.dso.mil/ironbank/opensource/python39-stig-venv:v3.9

WORKDIR /app
COPY . /app
RUN python -m ensurepip && python -m pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

CMD ["python", "src/app.py"]
