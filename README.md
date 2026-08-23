# Single HTML Export

Export an Obsidian note as **one self-contained HTML file** — no CDN, no asset folder, no internet. Images are inlined as data URIs, Mermaid diagrams are baked to static SVG, and code blocks keep their syntax highlighting.

**It works on mobile.** Every other HTML exporter for Obsidian is desktop-only; this one is built around the phone case, where "show this to someone right now" actually happens.

*[한국어 문서](README.ko.md)*

## How it works

Running the command renders the note, then opens a preview popup:

```
Menu → generate HTML → preview popup → (your choice) share / save
```

**No file is written until you pick an action.** Close the popup and nothing is left behind — you can use the preview just to check how a note renders.

### The buttons depend on what your device can actually do

| Environment | Button |
|---|---|
| iOS | **Share** — hands the in-memory file to the native share sheet. Nothing touches your vault |
| Android | **Save to shared folder** — writes to `Download/Obsidian HTML/` and copies the path |
| Desktop | **Save…** → then **Show in Finder / Show in folder** |

This is decided by capability, not by an OS list: the plugin asks whether a share sheet exists, whether it is a desktop app, whether a shared folder is writable. If sharing works, the shared-folder button is hidden — and if sharing then fails, it reappears so you are never stuck.

> **Why can't Android open the share sheet?** Android's WebView does not implement the Web Share API, and the Obsidian Android app does not expose a Capacitor `Share` bridge either. A plugin cannot create a capability the host app doesn't hand it, so on Android the file is dropped into a folder your file manager can see.

## What ends up in the file

- **Images** — inlined as base64 data URIs (both `![[wikilink]]` and standard Markdown embeds; NFC/NFD filename normalization so non-Latin filenames resolve)
- **Mermaid** — rendered at export time into static `<svg>`; nothing runs in the exported page
- **Syntax highlighting** — Obsidian's own Prism tokens with an inlined color palette
- **Callouts, wikilink chips, task lists, highlights, tables** — styled to match
- **Frontmatter** — shown as a chip bar (type / status / confidence / topics / tags)
- **Dark mode toggle and per-block copy buttons** — only appear if scripts actually run (see below)
- **Fonts** — not embedded. Uses `local()` plus a system stack, because embedding CJK webfonts costs 1–2 MB per document and these files exist to be shared

### The controls appear only where they work

Some viewers (the iOS Files preview, most Android "HTML viewer" apps) don't run JavaScript. The theme toggle and copy buttons are hidden by default and revealed only when a script has run, so you never see a button that does nothing. Open the same file in a browser and everything works.

## Commands

| Command | What it does |
|---|---|
| **Export to single HTML** | The main command. Also in the file-explorer, tab, and editor context menus |
| **Diagnose export options** | Reports what this device offers (share API, Capacitor bridges). Useful when a button you expected is missing |
| **Clean up exported HTML in the vault** | Moves HTML files this plugin previously wrote into the vault into `.trash`. Identified by their `<meta name="generator">`, so other `.html` files are left alone |

## Language

The UI follows your Obsidian language setting — English by default, Korean when Obsidian is set to Korean. The exported document is labelled in the language you exported it in.

## Installation

Not in the community plugin directory yet. Install with [BRAT](https://github.com/TfTHacker/obsidian42-brat) using this repository, or copy `main.js`, `manifest.json`, and `styles.css` into `<vault>/.obsidian/plugins/single-html-export/`.

## Notes for reviewers / contributors

- **Undocumented API**: Android support reads `window.Capacitor.Plugins.Filesystem`. There is no documented Obsidian API for writing outside the vault on mobile, and without it the Android path has no way to hand a file to the user. It is feature-detected everywhere and the plugin degrades to preview-only if the bridge is absent.
- **Electron**: `window.require('electron')` is used only behind `Platform.isDesktopApp`, for the save dialog and "show in folder".
- Source comments are in Korean — they record *why* each constraint exists, and most of them are scars from a real bug. Design decisions live in the author's notes; the README summarizes the conclusions.

## Credits

The exported file bundles no runtime dependencies, but its look and its icons come from other people's work. These notices are also embedded as a comment in every exported HTML file, because that file travels on its own.

| Project | License | Used for |
|---|---|---|
| [Lucide](https://lucide.dev) | ISC | The inline SVG icons (theme toggle, copy). © Lucide Icons and Contributors; Feather-derived parts © Cole Bemis (MIT) |
| [jelly-ui](https://jelly-ui.com) | MIT | The design tokens and component vocabulary the exported page follows |
| [Pretendard](https://github.com/orioncactus/pretendard) | OFL 1.1 | Referenced by name in the font stack via `local()` — **not embedded**, so the file stays small and falls back to system fonts |

Syntax highlighting reuses the Prism token classes Obsidian already emits, and Mermaid diagrams are rendered by Obsidian's own engine before being baked to SVG — neither library is bundled by this plugin.

## License

MIT © DDEOK
