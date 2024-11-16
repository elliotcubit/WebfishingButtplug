# WebfishingButtplug

This is a mod for [WEBFISHING](https://store.steampowered.com/app/3146520/WEBFISHING/) that adds basic [Buttplug.io](https://buttplug.io/) integration.

I don't expect anyone to actually _use_ this, but I hope it's helpful to you regardless!

## Features

- Vibrates at a base level while in the fishing minigame
- Vibration intensity increases while mashing

## Installing

1. Install [Intiface Central](https://docs.intiface.com/docs/intiface-central/quickstart/).
1. Install [GDWeave](https://github.com/NotNite/GDWeave/tree/main).
1. Install [TackleBox](https://github.com/puppy-girl/TackleBox/).
1. Download the latest release and unzip it into your `GWWeave/mods` folder.
1. Ensure Intiface Central is running.
1. Start the game
1. You're good to go!

Your game files should look something like this, if things are installed correctly:

```
WEBFISHING /
  webfishing.exe     // game files
  steam_api64.dll    // game files
  winmm.dll          // GDWEAVE dependency
  GDWEAVE/
    GDWeave.log      // Log output of modloader
    configs/
    core/
    mods/
      ButtPlugIO/    // The capitalization DOES matter!!
        ButtPlugIO.dll
        // ... and other files
```

## Dependencies

The mod is loaded using [GDWeave](https://github.com/NotNite/GDWeave/tree/main).

It depends also on [TackleBox](https://thunderstore.io/c/webfishing/p/PuppyGirl/TackleBox/), which is used to configure the mod in-game.

The mod will connect to a Buttplug server, which will _most likely_ be [Intiface Central](https://docs.intiface.com/docs/intiface-central/quickstart/).
See those docs for setup - they have extensive documentation. After the server is running, the game will connect to it via websockets on boot.

## Debugging

This thing is a little buggy at this time. If it drops connection to the device (or to IC central), open the mod menu and try turning it off-and-on again.
If no luck, please feel free to file a GitHub Issue!.

## Donations

If you want to compensate me for this work (please do not feel like you need to do this), please consider donating to [The Trevor Project](https://give.thetrevorproject.org/give/63307/#!/donation/checkout) or [The ACLU](https://action.aclu.org/give/now).

## Licenses

The following license is for [Godot.Buttplug](https://github.com/erodozer/Godot.Buttplug), which I used for most of the interesting bits and bundled in here:

MIT License

Copyright (c) 2021 Nicholas Hydock

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.