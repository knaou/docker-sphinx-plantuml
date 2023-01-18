#
# ローカル環境でCIを試す用
#

# Push時に利用するダミーDockerレジストリ
LOCAL_REGISTRY_NAME := local-registry

.PHONY: help
help:
	@echo "Makefile for dagger"
	@echo "Execute:"
	@echo "  make dagger                            : Do build"
	@echo "  make full                              : Do build and E2E test with testing environment"
	@echo "  make clean                             : Clean temporary files"

.PHONY: dagger
dagger: dagger-run
	@# dagger のビルドプロセスを実行する

.PHONY: full
full: test-service-up dagger-run dagger-push e2e-test test-service-down

.PHONY: clean
clean:
	@# 一時的に作成されたファイルを削除する
	rm -rf _build cue.mod

#
# Dagger tasks
# 

.PHONY: dagger-run
dagger-run: dagger-prepare
	@# Dagger によるテスト/ビルドを実行する
	dagger-cue do build --log-format=plain

dagger-push: dagger-run
	@# イメージをPushする
	dagger-cue do push_local --log-format=plain

.PHONY: dagger-prepare
dagger-prepare:
	@# Dagger の環境を準備する
	dagger-cue project init
	dagger-cue project update

#
# Testing tasks
#

.PHONY: e2e-test
e2e-test:
	@# E2Eテストを実行する
	mkdir -p _build/e2e; cd e2e; docker compose down --volumes && docker compose build && docker compose pull && docker compose run -u `id -u`:`id -g` e2e && docker compose down --volumes

#
# Testing environment tasks
#

.PHONY: test-service-up
test-service-up: registry-up
	@# テスト用のサービスを立ち上げる

.PHONY: test-service-down
test-service-down: registry-down
	@# テスト用のサービスを終了させる

.PHONY: registry-up
registry-up:
	docker start ${LOCAL_REGISTRY_NAME} || docker run -d --name=${LOCAL_REGISTRY_NAME} -p 15000:5000 registry

.PHONY: registry-down
registry-down:
	docker rm -f --volumes ${LOCAL_REGISTRY_NAME}


