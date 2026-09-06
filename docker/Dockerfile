FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    python3 python3-pip curl unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY adapter/requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Note: Requires standard 64-bit kdb+ installation binaries copied into image
COPY . /app

EXPOSE 5010 5012 5000
CMD ["q"]
