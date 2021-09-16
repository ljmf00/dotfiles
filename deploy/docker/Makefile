all: build test-network run

build:
	docker build -t local-userimage-luis $(DOCKER_BUILD_ARGS) \
		-f Dockerfile \
		../../

dist: build
dist:
	docker save local-userimage-luis -o local-userimage-luis.tar

test-network:
	docker network rm macvlan0
	docker network create -d macvlan -o parent=enp0s20f0u1u1 \
		--subnet 192.168.1.0/24 \
		--ip-range=192.168.1.20/31 \
		--gateway 192.168.1.254 \
		macvlan0

run:
	docker run --rm \
		--network=macvlan0 \
		--cgroupns private \
		--tmpfs /run --tmpfs /tmp \
		--name local-usercontainer-luis \
		-h tornado-box \
		-it local-userimage-luis
