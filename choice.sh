#!/bin/bash

OS_NAME="$(uname | awk '{print tolower($0)}')"

SHELL_DIR=$(dirname $0)

MENU=${SHELL_DIR}/menu.txt

COUNT=$(cat ${MENU} | wc -l | xargs)

# # for delay
# mkdir -p ${SHELL_DIR}/target
# curl -sL https://raw.githubusercontent.com/nalbam/lunch/master/menu.txt > ${SHELL_DIR}/target/menu.txt

# random number
if [ "${OS_NAME}" == "darwin" ]; then
    RND=$(ruby -e "p rand(1...${COUNT})")
else
    RND=$(shuf -i 1-${COUNT} -n 1)
fi

# get one
if [ ! -z ${RND} ]; then
    SELECTED=$(sed -n ${RND}p ${MENU})
fi
if [ "${SELECTED}" == "" ]; then
    SELECTED="0 diet"
fi

echo "menu: ${RND} ${SELECTED}"

ARR=(${SELECTED})

if [ "x${ARR[0]}" == "x0" ]; then
    LINK=""
    MENU="\`${ARR[1]}\`"
else
    LINK="http://map.daum.net/?itemId=${ARR[0]}"
    MENU="\`${ARR[1]}\`"
fi

echo "${MENU}"

if [ ! -z ${SLACK_TOKEN} ]; then
    curl -sL opspresso.com/tools/slack | bash -s -- \
        --token="${SLACK_TOKEN}" --channel="random" --username="lunch" \
        --color="good" --emoji=":fork_and_knife:" \
        --title="오늘의 식당" "${MENU} ${LINK}"
fi
