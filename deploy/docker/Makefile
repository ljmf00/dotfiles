all: build test-network run
dist: build
dist:
	rm -rf local-userimage-luis.tar
	docker save ljmf00/userbox:latest -o local-userimage-luis.tar

build: build-devbox build-userbox

build-devbox:
	docker build -t ljmf00/devbox:latest $(DOCKER_BUILD_ARGS) \
		-f devbox/Dockerfile \
		../../

build-userbox:
	docker build -t ljmf00/userbox:latest $(DOCKER_BUILD_ARGS) \
		-f userbox/Dockerfile \
		../../

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
		-it ljmf00/userbox:latest
