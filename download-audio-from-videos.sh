#!/bin/bash

# Check if jq is installed on the system
if ! [ -x "$(command -v jq)" ]; then
    echo 'Error: jq is not installed.' >&2
    exit 1
fi

while IFS= read -r id; do
    response=$(curl -s 'https://open.podimo.com/graphql?queryName=ShortLivedPodcastMediaUrlQuery' \
        -H 'authority: open.podimo.com' \
        -H 'accept: */*' \
        -H 'accept-language: da-DK,da;q=0.9' \
        -H 'apollographql-client-name: web-player' \
        -H 'apollographql-client-version: 1.0.0' \
        -H 'authorization: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRldGltZSI6IjIwMjItMDEtMzBUMTc6NDE6MjYuMDAwWiIsImlkIjoiZDY5YTkwNDUtZTZmZi00NmVkLWFiMjMtOWU4MmNhZWZkOTkxIiwibG9jYWxlIjoiZW4iLCJyZWdpb24iOiJkayIsInNlZ21lbnQiOiIzIiwiY3VycmVudFJlZ2lvbiI6ImRrIiwiY3VycmVudFJlZ2lvbkVudGVyZWREYXRldGltZSI6IjIwMjMtMTItMjFUMDc6MzQ6NDcuMDAwWiIsImlhdCI6MTcwODk4MDg3MH0.jIa75eJyUKqQhb65VmAD-TGN59fbGrpE7TD8Zl-U7lg' \
        -H 'content-type: application/json' \
        -H 'cookie: pmo_fp=a9c5ebfbc65de95b48950fb08aa27dea; pmo_loc=da-DK; pmo_lang=dk; pmo_c_func=true; pmo_c_stat=true; pmo_c_mark=true; pmo_c_acc=accepted; cf_chl_3=540a15cba8167ed; cf_clearance=cgSdqv08ZjTRZdaNSS2ws8ZCRmXk53hEmDrNLEAc7nQ-1708978774-1.0-Aa1IAw/B7zbhKjV1z/Q+Wrs3b4uxZ3KUKHx1PvVeZxjGlhoVKHW74Z3laWkybSIERGUq+TWBm3lUBE/7v6reLs0=; pmo_auth=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRldGltZSI6IjIwMjItMDEtMzBUMTc6NDE6MjYuMDAwWiIsImlkIjoiZDY5YTkwNDUtZTZmZi00NmVkLWFiMjMtOWU4MmNhZWZkOTkxIiwibG9jYWxlIjoiZW4iLCJyZWdpb24iOiJkayIsInNlZ21lbnQiOiIzIiwiY3VycmVudFJlZ2lvbiI6ImRrIiwiY3VycmVudFJlZ2lvbkVudGVyZWREYXRldGltZSI6IjIwMjMtMTItMjFUMDc6MzQ6NDcuMDAwWiIsImlhdCI6MTcwODk4MDg3MH0.jIa75eJyUKqQhb65VmAD-TGN59fbGrpE7TD8Zl-U7lg; __cf_bm=kYEqpjGcjKl39vI1f6PcEymXQ8A3UgeLG8ov8gLGN0I-1708981364-1.0-AUzars9Rpz3m3nqcUFcwR+pRJ2B7FolK4Jp2yX6LxNRiOccYcE/58b8WBGBBM1+eqYdIJDRFcgEiUxXkJjGeZbg=' \
        -H 'dnt: 1' \
        -H 'origin: https://open.podimo.com' \
        -H 'referer: https://open.podimo.com/podcast/c6ec0b3e-c71b-470c-ac39-f5fda8fee203' \
        -H 'sec-ch-ua: "Not A(Brand";v="99", "Google Chrome";v="121", "Chromium";v="121"' \
        -H 'sec-ch-ua-arch: "x86"' \
        -H 'sec-ch-ua-bitness: "64"' \
        -H 'sec-ch-ua-full-version: "121.0.6167.189"' \
        -H 'sec-ch-ua-full-version-list: "Not A(Brand";v="99.0.0.0", "Google Chrome";v="121.0.6167.189", "Chromium";v="121.0.6167.189"' \
        -H 'sec-ch-ua-mobile: ?0' \
        -H 'sec-ch-ua-model: ""' \
        -H 'sec-ch-ua-platform: "Windows"' \
        -H 'sec-ch-ua-platform-version: "15.0.0"' \
        -H 'sec-fetch-dest: empty' \
        -H 'sec-fetch-mode: cors' \
        -H 'sec-fetch-site: same-origin' \
        -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36' \
        -H 'user-locale: da' \
        -H 'user-platform: web-player' \
        -H 'user-version: 2.17.0' \
        -H 'web-player-version: 1.0.0' \
        --data-raw "{\"operationName\":\"ShortLivedPodcastMediaUrlQuery\",\"variables\":{\"podcastId\":\"c6ec0b3e-c71b-470c-ac39-f5fda8fee203\",\"episodeId\":\"$id\"},\"query\":\"query ShortLivedPodcastMediaUrlQuery(\$podcastId: String!, \$episodeId: String!) {\\n  podcastEpisodeStreamMediaById(podcastId: \$podcastId, episodeId: \$episodeId) {\\n    url\\n    __typename\\n  }\\n}\\n\"}" \
        --compressed)

    # make sure /episodes exists
    mkdir -p episodes/video-episodes/$id

    curl 'https://cdn.podimo.com/hls-media/ab4d059b-b37b-40ad-8a37-fd847adc652a/stream_audio_high/stream.m3u8' \
        -H 'authority: cdn.podimo.com' \
        -H 'accept: */*' \
        -H 'accept-language: da-DK,da;q=0.9' \
        -H 'dnt: 1' \
        -H 'origin: https://open.podimo.com' \
        -H 'referer: https://open.podimo.com/' \
        -H 'sec-ch-ua: "Not A(Brand";v="99", "Google Chrome";v="121", "Chromium";v="121"' \
        -H 'sec-ch-ua-mobile: ?0' \
        -H 'sec-ch-ua-platform: "Windows"' \
        -H 'sec-fetch-dest: empty' \
        -H 'sec-fetch-mode: cors' \
        -H 'sec-fetch-site: same-site' \
        -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36' \
        --compressed | grep -v "#" >"episodes/video-episodes/$id/stream.m3u8"

    # get all the .ts file names
    while IFS= read -r line; do
        if [[ $line == *.ts ]]; then
            wget -P "episodes/video-episodes/$id" "$m3u8/$line"
        fi
    done <hasVideoTrue.txt

    # make directory for all of the .ts files
    mkdir -p "episodes/video-episodes/$id/ts-files"

    # loop over all the .ts file names and download them from: https://cdn.podimo.com/hls-media/<id>/stream_audio_high/<file>
    while IFS= read -r line; do
        curl "https://cdn.podimo.com/hls-media/$id/stream_video_high/$line" \
            -H 'authority: cdn.podimo.com' \
            -H 'accept: */*' \
            -H 'accept-language: da-DK,da;q=0.9' \
            -H 'dnt: 1' \
            -H 'origin: https://open.podimo.com' \
            -H 'referer: https://open.podimo.com/' \
            -H 'sec-ch-ua: "Not A(Brand";v="99", "Google Chrome";v="121", "Chromium";v="121"' \
            -H 'sec-ch-ua-mobile: ?0' \
            -H 'sec-ch-ua-platform: "Windows"' \
            -H 'sec-fetch-dest: empty' \
            -H 'sec-fetch-mode: cors' \
            -H 'sec-fetch-site: same-site' \
            -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36' \
            --compressed --output "episodes/video-episodes/$id/ts-files/$line"
    done <"episodes/video-episodes/$id/stream.m3u8"

done <hasVideoTrue.txt
