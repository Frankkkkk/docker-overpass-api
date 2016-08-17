OVERPASS_DB_DIR=/mnt/ssd/overpass_DB
run: build
	docker run -d \
	--restart=always \
	-v $(OVERPASS_DB_DIR):/overpass_DB \
	-p 5001:80 \
	overpass_api

build:
	docker build -t overpass_api .
