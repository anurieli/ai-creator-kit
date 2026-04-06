# Script Skill

Write a complete short-form video script that sounds like the client on camera. Includes hooks, timestamps, visual direction, text overlays, and a filming guide.

## Trigger

Activate when the user says `/script` or asks to write, draft, or create a video script.

## Important — Communication Style

The client is not technical. All communication must be warm, clear, and in plain language. Never show YAML, file paths, or system internals unless asked.

## Entry Points

1. **Topic-driven** — "/script 'topic: why most morning routines fail'"
2. **Format-driven** — "/script 'format: myth-bust, topic: passive income'"
3. **Creator-inspired** — "/script 'in the style of how Hormozi does listicles'"
4. **Trend-driven** — "/script 'use the trending [format]'"
5. **Platform-specific** — "/script 'youtube short about...'"
6. **Auto-suggest** — No input → research + propose 3 concepts with format recommendations
7. **Conversational** — Natural language

---

## Phase 1: Concept & Context Loading

### 1a. Load project context

Read these files:
- `identity/brand-profile.md` — brand, audience, content pillars, platform, CTA strategy
- `identity/persona-profile.md` — 8-dimension on-camera persona
- `creators.yaml` — inspiration creators and format trends
- `content/my-content/config.yaml` — platform, niche, frequency, preferred length

**Hard stop** if brand or persona profiles are missing:

> "Before we script, I need your brand and on-camera persona on file. Let's run setup first."

### 1b. Determine platform and template

- Platform from config.yaml or user input
- Template: user-specified or recommended based on topic type
- Check `content/my-content/playbook.md` for current trends and best practices

### 1c. Confirm

> "Here's what I'm thinking: a [template] about [topic], [duration] for [platform]. Sound good?"

Wait for confirmation.

---

## Phase 2: Hook Development (THE critical phase)

The hook IS the video. If the first 1-3 seconds don't stop the scroll, nothing else matters.

Generate **5 hook options**, each under 3 seconds spoken (~10 words max), all in the client's persona voice:

1. **Bold claim** — a strong, specific statement
2. **"You" accusation** — makes it about the viewer
3. **Question** — provokes thought or curiosity
4. **Mid-story start** — drops into action
5. **Pattern interrupt** — unexpected framing

For each hook:
- The spoken words
- Suggested text overlay
- Brief note on why it works

> "Here are 5 ways to open this video. Pick one, or tell me what direction to go."

**Wait for selection.** Never auto-pick.

---

## Phase 3: Full Script Drafting

Write the complete script using the selected hook + template structure. **Every section must include:**

```
[TIMESTAMP: 0:00-0:03]
[VISUAL: Talking head, close-up, eye contact with camera]
[TEXT ON SCREEN: "Stop doing THIS" in bold]
[TONE: High energy, slight frustration]

"Stop wasting your mornings on routines that don't actually work."

---

[TIMESTAMP: 0:03-0:08]
[VISUAL: Medium shot, slight lean forward]
[TEXT ON SCREEN: None]
[TONE: Conversational, pulling viewer in]

"I tried every morning routine out there. The 5am club. Cold plunges. Journaling for an hour. None of it moved the needle."
```

**Requirements:**
- Every section: timestamp, visual direction, text overlay cues, tone/energy direction, spoken words in quotes
- Pattern interrupt markers where needed (camera change, text overlay, energy shift)
- Word count check: ~2.5 words/second (150 words/minute)
- End with: total word count, estimated duration, platform target

---

## Phase 4: Self-Edit (Highly Opinionated)

### Persona check (against persona-profile.md)
- Sounds like them speaking? Energy, vocabulary, humor match?
- Script Rules (Do/Don't) from persona profile honored?

### Brand alignment (against brand-profile.md)
- Content pillar served? Niche appropriate? CTA matches strategy?

### Retention check
- **1-second rule:** First FRAME stops the scroll?
- **3-second gate:** Hook creates reason to stay by second 3?
- **7-second cliff:** Something CHANGES at 7-8 seconds?
- **Pattern interrupts** every 8-12 seconds?
- **Ending** pays off the hook's promise?

### Speakability check
- Any tongue-twisters? Read every line aloud mentally.
- Sentences short enough to deliver in one breath?
- Natural transitions between sections?
- No filler phrases ("so basically," "um," "like I said")

### Timing check
- Word count matches target duration? (~2.5 words/sec)
- No section runs too long without a visual change?

### Platform check
- Length appropriate for the platform?
- Text overlay density right?
- Safe zones respected (avoid bottom 20%, top 15%)?

Revise as needed. First draft is never final.

---

## Phase 5: Filming Guide

Generate a companion guide:

### Setup Notes
- Camera: framing, angle, distance
- Lighting: natural/ring/studio recommendation
- Audio: mic recommendation, room notes
- Background: what should be visible

### Shot List
| Timestamp | Shot | Description |
|-----------|------|-------------|
| 0:00-0:03 | Close-up | Eye contact, high energy |
| 0:03-0:08 | Medium | Lean forward, conversational |
| ... | ... | ... |

### Text Overlay Specs
| Timestamp | Text | Style | Position |
|-----------|------|-------|----------|
| 0:00-0:03 | "Stop doing THIS" | Bold, large | Center |
| ... | ... | ... | ... |

### Editing Notes
- Cut style, pace, music/sound vibe
- Transitions between sections
- Caption style and timing

### Posting Notes
- Best posting time for platform
- Suggested hashtags (3-5)
- Caption text for the post
- CTA from brand profile

---

## Phase 6: Deliver

Save to `content/my-content/scripts/drafts/YYYY-MM-DD-[slug].md` with frontmatter:

```markdown
---
date: "YYYY-MM-DD"
topic: "topic"
platform: "tiktok/reels/shorts"
template: "template-name"
duration: "estimated seconds"
word_count: X
hook_type: "bold-claim/you/question/mid-story/interrupt"
status: "draft"
---
```

Present warmly:

> "Here's your script! [duration] [format] for [platform]. Hook: '[hook text]'. Take a look."

---

## Phase 7: Platform Adaptation

If the client posts on multiple platforms, generate delta notes:

- **TikTok:** More casual tone, trending sound suggestion, heavier text overlays
- **Reels:** Slightly more polished, use Instagram's native music, adjust caption safe zones
- **Shorts:** More educational framing, lighter text, longer shelf life so optimize for evergreen

---

## Guiding Principle

The script should sound like the client grabbed their phone and filmed it on a great content day. The persona profile is the contract. Every line should pass the test: "Would they actually say this on camera?"
