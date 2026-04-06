# /carousel-setup

Derive a carousel-specific style profile from the central brand identity. Covers both copy voice AND visual design direction. This is design-heavy — the visual identity matters as much as the writing.

## Trigger

Activate when `kits/carousel/identity/style-profile.md` is missing or empty and the user wants to create a carousel.

## Prerequisites

All three brand documents must exist. `brand/identity/visual-identity.md` is especially critical for carousels. If visual identity is missing or thin: "Carousels are visual content — every slide needs to match your brand's look. Let's go to `/brand evolve` and flesh out your visual identity first."

## Process

### Step 1 — Read the Brand

Read all three central brand documents, especially visual identity. Summarize:
> "I know your brand and your visual style — [summary including colors, fonts, aesthetic]. Now I need to tune this for carousel content specifically."

### Step 2 — Gather Visual References

Check `brand/identity/design-references/` and `kits/carousel/inspirations/screenshots/`.

Ask: "Do you have screenshots of carousels you like? Drop them into the inspirations folder, or send them here. Instagram carousels, LinkedIn carousels — anything that made you think 'I want mine to look like that.'"

If Chrome is available, offer: "I can also go browse Instagram or LinkedIn profiles to study carousel styles. Give me a name and I'll go look."

### Step 3 — Gather Writing Samples

Check `brand/identity/writing-samples/`. Carousel copy is its own format — short, punchy, one idea per slide. If they have carousel copy, great. If not, other writing works but interview for carousel-specific patterns.

### Step 4 — Build 10-Dimension Style Profile

**7 Copy Dimensions:**
1. **Sentence Architecture** — short/punchy for slides, headline style
2. **Vocabulary & Language** — formality, jargon, simplicity
3. **Tone & Register** — energy level, warmth, authority
4. **Rhetorical Patterns** — how they teach, persuade, hook
5. **Perspective & POV** — direct "you" vs first person
6. **Rhythm & Pacing** — slide density, text per slide
7. **Personality Markers** — emoji on slides, exclamations, visual humor

**3 Visual Dimensions:**
8. **Visual Rhythm** — slide transitions, info pacing across slides, build-up patterns
9. **Design Vocabulary** — icons vs photos vs illustrations, shapes, dividers, backgrounds
10. **Typography Patterns** — headline vs body hierarchy, emphasis (bold, color, size), text placement

### Step 5 — Content Strategy

Ask about:
- Content pillars (3-5 themes) → save to `kits/carousel/content-strategy/pillars.yaml`
- Posting cadence (how often, which platforms)
- Instagram vs LinkedIn vs both

### Step 6 — Inspiration Creators

> "Whose carousels make you think 'I want mine to look like that'?"

Add to `sources.yaml` under `carousel_creators`. Offer to run `/study-creator` on any of them.

### Step 7 — Save and Confirm

Save to `kits/carousel/identity/style-profile.md` with all 10 dimensions plus a Design System Reference section that points to the brand's visual identity. Present for approval.

Then: "Your carousel style is set up — both copy voice and design direction. Now let's make that carousel — what's the topic?"

## Output
- `kits/carousel/identity/style-profile.md`
