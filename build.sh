#!/bin/bash
export SECRET_KEY_BASE=ENhzfdb/3IwgO8LX0QHfYqPfpU6I8kyrPG348vFwRkzxG0CjN7+egBO/F0RJnjxE
export MIX_ENV=prod

mix deps.get --only prod
mix compile
npm run deploy --prefix ./assets
mix phx.digest
mix release --overwrite

APP=FileBrowser
APP_DIR="${APP}.app/Contents/MacOS"
RELEASE=_build/prod/rel/elixir_desktop_application

rm -rf $APP.app
mkdir -p $APP_DIR
echo "cp -r $RELEASE $APP_DIR"
cp -r $RELEASE $APP_DIR
echo "#!/bin/bash" > $APP_DIR/$APP
echo 'DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"' >> $APP_DIR/$APP
echo '$DIR/elixir_desktop_application/bin/elixir_desktop_application start' >> $APP_DIR/$APP
chmod +x $APP_DIR/$APP

