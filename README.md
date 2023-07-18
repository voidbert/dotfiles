# dotfiles

Configuration files for the software I use. I also developed some software for
everyday use, such as, but not limited to:

##### [Neovim](nvim)

- Asynchronous $\LaTeX$ compilation and preview
- [Termux](https://termux.dev) clipboard synchronization

##### [Swaywm](sway)

- Various shell scripts to complement sway's functionality
  - Perception-based backlight brightness ([backlight.sh](sway/backlight.sh))
  - Many types of screenshots ([screenshot.sh](sway/screenshot.sh))
  - External display helper script
    ([external-display.sh](sway/external-display.sh))
  - ...

- Efficient system information retriever for `swaybar` ([barinfo](sway/barinfo))

#### Other

- DuckDNS cron job script ([duckdns.sh](duckdns/duckdns.sh.pre))
- A config file for my configs :-) ([Makefile](Makefile))

## Building

A dotfile processor exists so that I can:

- Share some dotfiles without revealing personal information (like my DuckDNS
  domain)

- Change dotfiles from target to target (desktop vs laptop vs server)

For configuration, just edit the `Makefile`. For building files with the `.pre`
extension, run `make`. For removing build leftovers, run `make clean`. Because
I rarely install Linux on new systems, no automated process exists for placing
dotfiles in their respective directories.

