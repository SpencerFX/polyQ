.PHONY: all setup test adapter rdb hdb gateway clean docker-build docker-up

Q ?= q
PYTHON ?= python3

all: setup

setup:
	pip install -r adapter/requirements.txt

adapter:
	$(PYTHON) adapter/polyq_ws.py --port 17000 --qport 5010

rdb:
	$(Q) db/rdb.q -p 5010 -config config/settings.q

hdb:
	$(Q) db/hdb.q /data/polyQ/hdb -p 5012 -config config/settings.q

gateway:
	$(Q) gateway/gw.q -p 5000 -config config/settings.q

test:
	$(Q) tests/test_feed.q -e 1

docker-build:
	docker-compose -f docker/docker-compose.yml build

docker-up:
	docker-compose -f docker/docker-compose.yml up -d

clean:
	rm -rf *.log *.tmp
