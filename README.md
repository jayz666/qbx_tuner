# My Tuner QBX - Cleaned Package

This is a cleaned-up version of the uploaded archive so it has a usable FiveM resource layout.

## What was fixed
- Rebuilt a proper `fxmanifest.lua`
- Moved the actual client Lua code into `client.lua`
- Recreated the NUI build layout under `web/build/`
- Added a minimal `server.lua` placeholder so the package structure makes sense

## Expected dependencies
- `ox_lib` for notifications
- FiveM game build with native handling functions used by the client script

## Notes
- This is a packaging cleanup, not a full code rewrite.
- The original logic still needs live testing on your server.
- The client script uses the `/tuneditor` command to open the UI.

## Install
1. Put this folder in your resources directory.
2. Ensure `ox_lib` is started before this resource.
3. Add `ensure my_tuner_qbx_cleaned` to your server config.
