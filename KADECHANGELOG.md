# 1.5.3 changelog

Changes marked with 💖 will be listed in the short version of the changelog in `version.downloadMe`.

### Additions
- Score Screen (💖)
- Show your highest combo in the freeplay menu
- New asset loading system (💖)
- New Logo (💖)

### Changes
- Rewrote the entire hit ranking system (💖)

### Bugfixes
- NPS not showing if accuracy is disabled
- Fixed song names so they don't crash (💖)


# Changelog for 1.5.2

Changes marked with 💖 will be listed in the short version of the changelog in `version.downloadMe`.

### Additions
- [PR #786](https://github.com/KadeDev/Kade-Engine/pull/786): Add Acceleration, Drag and Velocity to X and Y for Actors in modcharts

### Bugfixes
- [PR #756](https://github.com/KadeDev/Kade-Engine/pull/756):  Fix bugs with combo counter
- 💖 PRs [#763](https://github.com/KadeDev/Kade-Engine/pull/763), [#789](https://github.com/KadeDev/Kade-Engine/pull/789): Fix bug where songs with spaces in the name would crash
- Fix skipping notes for judgements

## Links
[GitHub Release](https://github.com/KadeDev/Kade-Engine/releases/tag/1.5.2) · [Last Windows CI build]() · [Last macOS CI build]() · [Last Linux CI build]()


# 1.5.1 changelog

Changes marked with 💖 will be listed in the short version of the changelog in `version.downloadMe`.

### Changes
- Changed package from `com.ninjamuffin99.funkin` to `com.kadedev.kadeengine`

### Bugfixes
- You can no longer bind keys like enter or escape (fixes crash that happened when you did)
- Fixed score display
- Fixed bug with spooky kids' dance
- Fixed week 4 and 6 sprite issues
- Made web builds work again
- Game Play Customiziation works now.


# 1.5.0 changelog

Changes marked with 💖 will be listed in the short version of the changelog in `version.downloadMe`.

### Additions
- [PR #307](https://github.com/KadeDev/Kade-Engine/pulls/307): Fix freeplay lag, add freeplay background changes, and add icons updating in charting state
- Updated to Week 7 input with anti mash
- 💖 Added toggle for ghost tapping
- (maybe 💖) [PR #328](https://github.com/KadeDev/Kade-Engine/pulls/328) and [PR #331](https://github.com/KadeDev/Kade-Engine/pulls/331): Distractions toggle
- [PR #341](https://github.com/KadeDev/Kade-Engine/pull/341): Update heads in realtime in charting state
- 💖 [PR #362](https://github.com/KadeDev/Kade-Engine/pull/362): Officially support macOS (and add macOS requirements to docs)
- Set up macOS CI builds
- [PR #373](https://github.com/KadeDev/Kade-Engine/pull/373): Add tweens to modcharts
- [PR #367](https://github.com/KadeDev/Kade-Engine/pull/367): Add labels to charting state
- [PR #374](https://github.com/KadeDev/Kade-Engine/pull/374): Add more icon sizes
- 💖 [PR #385](https://github.com/KadeDev/Kade-Engine/pull/385): Autoplay
- (maybe 💖) [#353](https://github.com/KadeDev/Kade-Engine/issues/353) ([PR #400](https://github.com/KadeDev/Kade-Engine/pulls/400)): Clap assist for syncing charts
- [PR #413](https://github.com/KadeDev/Kade-Engine/pulls/413): Option to disable flashing lights in menus
- [PR #428](https://github.com/KadeDev/Kade-Engine/pulls/428): Move documentation to GitHub Pages + new changelog system
- [PR #431](https://github.com/KadeDev/Kade-Engine/pull/431): Add Max NPS counter
- [PR #447](https://github.com/KadeDev/Kade-Engine/pull/447): New outdated version screen with small patch notes
- (maybe 💖) [PR #490](https://github.com/KadeDev/Kade-Engine/pull/490): Bring back `R` to reset, but now you can toggle it in the options
- [PR #551](https://github.com/KadeDev/Kade-Engine/pull/551): Add setActorScaleXY, setActorFlipX, setActorFlipY, setStrumlineY to lua modcharts
- [PR #582](https://github.com/KadeDev/Kade-Engine/pull/582): Add changeDadCharacter, changeBoyfriendCharacter, keyPressed to lua modcharts
- [PR #603](https://github.com/KadeDev/Kade-Engine/pull/603) and [PR #604](https://github.com/KadeDev/Kade-Engine/pull/604): Add note shifting to the chart editor
- [PR #672](https://github.com/KadeDev/Kade-Engine/pull/672): Add getWindowWidth, getWindowHeight to lua modcharts
- 💖 You can now fully customize your keybinds
- Added new animations for the main menu and options menu
- You can now place notes in the chart editor with 1-8 on your keyboard

### Changes
- Tutorial is now a modchart instead of being hardcoded
- [PR #332](https://github.com/KadeDev/Kade-Engine/pull/332): Move the beatbox in Fresh to the vocal track
- [PR #334](https://github.com/KadeDev/Kade-Engine/pull/334): Unhardcode GF Version, stages, and noteskins and make them loaded from chart
- [PR #291](https://github.com/KadeDev/Kade-Engine/pull/291): Make it so you can compile with 4.0.x
- 💖 [PR #440](https://github.com/KadeDev/Kade-Engine/pull/440): Change how replays work + store scroll speed and direction in replays
- [PR #480](https://github.com/KadeDev/Kade-Engine/pull/480): Alphabet now supports spaces, songs now use spaces instead of dashes internally
- (maybe 💖) [PR #504](https://github.com/KadeDev/Kade-Engine/pull/504): Opponent strumline now lights up when they hit a note, like the player's does
- 💖 [PR #519](https://github.com/KadeDev/Kade-Engine/pull/519): Now using the new recharts from Funkin v0.2.8
- [PR #528](https://github.com/KadeDev/Kade-Engine/pull/528): setCamZoom and setHudZoom now use floats in lua modcharts
- [PR #590](https://github.com/KadeDev/Kade-Engine/pull/590): The license is now automatically distributed with the game
- (maybe 💖) [PR #612](https://github.com/KadeDev/Kade-Engine/pull/612): BPM is now a float (can have decimals)
- The strumline in the chart editor now snaps to the time axis (toggle with Ctrl)
- Change the look of judgements (sick, good, bad, shit)

### Bugfixes
- [PR #289](https://github.com/KadeDev/Kade-Engine/pulls/289): Player 2 now plays idle animation properly when camera zooms in
- (maybe 💖) [PR #314](https://github.com/KadeDev/Kade-Engine/pulls/314): Fix note trails
- [PR #330](https://github.com/KadeDev/Kade-Engine/pull/330): Fix spelling errors in options
- [#329](https://github.com/KadeDev/Kade-Engine/issues/329) ([PR #341](https://github.com/KadeDev/Kade-Engine/pull/341)): Fix crash when changing characters in charting state on web
- [PR #341](https://github.com/KadeDev/Kade-Engine/pull/341): Fix html5 crash (when building), fix layering issues in charting state, fix charting state crashes in html5
- [PR #376](https://github.com/KadeDev/Kade-Engine/pull/376): Fix must hit sections
- [#368](https://github.com/KadeDev/Kade-Engine/issues/368) ([PR #392](https://github.com/KadeDev/Kade-Engine/pull/392)): Fix enemy idle animations not playing before first note
- [PR #399](https://github.com/KadeDev/Kade-Engine/pulls/399): Fix downscroll typo
- [PR #431](https://github.com/KadeDev/Kade-Engine/pull/431): Fix NPS counter
- [#404](https://github.com/KadeDev/Kade-Engine/issues/404) ([PR #446](https://github.com/KadeDev/Kade-Engine/pull/446)): Fix bug where Alt Animation in charting state doesn't stay checked after going to another section then back
- [PR #503](https://github.com/KadeDev/Kade-Engine/pull/503): Fix menu jittering
- [PR #600](https://github.com/KadeDev/Kade-Engine/pull/600): Fix bug where modcharts would break pausing
- [PR #638](https://github.com/KadeDev/Kade-Engine/pull/638): Fix bug with Girlfriend's dance in the tutorial
- [PR #678](https://github.com/KadeDev/Kade-Engine/pull/678): Fix opening URLs on Linux
- [PR #672](https://github.com/KadeDev/Kade-Engine/pull/672): Fix getScreenWidth and getScreenHeight in lua modcharts
- Fixed early hit window

# Changelog for 1.4.2 and before
Changelogs from before the current changelog system existed.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4.2]
### Changed
- Trails on notes are more consistent
- Title now shows "Friday Night Funkin' Kade Engine"
- **THIS UPDATE WILL RESET YOUR SAVE FOR KADE ENGINE**, so you gotta redo all of ur settings.

### Added
- Lua Modchart support [(documentation located here)](https://github.com/KadeDev/Kade-Engine/blob/master/ModCharts.md)
- New option called watermarks which removes all watermarks from Kade Engine
- Chart spesfic offsets

## [1.4.1]
### Fixed
- Rating's and Accuracy calculation (they actually work now)
- Deleting notes
### Added
- Accuracy mod toggle (complex = ms based, accurate = normal rating based. ex sick = 1, good = 0.75, bad = 0.50, shit = 0.25)
- Judgement Selector (safe frames)

## [1.4.1 Nightly2]
### Fixed
- Scroll Speed messing up hold note parts
- Added caps for Safe Frames (so you couldn't break the game)
### Changed
- Changed the fundamentals of how Ratings and other timing-related things like MS Acc are calculated.
- and of course. hit window update

## [1.4.1 Nightly1]
### Fixed
- Notes can be deleted
- Hit window updates
### Changed
- FPS Cap can now go faster or slower depending on whether you are holding shift or not.
### Added
- Safe Frames (the ability to change your hit windows)

## [1.4]
### Edited
- offsets work. fucking contributors
### Changed
- Updated Judgements to contrast better with each other.
- Changed Auto Offset to use the tutorial chart instead of a custom one
- The file in data called "freeplaySonglist.txt" is now fully used.
- Song Position now works a lot better