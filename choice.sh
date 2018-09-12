#!/bin/bash

OS_NAME="$(uname | awk '{print tolower($0)}')"

SHELL_DIR=$(dirname $0)

SLACK_TOKEN=${1}

MENU=${SHELL_DIR}/menu.txt
COUNT=$(cat ${MENU} | wc -l)

if [ "${OS_NAME}" == "linux" ]; then
    RND=$(shuf -i 1-${COUNT} -n 1)
elif [ "${OS_NAME}" == "darwin" ]; then
    RND=$(ruby -e "p rand(1...${COUNT})")
else
    RND=
fi

if [ ! -z ${RND} ]; then
    WORD=$(sed -n ${RND}p ${MENU})
fi

if [ -z ${WORD} ]; then
    WORD="diet"
fi

echo "menu: ${WORD}"

if [ ! -z ${SLACK_TOKEN} ]; then
    ${SHELL_DIR}/slack.sh --token="${SLACK_TOKEN}" \
        --color="good" --title="오늘의 메뉴" --emoji=":fork_and_knife:" "`${WORD}`"
fi
