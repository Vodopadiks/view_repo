FROM golang:1.16-buster AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /view_repo

FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=build /view_repo /view_repo

USER nonroot:nonroot

ENTRYPOINT [ "/view_repo" ]