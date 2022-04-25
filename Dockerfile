FROM golang:1.17 as builder
WORKDIR /build
ADD go.mod go.sum /build/
RUN go mod download
ADD . /build/
RUN CGO_ENABLED=0 go build -o controller.bin .

FROM alpine:3.13
RUN apk add --no-cache ca-certificates bash
COPY --from=builder /build/controller.bin /bin/hcloud-cloud-controller-manager
ENTRYPOINT ["/bin/hcloud-cloud-controller-manager"]
