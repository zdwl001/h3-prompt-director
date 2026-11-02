# H3 Prompt Director

[简体中文](README.md) | English

Turn a story, novel, script, or character brief into a **single, ready-to-use shot plan and prompt delivery file for MiniMax H3 Ref2VA (R2V)**.

This is not one prompt. It is a complete workflow from narrative text to a production-ready deliverable: shot breakdown, duration budgeting, segment packing, consistency assets, six-section prompts, and QA. It targets a local ComfyUI Ref2VA workflow with `MiniMaxH3AddGuide` for cross-segment continuation.

> An independent workflow layer around MiniMax H3. Not an official project and not affiliated with MiniMax.

## What it adds

The official `h3-prompt-writing` skill covers **how to write one H3 prompt**: fields, labels, syntax, and reference relationships.

This skill covers the layer the official skill does not:

- How to break a multi-thousand-word story into shootable shots;
- How long each shot should be, and how to pack shots into 3.75–14.38 s generation segments;
- How to continue across segments with the last 22 frames and the matching tail audio;
- How to turn characters, locations, props, and voices into reusable assets;
- How to keep every segment's six-section prompt aligned with its connection list;
- What to check before delivery, and how to diagnose generation failures.

## Core features

| Feature | Description |
|---|---|
| Six-phase workflow | Story analysis → shot & duration budget → segment packing → consistency assets → prompt writing → QA & delivery |
| Dual channel | R2V reference slots (`<Subject N>` / `<Picture N>` / `<Video N>` / `<Audio N>`) are kept separate from the AddGuide guide channel; guide frames/clips never receive reference labels |
| Continuation mode B | Last 22 frames of the previous segment → AddGuide image (`frame_idx=0`) + same-source tail audio; trim the first 22 frames when stitching |
| Duration grid | 24 FPS, 17k+5 frames, 3.75–14.38 s; timestamps must match the overview table |
| Packing invariants | A shot never crosses segments; continuous dialogue never crosses segments; ≤9 images / 3 videos / 3 audio references per segment |
| Asset rules | Multi-view character sheets, 12-panel location grids, multi-form prop references, voice-timbre audio |
| QA & troubleshooting | Full checklist, symptom table, and cascading regeneration rules |

## Quick start

### 1. Install the skill

**Cherry Studio**

Copy the folder to `<CherryStudio Data>/Skills/h3-prompt-director/`. Cherry syncs the skill directory automatically.

**Claude Code / other agents**

```bash
# User level
cp -r h3-prompt-director ~/.claude/skills/

# Or project level
cp -r h3-prompt-director .claude/skills/
```

Any harness that can read a `SKILL.md` and local files can use it.

### 2. Fetch the official syntax documents

The three official documents are **not redistributed** in this repository (see [references/official/README.md](references/official/README.md)). Run:

```bash
bash scripts/fetch-official.sh
```

Windows PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/fetch-official.ps1
```

The script asks you to accept the MiniMax H3 Community License and downloads `official-skill.md`, `base-en.txt`, and `ref-en.txt` into `references/official/`. Those files are ignored by `.gitignore`.

### 3. Give it a story

```
Turn this story into H3 video prompts, following the h3-prompt-director workflow:

At dawn by the lake, the old fisherman Ahe pulls in his last net.
There is only a single dead leaf inside. He pauses, puts the leaf back
into the water, murmurs "Empty again," and rows away.
```

The skill produces **one Markdown file** containing:

1. Adaptation notes, global parameters, and a decision log;
2. Planning tables (characters, locations, shots, form changes, dialogue budget);
3. Overview table (segment, shot composition, grid duration, reference slots, guide source);
4. Asset table with image-generation prompts or user-provided markers;
5. Per-segment blocks (parameters, connection list, speaker map, six-section prompt, stitching notes);
6. Cross-segment QA conclusion.

See [`examples/`](examples/) for complete outputs.

## Output shape

Each segment uses six fixed sections:

```text
subject_definitions:
...

summary:
[reference generation] ...

retention_analysis:
<Subject 1> (appears in [Shot 1], [Shot 2]): fully_preserved - ...

detailed_description:
[Shot 1] ...
[Shot 2] At 00:03.500, ...

overall_soundscape:
...

non_diegetic_music:
...
```

## Repository layout

```
h3-prompt-director/
├── SKILL.md                     # Trigger description, workflow, invariants, file routing
├── references/
│   ├── 00-workflow.md           # Workflow, packing, delivery structure, QA checklist
│   ├── 01-grammar.md            # Ref2VA grammar, duration grid, node parameters
│   ├── 02-assets.md … 09-transition.md
│   ├── 10-troubleshooting.md
│   └── official/                # Official docs fetched at install time
├── assets/delivery-template.md  # Delivery file skeleton
├── scripts/                     # Fetch scripts (bash / PowerShell)
└── examples/                    # Complete example deliverables
```

## Compatibility

- No MiniMax Hub, external API, or online knowledge base required;
- Only local file read/write tools are needed;
- Works in Cherry Studio, Claude Code, Claude Agent SDK, Cursor, Windsurf, or any harness that reads `SKILL.md`;
- Generation runs in a local ComfyUI Ref2VA workflow with `MiniMaxH3AddGuide`; the skill only produces the prompt text.

## Official documents and licensing

- Official repository: https://github.com/MiniMax-AI/MiniMax-H3
- Official documents are governed by the **MiniMax H3 Community License Agreement**: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE
- The license grants rights only within the Applicable Territory (worldwide excluding the European Union, the United Kingdom, the Republic of Korea, and the United States of America) and imposes conditions on redistribution. This repository therefore does not bundle the official documents; they are fetched from the official repository at install time.
- The MIT license of this repository **does not cover** the official documents.

## License

Original content in this repository (`SKILL.md`, `references/00`–`10`, `assets/`, `scripts/`, `examples/`, and documentation) is released under the [MIT License](LICENSE).

Third-party materials and trademarks remain the property of their respective owners. See [NOTICE](NOTICE).

## Contributing

Issues and PRs are welcome. Keep the files under `references/` textually stable; when a rule needs clarification, prefer adding it to the "common pitfalls" section of `SKILL.md` or to `references/README.md` rather than rewriting the source. New examples must not contain personal paths, project names, or secrets.

## Disclaimer

- This project is not affiliated with, endorsed by, or sponsored by MiniMax.
- ComfyUI wiring, model selection, generation parameters, and final output quality are the user's responsibility.
- Use of generated content must comply with local law, platform rules, and the MiniMax H3 Community License Agreement.
