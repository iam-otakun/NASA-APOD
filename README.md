# NASA-APOD

Fetches NASA's Astronomy Picture of the Day every day on macOS and Windows: saves the original image (or the video / its first frame on video days) plus the explanation as a same-name `.txt`, and can set the picture as wallpaper. Both editions update themselves from this repository's releases.

在 macOS 与 Windows 上每天抓取 NASA「每日一天文图」：保存原图（视频日保存视频本体或其第一帧），并把说明存为同名 `.txt`，还可一键设为壁纸。两端都从本仓库的 Release 自行更新。

## Editions / 版本

- `macOS/` — Swift menu-bar app (Xcode project, `build.sh` builds an ad-hoc signed Release app; releases ship a `.pkg` installer)
- `Windows/` — single-file C# tray app (`NasaApod.cs`, built by `build.cmd` with the in-box .NET Framework compiler; releases ship a `.zip` containing `NasaApod.exe` and its `.config`)

Both editions share one version number. Every release carries both platforms' assets; each app downloads only its own.

两端共用一个版本号。每个 Release 同时带两个平台的资产，各端只下载自己那份。

## History / 沿革

Versions before 2.0.0 were published from the per-platform repositories `NASA-Apod-for-Mac` and `nasa-apod-windows` (now archived). The two editions were merged into this single repository at v2.0.0.

2.0.0 之前的版本发布在按平台分开的仓库 `NASA-Apod-for-Mac` 与 `nasa-apod-windows`（已归档）。自 v2.0.0 起两端合并到本仓库。

Idea: Otakun · Coding: Dash
