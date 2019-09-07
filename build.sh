#!/bin/bash
export SECRET_KEY_BASE=ENhzfdb/3IwgO8LX0QHfYqPfpU6I8kyrPG348vFwRkzxG0CjN7+egBO/F0RJnjxE
export MIX_ENV=prod

mix deps.get --only prod
mix compile
npm run deploy --prefix ./assets
mix phx.digest
mix release --overwrite
