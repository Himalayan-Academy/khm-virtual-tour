@echo off

echo "Launching dev server (elm-live)"
copy debug.html .\debug\index.html
copy app.js .\debug\app.js
call node_modules\.bin\elm-live src\Main.elm --debug --output=debug\elm.js --dir=debug --path-to-elm=node_modules\.bin\elm --open --pushstate