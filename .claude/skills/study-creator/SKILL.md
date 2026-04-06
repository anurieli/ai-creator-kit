# /study-creator

Deep-dive a creator's content patterns. Context-aware — analyzes visual design for carousel creators, writing patterns for LinkedIn creators, or both.

## Trigger

Activate when the user says "study how [creator] does carousels", "analyze [creator]'s LinkedIn", "study [creator]", or similar.

## Context Detection

Determine which analysis to run:
- **Carousel signals:** "carousels", "design", "slides", "visual", "Instagram" → Visual analysis
- **LinkedIn signals:** "LinkedIn", "posts", "writing" → Writing analysis
- **Ambiguous:** Ask — "Should I study their carousel design style, their LinkedIn writing style, or both?"

## Carousel Analysis (Visual Focus)

1. Research the creator's carousel content. If Chrome is available, visit their Instagram/LinkedIn to see actual posts.
2. Analyze:
   - **Cover slide patterns** — headline style, visual hierarchy, hook approach
   - **Slide structure** — info density per slide, build-up patterns, pacing
   - **Design system** — colors, fonts, layout patterns, visual elements
   - **Copy style** — headline writing, body text density, CTA approach
   - **Engagement patterns** — what formats get most engagement
3. Save study to `kits/carousel/identity/creator-studies/[creator-name].md`
4. Offer: "Want me to incorporate any of their techniques into your carousel style?"

## LinkedIn Analysis (Writing Focus)

1. Research the creator's LinkedIn content. If Chrome is available, visit their profile.
2. Analyze across 10 dimensions:
   - 7 base writing dimensions (sentence architecture, vocabulary, tone, rhetorical patterns, perspective, rhythm, personality)
   - 3 LinkedIn-specific (hook patterns, formatting DNA, engagement patterns)
3. Save study to `kits/linkedin/identity/creator-studies/[creator-name].md`
4. Offer: "Want me to incorporate any of their techniques into your LinkedIn style?"

## Integration

If the user wants to adopt specific techniques:
1. Identify exactly which techniques to borrow
2. Show before/after of how the user's profile would change
3. Update the kit's style profile on approval
4. Note: "Inspired by [creator]" in the Do section — never clone, always adapt

## Output
- `kits/carousel/identity/creator-studies/[name].md` or
- `kits/linkedin/identity/creator-studies/[name].md`
