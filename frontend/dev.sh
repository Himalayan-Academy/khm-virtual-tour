#!/bin/sh

echo "Launching dev server (elm-live)"
cp debug.html ./debug/index.html
rm ./debug/*.js
cp app.js ./debug/app.js
elm-live src/Main.elm  --dir=debug --open --pushstate -- --debug --output=debug/elm.js