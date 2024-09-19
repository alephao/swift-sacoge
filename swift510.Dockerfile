FROM swift:5.10

WORKDIR /app

COPY Package.* ./

RUN swift package resolve --skip-update \
        $([ -f ./Package.resolved ] && echo "--force-resolved-versions" || true)

COPY ./Plugins ./Plugins
COPY ./Sources ./Sources
COPY ./Tests ./Tests

