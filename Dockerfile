FROM registry1.dso.mil/ironbank/opensource/python/python3:3.9

WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "src/app.py"]
