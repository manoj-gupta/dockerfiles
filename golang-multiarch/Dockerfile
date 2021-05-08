FROM golang:alpine AS build
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I was built on a platform running on $BUILDPLATFORM, building this image for $TARGETPLATFORM" > /log

FROM alpine
COPY --from=build /log /log
CMD [ "cat", "/log" ]
