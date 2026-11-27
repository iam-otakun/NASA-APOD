# Changelog / 更新日志

## v2.0.1 — 2026-11-27

- **Silent launch (macOS) / 静默启动（macOS）**: starting the app — manually or as a login item — now only puts the icon in the menu bar; the Settings window no longer opens on launch. It still appears from the menu, by reopening the running app, or when a duplicate launch asks the running instance to show itself. Behavior requested by Fred. / 手动打开或由登录项拉起，都只进菜单栏，不再自动弹设置窗；设置窗仍可从菜单打开，在程序运行时再次打开程序也会显示，重复启动时已运行的实例照旧应请求显示。此行为由 Fred 提出。
- **Windows edition / Windows 版**: version number bumped in step only; no functional change. / 仅同步版本号，无功能变化。

## v2.0.0 — 2026-11-27

- **One repository for both editions / 两端合并为一个仓库**: the macOS and Windows editions now live in this single repository (`macOS/`, `Windows/`), share one version number, and ship in the same release — the macOS `.pkg` and the Windows `.zip` side by side; each app's updater points here and downloads only its own asset. Pre-2.0 history stays in the archived `NASA-Apod-for-Mac` and `nasa-apod-windows` repositories. / macOS 与 Windows 两端自本版起同住一个仓库（`macOS/`、`Windows/`），共用一个版本号、同一个 Release 发布——macOS 的 `.pkg` 与 Windows 的 `.zip` 并列；两端更新器都改指本仓库，只下自己那份资产。2.0 之前的历史留在已归档的 `NASA-Apod-for-Mac` 与 `nasa-apod-windows` 仓库。
- **Bug fix — duplicate instances at login (macOS) / 修复 bug——登录时重复启动（macOS）**: copies of the app kept at different paths over time could each register a login item, so macOS sometimes launched two or more instances at login; every extra instance opened its own Settings window, and the copies disagreed with each other about settings such as Launch at login. The macOS edition now enforces a single instance: a duplicate launch hands over to the instance already running and exits (silently, when the duplicate came from a login item). Duplicate entries already accumulated in System Settings → General → Login Items still need a one-time manual removal there. Found by Fred. / 散落在不同路径的旧副本各自注册过登录项，macOS 登录时可能一次拉起两个以上实例，每个多余实例都弹自己的 Settings 窗，副本之间连「登录时启动」这类设置都互相矛盾。现在 macOS 版强制单实例：重复启动会把焦点交给已在运行的实例并退出（若重复来自登录项则静默退出）。系统设置 → 通用 → 登录项里已攒下的重复条目，仍需在那边手动清一次。此 bug 由 Fred 发现。
