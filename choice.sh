#!/bin/bash

OS_NAME="$(uname | awk '{print tolower($0)}')"

SHELL_DIR=$(dirname $0)

MENU=${SHELL_DIR}/menu.txt

COUNT=$(cat ${MENU} | wc -l | xargs)

# for delay
mkdir -p ${SHELL_DIR}/target
curl -sL https://raw.githubusercontent.com/nalbam/lunch/master/menu.txt > ${SHELL_DIR}/target/menu.txt

# random number
if [ "${OS_NAME}" == "linux" ]; then
    RND=$(shuf -i 1-${COUNT} -n 1)
elif [ "${OS_NAME}" == "darwin" ]; then
    RND=$(ruby -e "p rand(1...${COUNT})")
else
    RND=
fi

# get one
if [ ! -z ${RND} ]; then
    SELECTED=$(sed -n ${RND}p ${MENU})
fi
if [ -z ${SELECTED} ]; then
    SELECTED="diet"
fi

echo "menu: ${RND} ${SELECTED}"

if [ ! -z ${SLACK_TOKEN} ]; then
    ${SHELL_DIR}/slack.sh --token="${SLACK_TOKEN}" \
        --emoji=":fork_and_knife:" --username="lunch" \
        --color="good" --title="오늘의 식당" "\`${SELECTED}\`"
fi
