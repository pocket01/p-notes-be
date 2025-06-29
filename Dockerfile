# マルチステージビルドを使用
# ビルドステージ
FROM golang:1.24-alpine AS builder

# 作業ディレクトリを設定
WORKDIR /app

# 依存関係をコピー
COPY go.mod go.sum ./

# 依存関係をダウンロード
RUN go mod download

# ソースコードをコピー
COPY main.go go.sum go.mod ./

# アプリケーションをビルド
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# 実行ステージ
FROM alpine:latest

# @TODO 現状はローカルのみなのでコメントアウト（郁々は解除するかも）
# セキュリティアップデートとCA証明書をインストール
# RUN apk --no-cache add ca-certificates

# 作業ディレクトリを設定
WORKDIR /root/

# ビルドステージからバイナリをコピー
COPY --from=builder /app/main .

# ポート8080を公開
EXPOSE 8080

# アプリケーションを実行
CMD ["./main"]
