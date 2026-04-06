# /newsletter-setup

Derive a newsletter-specific writing style profile from the central brand identity. The brand already exists — this tunes it for long-form newsletter writing.

## Trigger

Activate when the master CLAUDE.md routes here because `kits/newsletter/identity/style-profile.md` is missing or empty.

## Prerequisites

`brand/identity/brand-document.md` and `brand/identity/voice-guide.md` must exist and be non-empty. If missing, tell the user to run `/brand setup` first.

## Process

### Step 1 — Read the Brand

Read all three central brand documents. Summarize back:
> "I already know your brand — [1-2 sentence summary]. Now I need to tune your voice specifically for newsletter writing. This takes about 5-10 minutes."

### Step 2 — Gather Writing Samples

Check `brand/identity/writing-samples/` and `kits/newsletter/inspirations/writing-samples/`.

- **3+ samples exist:** Analyze them for the 7 dimensions below.
- **Fewer than 3:** "I have [N] sample(s). The profile will be stronger with 5-10 pieces of your writing — newsletters, blog posts, emails, anything long-form. Want to add more, or should I interview you instead?"
- **Zero, they insist:** Interview mode. Note low confidence in the profile.

### Step 3 — Build 7-Dimension Style Profile

Analyze writing across:
1. **Sentence Architecture** — long/short, simple/complex, fragments
2. **Vocabulary & Language** — formal/casual, jargon level, signature phrases
3. **Tone & Register** — serious/playful, warm/cool, conversational level
4. **Rhetorical Patterns** — storytelling, questions, analogies, lists, direct claims
5. **Perspective & POV** — first/second/third person, hedging vs directness
6. **Rhythm & Pacing** — cadence, paragraph length, repetition, flow
7. **Personality Markers** — humor, cultural references, emoji, exclamations, quirks

Delegate analysis to a sub-agent. Present results to user.

### Step 4 — Newsletter Specifics

Ask:
- Newsletter name
- Target audience (may differ from brand audience)
- Publishing frequency
- Typical format (deep dive, curated, weekly roundup, essays)
- Preferred length

### Step 5 — Inspiration Sources

> "Any newsletters or long-form writers you admire?"

Add to `sources.yaml`. Save any named references to `kits/newsletter/inspirations/creator-references/`.

### Step 6 — Save and Confirm

Save to `kits/newsletter/identity/style-profile.md`:

```markdown
---
version: 1
created: YYYY-MM-DD
last_updated: YYYY-MM-DD
medium: newsletter
derived_from_brand_version: [version from brand-document.md]
---

# Newsletter Style Profile

## Voice DNA — Quick Reference
[3-5 bullet summary]

## Sentence Architecture
[analysis]

## Vocabulary & Language
[analysis]

## Tone & Register
[analysis]

## Rhetorical Patterns
[analysis]

## Perspective & Point of View
[analysis]

## Rhythm & Pacing
[analysis]

## Personality Markers
[analysis]

## Do
- [Pattern] — *Example: "[their actual words]"*

## Don't
- [Anti-pattern] — *Instead: "[their version]"*
```

Present to user for approval. Then: "Your newsletter voice is set up. Now let's write that newsletter — what's the topic?"

## Output
- `kits/newsletter/identity/style-profile.md`
