# Haskell環境をセットアップ
FROM fpco/stack-build:lts-18.18 AS builder

# ワーキングディレクトリを設定
WORKDIR /app

# Stackの設定ファイルをコピー
COPY haskell/stack.yaml haskell/stack.yaml
COPY haskell/package.yaml haskell/package.yaml

# Haskellのソースコードをコピー
COPY haskell/src/ haskell/src/

# Stackを使って依存関係をインストール
RUN stack setup
RUN stack build

# 本番環境用のイメージを準備
FROM ubuntu:20.04

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# ビルドしたバイナリをコピー
COPY --from=builder /app/.stack-work/install/x86_64-linux/lts-18.18/8.10.7/bin/my-haskell-app /usr/local/bin/my-haskell-app

# Expose the port the app runs on
EXPOSE 8080

# Command to run the Haskell app
CMD ["stack", "exec", "haskell-app"]
