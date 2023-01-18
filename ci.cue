package ci
// 使うコマンドをインポートする
import (
  "dagger.io/dagger"
  "universe.dagger.io/docker"
)
// 実行するプラン。
dagger.#Plan & {
  // 実行するクライアントの設定
  client: {
    env: {
      REGISTRY_PASS: dagger.#Secret
    }
    filesystem:{
      "./": read: {
        contents: dagger.#FS
        exclude: [
          "ci.cue",
        ]
      }
    }
  }
  // 定義するAction
  actions: {
    // ビルドする
    build: docker.#Dockerfile & {
      source: client.filesystem."./".read.contents 
      dockerfile: path: "Dockerfile"
    }
    // Pushする
    push_local: docker.#Push & {
      image: build.output
      dest: "localhost:15000/testing-image"
    }
    push_dockerhub: docker.#Push & {
      image: build.output
      dest: "knaou/sphinx-plantuml"
      auth: {
        username: "knaou"
        secret: client.env.REGISTRY_PASS
      }
    }
  }
}

