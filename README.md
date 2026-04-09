# AI Creator Kit

**One folder. One brand. Every content format.**

An AI content studio that builds your brand from scratch, then creates newsletters, carousels, LinkedIn posts, and short-form video scripts — all in your voice, all from one place.

---

## Set up in one prompt

Paste this into Claude Code and hit enter:

```
Download and run https://raw.githubusercontent.com/anurieli/ai-creator-kit/main/setup.sh to set up my content creation workspace, then start the onboarding.
```

That's it. Claude downloads the kit, sets it up on your machine, and walks you through building your brand. No git, no terminal commands, no configuration.

**Don't have Claude Code yet?** Get it at [claude.ai/download](https://claude.ai/download) or [docs.anthropic.com/claude-code](https://docs.anthropic.com/en/docs/claude-code).

---

## What this is

A folder on your computer that contains everything an AI needs to create content as you. Your brand identity, your writing voice, your visual style, your inspiration sources — captured once, used everywhere.

No coding. No APIs. No databases. No build steps. Just a conversation with Claude.

---

## What you get

**Your brand (built once, used everywhere):**
- Brand document — who you are, who you serve, what you stand for
- Voice guide — how you sound across all mediums
- Visual identity — what your brand looks like

**Four content engines:**

| Engine | What it creates |
|--------|----------------|
| **Newsletter** | Long-form newsletters with research, drafting, and your voice |
| **Carousel** | Slide-by-slide posts with copy + design direction for Instagram/LinkedIn |
| **LinkedIn** | Algorithm-aware posts with hooks, rehooks, and AI-detection defense |
| **Shortform** | Ready-to-film scripts with timestamps, visual cues, and filming guides |

**Each engine includes:**
- Medium-specific style profile (derived from your brand)
- Templates for every content format
- An inspiration folder for examples you like
- Draft and published output folders
- Batch creation for a week of content at once

---

## Getting started

### 1. Install Claude

You need Claude Code, the Claude desktop app, or access to claude.ai. Any of them work. Claude Code gives you the best experience.

- **Claude Code (CLI):** [docs.anthropic.com/claude-code](https://docs.anthropic.com/en/docs/claude-code)
- **Claude Desktop App:** [claude.ai/download](https://claude.ai/download)

### 2. Open this folder

Point Claude at this folder. In Claude Code, just `cd` into it. In the desktop app, open it as a project.

### 3. Say anything

Claude will detect that you're new and walk you through brand setup. After that, you tell it what you want to create and it handles the rest.

That's it. See **HOW-TO-USE.md** for the full usage guide.

---

## How it works

```
You open the folder
        |
        v
Claude checks: do you have a brand?
        |
   No --+--> Brand setup (20-30 min, one time)
        |
   Yes -+--> What do you want to create?
        |
        +---> "Write a newsletter" ---> Is newsletter set up? 
        |                                  No --> Quick setup (5-10 min)
        |                                  Yes --> Writes the newsletter
        |
        +---> "Make a carousel" -------> Is carousel set up?
        |                                  No --> Quick setup (5-10 min)
        |                                  Yes --> Creates the carousel
        |
        +---> "Write a LinkedIn post" -> Is LinkedIn set up?
        |                                  No --> Quick setup (5-10 min)
        |                                  Yes --> Writes the post
        |
        +---> "Write a script" --------> Is shortform set up?
                                           No --> Quick setup (5-10 min)
                                           Yes --> Writes the script
```

**Brand setup** happens once. It produces three documents that every content engine reads from.

**Kit setup** happens once per engine, the first time you use it. It's fast because your brand already exists — Claude just needs to tune your voice for that specific medium.

**After setup**, you just talk. "Write a newsletter about X." "Give me 5 LinkedIn posts for the week." "Make a carousel about Y." Claude reads your files and creates.

---

## Your files at a glance

```
ai-creator-kit/
├── brand/                    Your brand identity (source of truth)
│   └── identity/
│       ├── brand-document.md
│       ├── voice-guide.md
│       └── visual-identity.md
│
├── kits/
│   ├── newsletter/           Newsletter engine
│   ├── carousel/             Carousel engine
│   ├── linkedin/             LinkedIn engine
│   └── shortform/            Short-form video engine
│
├── sources.yaml              Your inspiration sources
├── README.md                 You're reading this
└── HOW-TO-USE.md             Detailed usage guide
```

---

## Evolving your brand

Your brand isn't static. Come back anytime and say:

- "I want to sound more concise and punchy"
- "My audience is shifting toward experienced founders"
- "I love how @creator writes — give me some of that energy"
- "Update my brand colors"

Claude shows you the before and after, you approve, and every content engine picks up the change automatically.

---

## FAQ

**Do I need to set up all four engines?**
No. Set up only the ones you use. Each engine activates the first time you ask for that content type.

**What if I already have a brand?**
Drop your brand docs, writing samples, and visual references into the `brand/identity/` subfolders. Claude will analyze them instead of interviewing you from scratch.

**Can I use this for clients?**
Yes. One kit per person or brand. Duplicate the folder and start fresh.

**What if my voice changes over time?**
Push back on drafts. Every correction trains the system. You can also say "refresh my LinkedIn style" to re-derive your kit profile from your updated brand.

**Can I use this from my phone?**
Yes, with limitations. On claude.ai, create a project and paste in your brand documents. You won't have all the features, but it works for quick drafts.
