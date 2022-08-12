# Features:
- Allowlist only mode (You have to be allowlisted, no password prompt)
- Password only mode (You have to know the password, no allowlist check)
- Allowlist and password mode (You have to be allowlisted and know the password)
- Clever mode (If you're allowlisted, you're not asked for a password. If you're not allowlisted, you're asked for one.)
- Easy to configure (password, attempts, Discord link shown on refused connection)
- Shows user all of his/her identifiers and a link upon refused connection to easily copy/paste identifiers.



# Installation:
- Clone or download via github.
- Put it into `resources`.
- Add `start pun_allowlist` to your server.cfg file.
- Start the server. If it's already up just type `refresh` followed by `start pun_allowlist` into the server or client console.



# ConnectQueue compatibility:
- Download and install the [experimental](https://github.com/Puntherline/pun_allowlist/tree/experimental) branch instead of the main branch.
- Make sure you have the latest version of [ConnectQueue](https://github.com/Nick78111/ConnectQueue) installed.
- Go to `connectqueue/shared/sh_queue.lua`, line 653, look for this part of the code:
```lua
AddEventHandler("playerConnecting", playerConnect)
```
- Make it look like this:
```lua
AddEventHandler("pun_allowlist:playerConnecting", playerConnect)
```
- Now in line 444, look for this part of the code:
```lua
local function playerConnect(name, setKickReason, deferrals)
	local src = source
```
- Make it look like this:
```lua
local function playerConnect(player, name, setKickReason, deferrals)
	local src = player
```



# Credits:
- [enferList](https://forum.cfx.re/t/release-enferlist-another-whitelist-script/81697) | Some bits of code but mostly the logic and idea on how I wanted this script to work in the end.
- [Frazzle](https://gist.github.com/FrazzIe/f59813c137496cd94657e6de909775aa) | Basically 100% of the code that makes the passwords work.
