.PHONY: help start stop start_db stop_db console bundle deps migrate seed attach test test_start_db test_stop_db load_envs

TMP := $(shell [ -d /private/tmp ] && echo "/private/tmp")
help:
	@awk 'BEGIN {FS = ":.*##"; printf "List of available commands (usage: make \033[36m<target>\033[0m):\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-13s\033[0m%s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

start: ## Start the services
	docker-compose build && docker-compose up

stop: ## Stop the services
	docker-compose down

rspec: ## runs rspec and deletes the related exited containers
	docker-compose -f test.docker-compose.yml build && \
	docker-compose -f test.docker-compose.yml run test bundle exec rspec && \
	docker-compose -f test.docker-compose.yml down && \
	docker rm $$(docker ps -f status=exited | grep -w framework_advanced-test | awk '{ print $$1 }')
# TODO: allow passing the specific file to the command

brakeman: ## runs brakeman and deletes the related exited containers
	docker-compose -f test.docker-compose.yml build && \
	docker-compose -f test.docker-compose.yml run test bundle exec brakeman --color && \
	docker-compose -f test.docker-compose.yml down && \
	docker rm $$(docker ps -f status=exited | grep -w framework_advanced-test | awk '{ print $$1 }')

rubycritic: ## runs brakeman and deletes the related exited containers
	docker-compose -f test.docker-compose.yml build && \
	docker-compose -f test.docker-compose.yml run test bundle exec rubycritic && \
	docker-compose -f test.docker-compose.yml down && \
	docker rm $$(docker ps -f status=exited | grep -w framework_advanced-test | awk '{ print $$1 }')

rubocop: ## runs brakeman and deletes the related exited containers
	docker-compose -f test.docker-compose.yml build && \
	docker-compose -f test.docker-compose.yml run test bundle exec rubocop && \
	docker-compose -f test.docker-compose.yml down && \
	docker rm $$(docker ps -f status=exited | grep -w framework_advanced-test | awk '{ print $$1 }')
# TODO: allow passing the specific file to the command

console: ## runs console
	docker-compose run demo-web bundle exec rails console && \
	docker rm $$(docker ps -f status=exited | grep -w framework_advanced-demo-web | awk '{ print $$1 }') && \
	docker-compose down

