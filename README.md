# Features:

• Whitelist only mode:
- Users on the whitelist can join.
- Users not on the whitelist can't join.

• Password only mode:
- Users knowing the password can join.
- Users not knowing the password can't join.

• Whitelist and password mode:
- Users not on the whitelist can't join.
- Users on the whitelist will be asked for the password.

• CleverMode:
- Users on the whitelist automatically skip the password.
- Users not on the whitelist will be asked for the password.

• Easy to configure (password, attempts, Discord link shown on refused connection).

• Shows user all of his/her identifiers and a link upon refused connection to easily copy/paste identifiers.



# Installation:

• Clone or download via github.

• Put it into `resources`.

• Add `start pun_whitelist` to your server.cfg file.

• Start the server. If it's already up just type `refresh` followed by `start pun_whitelist` into the server or client console.



# Credits

• [enferList](https://forum.cfx.re/t/release-enferlist-another-whitelist-script/81697) | Some bits of code but mostly the logic and idea on how I wanted this script to work in the end.

• [Frazzle](https://gist.github.com/FrazzIe/f59813c137496cd94657e6de909775aa) | Basically 100% of the code that makes the passwords work.
