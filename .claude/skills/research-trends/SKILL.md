# Skill: research-trends

Research currently trending formats, hooks, and patterns in the client's niche and platform. Updates the playbook with fresh intelligence.

## Trigger

Activate when the user says:
- "What's trending?"
- "Research current trends"
- "/research-trends"
- Or when `content/my-content/playbook.md` hasn't been updated in 2+ weeks

## Process

### Step 1 — Load context

Read:
- `identity/brand-profile.md` — for niche and platform
- `creators.yaml` — for creators to research
- `content/my-content/playbook.md` — for existing trend notes

### Step 2 — Research

Use web search to find:
- **Trending formats** on the client's primary platform(s)
- **What tracked creators are posting** — recent content from creators in `creators.yaml`
- **Viral patterns in the client's niche** — what's getting traction right now
- **Trending sounds/audio** — described textually (trending song names, audio meme descriptions)
- **Format structures** that are performing well

### Step 3 — Update playbook

Append to `content/my-content/playbook.md` under dated sections:

```markdown
## Trend Update — YYYY-MM-DD

### Currently Trending Formats
- [format description with example]

### Trending in [User's Niche]
- [niche-specific trends]

### Creator Watch
- [Creator Name]: [what they're doing differently this week]

### Sound/Audio Trends
- [described textually — song name, audio meme, voice effect]

### Format Ideas for You
- [mapped to templates: "This trending format maps well to your myth-bust template"]
```

### Step 4 — Update creators.yaml

Add any new trends to the `format_trends` section.

### Step 5 — Present summary

Conversational summary of what's working right now:

> "Here's what I found trending in your niche this week: [summary]. A few format ideas that could work well for you: [ideas mapped to templates]."

## Rules

- **Trends are inspiration, not mandates.** The client's persona and brand always come first.
- **Describe audio trends textually.** We can't play sounds, but we can describe them.
- **Date everything.** Trends expire fast. Always timestamp.
- **Map to templates.** Don't just report trends — suggest how the client could use them with their existing templates.
