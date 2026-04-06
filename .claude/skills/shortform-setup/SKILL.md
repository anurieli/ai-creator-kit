# /shortform-setup

Derive an 8-dimension on-camera persona profile from the central brand identity. Video is a spoken, visual medium — this produces a persona profile, not a writing style profile.

## Trigger

Activate when `kits/shortform/identity/persona-profile.md` is missing or empty and the user wants to create a video script.

## Prerequisites

`brand/identity/brand-document.md` and `brand/identity/voice-guide.md` must exist. If missing, route to `/brand setup` first.

## Process

### Step 1 — Read the Brand

Read central brand documents. Summarize:
> "I know your brand — [summary]. Now I need to capture how you come across on camera. This is different from writing — it's about your energy, your delivery, your on-screen personality."

### Step 2 — Three Input Modes

Ask what they have:

**Mode A: Existing Videos (best)**
> "Do you have any existing videos? Links to TikToks, Reels, or Shorts? Or even transcripts? 3-5 videos is ideal."

Analyze all 8 dimensions. Ask about visual elements not captured in transcripts.

**Mode B: Creator Emulation**
> "Is there a creator whose on-camera style you want to be inspired by? I can study their approach and build your persona from that, then we'll adjust it to make it yours."

Process: Research creator → build baseline persona → interview for differences → result is "inspired by," never a clone.

**Mode C: Interview (when they have nothing)**
> "No videos yet? That's fine. I'll ask you some questions about how you'd show up on camera. We can also pick a creator you admire as a starting point.
>
> Fair warning: the persona will be more accurate once you've filmed a few things and I can study the real you. But this gets us started."

Also check `brand/identity/writing-samples/` — written voice gives clues about spoken voice.

### Step 3 — Build 8-Dimension Persona Profile

1. **Energy & Pace** — high/low energy, fast/slow talker, intense vs chill, how they use pauses
2. **Hook Style** — how they open (direct claim, "you" statement, mid-story, question, pattern interrupt). Speed of hook (under 1 second? 3 seconds?)
3. **Speaking Voice & Language** — vocabulary on camera, slang, catchphrases, filler words they use or avoid, sentence complexity when speaking
4. **Humor & Personality** — dry, sarcastic, goofy, none? Do they use irony? Self-deprecation? Pop culture references?
5. **Visual Presentation** — talking head vs B-roll heavy, text overlays, camera angles, background style, props
6. **Structure & Pacing** — how they build a video (linear, loop, reveal), pattern interrupts, retention hooks, pacing changes
7. **Authority & Relatability** — expert teaching down vs peer sharing, vulnerability level, how they establish credibility
8. **CTA & Closing Patterns** — how they end (direct CTA, soft ask, open question, cliffhanger), follow button prompt style

### Step 4 — Platform & Config

Ask:
- Which platforms? (TikTok, Reels, Shorts, all)
- Niche
- Posting frequency
- Preferred video length (15s, 30s, 60s, 90s)

### Step 5 — Inspiration

> "What video creators do you watch and think 'I want to make content like that'?"

Note: Video references are harder to analyze than text. For now, focus on best practices and trend research. Say: "Video inspiration analysis is expanding soon — for now I'll note your references and use your playbook of platform best practices."

Save to `kits/shortform/inspirations/` and `sources.yaml` under `video_creators`.

### Step 6 — Save and Confirm

Save to `kits/shortform/identity/persona-profile.md`:

```markdown
---
version: 1
created: YYYY-MM-DD
last_updated: YYYY-MM-DD
medium: shortform-video
derived_from_brand_version: [version]
input_mode: [videos/emulation/interview]
confidence: [high/medium/low]
---

# On-Camera Persona Profile

## Persona DNA — Quick Reference
[3-5 bullet summary of how they show up on camera]

## Energy & Pace
[analysis]

## Hook Style
[analysis]

## Speaking Voice & Language
[analysis]

## Humor & Personality
[analysis]

## Visual Presentation
[analysis]

## Structure & Pacing
[analysis]

## Authority & Relatability
[analysis]

## CTA & Closing Patterns
[analysis]

## Do
- [On-camera pattern] — *Example: "[how they'd say it]"*

## Don't
- [Anti-pattern] — *Instead: "[their version]"*
```

Present for approval. Then: "Your on-camera persona is set up. What's your first video about?"

## Output
- `kits/shortform/identity/persona-profile.md`
