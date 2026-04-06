# Skill: /carousel

Create a single carousel post with slide-by-slide copy and design direction, matched to the client's brand identity and visual style.

---

## Trigger

User says things like:
- "Make a carousel about X"
- "Create a carousel on X"
- "Carousel about X"
- "I want to make a carousel"

---

## Prerequisites

Before starting, verify:
1. `identity/brand-profile.md` exists and is non-empty (MUST include Design System section)
2. `identity/style-profile.md` exists and is non-empty
3. If either is missing, redirect to onboarding — do not proceed without a design system

---

## Entry Points

The skill supports multiple entry points:

1. **Topic provided** — "Make a carousel about hiring mistakes" → Start at Phase 1
2. **Template specified** — "Make a step-by-step carousel about X" → Lock template, start at Phase 1
3. **Story provided** — "I have this story about..." → Route to storytelling template
4. **Platform specified** — "Make an Instagram carousel about X" → Lock platform, start at Phase 1
5. **Pillar specified** — "Make a carousel for my [pillar] content" → Filter topic to pillar
6. **Auto-suggest** — "What should my next carousel be about?" → Check post-history.yaml and pillars.yaml, suggest 3 topics with template recommendations

---

## Execution

### Phase 1 — Context & Strategy Loading

**Do this silently — do not narrate to the client.**

1. Read `identity/brand-profile.md` — extract Design System (colors, fonts, layouts, visual elements), messaging pillars, audience, brand voice
2. Read `identity/style-profile.md` — extract copy voice, visual style preferences, headline patterns, CTA style
3. Read `content-strategy/pillars.yaml` — check pillar balance
4. Read `content-strategy/post-history.yaml` — check recent carousels for variety (no repeat templates, no repeat pillars back-to-back)
5. Read `sources.yaml` — note relevant sources for research
6. Read `identity/design-references/` — if any reference images exist, note visual patterns

Based on the topic:
- Select the best-fit template (or confirm if one was specified)
- Identify the target platform (or ask if not clear)
- Determine optimal slide count for the topic and template
- Plan the visual approach (which brand colors to emphasize, layout variation pattern)

Present to client:
> "Here's what I'm thinking for this carousel:
> - **Format:** [template name] — [why it fits]
> - **Platform:** [platform] ([dimensions])
> - **Slides:** [count]
> - **Angle:** [the specific angle/perspective]
>
> Want me to go with this, or would you prefer a different approach?"

Wait for confirmation.

### Phase 2 — Cover Slide Development

Generate 5 cover slide options. The cover slide is the scroll-stopper — it must grab attention in under 2 seconds.

Each option should include:
- **Headline** (max 8-10 words — must be readable at small size)
- **Visual approach** (layout, color emphasis, visual element)
- **Why it works** (one line — the psychology behind it)

**Cover slide types to generate:**
1. **Bold claim** — A statement so strong people have to swipe
2. **Number-driven** — "7 things...", "The 3 mistakes..."
3. **Curiosity gap** — Opens a loop that demands swiping to close
4. **Question** — Challenges the reader's assumptions
5. **Pattern interrupt** — Unexpected visual or textual approach

Present all 5 to the client. **WAIT for them to choose before continuing.**

### Phase 3 — Full Carousel Draft

Using the chosen cover slide and template, draft every slide.

**Each slide must include:**

```
## Slide [N] — [Section Name]

**Headline:** [Main text — large, attention-grabbing]
**Body:** [Supporting text — if applicable, 1-3 lines max]

**Design Direction:**
- **Layout:** [Text placement, alignment, visual hierarchy]
- **Background:** [Color hex from brand palette]
- **Text color:** [Color hex from brand palette]
- **Font:** [Heading: family/size/weight | Body: family/size/weight]
- **Visual elements:** [Icons, images, dividers, shapes, patterns]
- **Spacing:** [Key spacing notes]

**Notes:** [Why this slide works, energy/tone, transition from previous]
```

**Structural rules:**
- Cover slide: ONE idea, max 10 words, must work as a standalone image
- Body slides: ONE idea per slide, headline + optional short body
- CTA slide: ONE clear action, make it easy
- Visual rhythm: vary layouts across slides (don't repeat the same layout consecutively)
- Design consistency: same color palette, same font families, consistent spacing
- Swipe motivation: every slide should make you want to see the next one
- Text density: less is more — if it doesn't fit at a glance, cut it

**Word count targets by slide:**
- Cover: 3-10 words
- Body slides: 10-40 words each
- CTA slide: 5-20 words

### Phase 4 — Self-Edit

Before showing the client, run these checks:

**Brand Check:**
- [ ] Colors match the design system exactly (hex codes)
- [ ] Fonts match the brand typography
- [ ] Layout patterns feel consistent with the brand's visual identity
- [ ] Visual elements (corners, shadows, dividers) match brand style
- [ ] Overall aesthetic matches the design references

**Copy Check:**
- [ ] Does the copy sound like the client? Check against style profile
- [ ] Is the content on-brand? Check against messaging pillars
- [ ] Is each headline clear and punchy?
- [ ] One idea per slide — no exceptions
- [ ] CTA is specific and actionable

**Carousel Check:**
- [ ] Cover slide grabs attention in under 2 seconds
- [ ] Every slide motivates a swipe to the next
- [ ] Visual rhythm varies (not every slide looks the same)
- [ ] Slide count is appropriate for the content
- [ ] Last slide has a clear, single CTA
- [ ] Text is readable at mobile size (not too small, not too dense)

**Platform Check:**
- [ ] Dimensions noted (Instagram: 1080x1350 or 1080x1080 | LinkedIn: 1080x1080)
- [ ] Text safe zones respected (no text in top/bottom 10% for Instagram)
- [ ] Swipe indicator noted for cover slide if Instagram

Fix any issues before presenting.

### Phase 5 — Deliver

Present the carousel to the client in a clean, readable format. Include:

1. **The full carousel** — all slides with copy and design direction
2. **Design summary** — colors used, fonts, layout approach
3. **Platform notes** — dimensions, posting tips, caption suggestions
4. **Caption draft** — a suggested post caption

Save to `carousels/drafts/YYYY-MM-DD-[slug].md` automatically.

Log to `content-strategy/post-history.yaml`:
```yaml
- date: YYYY-MM-DD
  title: "[carousel title]"
  template: [template used]
  pillar: [content pillar]
  platform: [target platform]
  slides: [slide count]
  status: draft
```

### Phase 6 — Iterate

The client reviews and gives feedback. Apply changes and re-present.

**For design feedback:**
- "The colors feel off" → Check brand profile, suggest alternatives from the palette
- "Too text-heavy" → Reduce copy, add visual element suggestions
- "Layout is boring" → Vary the layout pattern, suggest asymmetric approaches

**For copy feedback:**
- "This doesn't sound like me" → Check style profile, identify the drift
- "The hook isn't strong enough" → Generate 3 new cover options
- "Too long" → Cut slides, tighten copy

If the same feedback appears 3+ times across carousels, update the relevant profile and tell the client.

### Phase 7 — Platform Adaptation (Optional)

If the client wants the carousel adapted for a second platform:

- Adjust dimensions and layout for the new platform
- Modify text density if needed (LinkedIn allows slightly more text)
- Update caption and posting recommendations
- Save as a separate draft file

---

## Output Format

Every carousel draft follows this structure:

```markdown
# Carousel: [Title]

**Platform:** [Instagram / LinkedIn / Both]
**Template:** [template name]
**Slides:** [count]
**Pillar:** [content pillar]
**Date:** [YYYY-MM-DD]

---

## Design System (for this carousel)

**Colors used:**
- Primary: [hex] — [where used]
- Secondary: [hex] — [where used]
- Background: [hex]
- Text: [hex]
- Accent: [hex] — [where used]

**Typography:**
- Headings: [font family], [weight], [size range]
- Body: [font family], [weight], [size range]

**Layout approach:** [brief description of the visual rhythm]

---

## Slide 1 — Cover
[full slide spec]

## Slide 2 — [Section]
[full slide spec]

[... all slides ...]

## Slide [N] — CTA
[full slide spec]

---

## Caption

[Suggested post caption with hashtags]

## Platform Notes

- **Dimensions:** [spec]
- **Best posting time:** [if known]
- **Hashtags:** [relevant hashtags]
- **Accessibility:** [alt text suggestion for cover slide]
```

---

## Rules

- Never create a carousel without reading the brand profile's Design System section first
- Every color must come from the client's brand palette — no generic colors
- Every font must match the client's brand typography — no defaults
- Cover slide must work as a standalone image (it IS the hook)
- One idea per slide — always
- Text must be readable at mobile size — if in doubt, make it bigger and shorter
- Visual rhythm matters — vary layouts so the carousel doesn't feel monotonous
- The CTA slide gets ONE action — don't split attention
- Save every draft — even if the client iterates heavily, keep versions
