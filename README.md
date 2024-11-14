# WebfishingButtplug

This is a mod for [WEBFISHING](https://store.steampowered.com/app/3146520/WEBFISHING/) that adds basic [Buttplug.io](https://buttplug.io/) integration.

## Dependencies

The mod is loaded using [GDWeave](https://github.com/NotNite/GDWeave/tree/main).

I used [Godot.Buttplug](https://github.com/erodozer/Godot.Buttplug) for the interesting bits, which is licensed under the MIT license and bundled into this package.

The mod will connect to a Buttplug server, which will _most likely_ be [Intiface Central](https://docs.intiface.com/docs/intiface-central/quickstart/).
See those docs for setup - they have extensive documentation. After the server is running, the game will connect to it via websockets on boot.

## Installing



## Features

- Vibrates at a base level while in the fishing minigame
- Vibration intensity increases while mashing

## Licenses

The following license is for Godot.Buttplug:

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