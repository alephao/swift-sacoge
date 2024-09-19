FROM swift:6.0

WORKDIR /app

COPY Package.* ./

RUN swift package resolve --skip-update \
        $([ -f ./Package.resolved ] && echo "--force-resolved-versions" || true)

COPY ./Plugins ./Plugins
COPY ./Sources ./Sources
COPY ./Tests ./Tests

