# UI / front-end design

Applies whenever the project has a user interface. Used in Phase 2 (fill `docs/DESIGN_SYSTEM.md`), Phase 4 (build) and Phase 5 (visual QA). The bundle's `DESIGN_SYSTEM.md` template stays pristine; the sections below are **appended** to the project's copy after the bundle's own sections (design direction, UI tokens, layout rules, components, accessibility, screen states, approval).

## Phase 2: addendum to append to docs/DESIGN_SYSTEM.md

Fill every section; mark guesses `Proposal - needs approval`.

1. **Screen inventory**
   | Screen | PRD journey / feature | Purpose | Key components | States | Wireframe |
   | --- | --- | --- | --- | --- | --- |
2. **Flow**: the golden path as an ordered list of screens and actions, plus the main failure branch.
3. **Wireframes**: one per screen, golden path first. Use Figma or Pencil tools if available and link the frames; otherwise ASCII sketches in the doc. Get approval before building.
4. **Type scale**: font families (free or properly licensed, with fallbacks), sizes for h1-h4 / body / small / caption, weights, line heights, max line length.
5. **Color roles** (beyond raw tokens): background, surface, border, text, muted, primary, accent, success, warning, error, focus ring. Record contrast ratios checked. Decide dark, light or both.
6. **Spacing and grid**: base unit scale, container widths, breakpoints, mobile-first rules.
7. **Icons and imagery**: one icon set, image/illustration style, logo, licenses and attribution.
8. **Motion**: duration/easing tokens, which interactions animate, `prefers-reduced-motion` fallback, and the one "wow" moment planned for the demo.
9. **Voice and copy**: tone, button label rules, error format (what happened + what to do next), empty-state copy, microcopy for wallet / AI / loading states when relevant.
10. **Demo conditions**: demo device (laptop, phone, projector), minimum viewport, legibility from a distance, network assumptions.
11. **Component inventory**: UI library chosen once (also recorded in ARCHITECTURE.md), list of custom components and where they live.
12. **Do / Don't list** (8-12 bullets the agent obeys every session), e.g. use tokens only, no inline colors, no new fonts, no new UI library, every screen ships all states.
13. **Design decisions log**: date, decision, reason.

## Process

- Direction: `frontend-design` (pick a clear point of view), `antislop-ui` and `antislop-layoutmobile` for rules on color, layout, components, motion. If available, `design-system`, `frontend-design-direction` and `frontend-a11y` (ecc) can help; `dataviz` for charts.
- Sponsor or brand assets override your own choices.
- Collect 2-3 visual references (URLs or screenshots) and write what to borrow; do not copy.
- Implement tokens once (CSS variables or a theme file). Components consume tokens; no hardcoded colors, fonts or spacing elsewhere.

## Phase 4: build order

1. Tokens / theme file.
2. App shell and navigation.
3. Golden-path screens from the approved wireframes.
4. All states per screen (loading, empty, error, success, disabled) before moving to the next screen.
5. Motion and polish last.

Take baseline screenshots of the golden-path screens at 390px and 1280px after each major change (the `playwright` skill if available) so regressions are visible. Logic follows superpowers TDD; UI glue gets at least a smoke test or screenshot check.

## Phase 5: visual QA checklist

- [ ] Golden-path screens checked at mobile 390x844, tablet 768, desktop 1280+, and the demo resolution: no overflow, overlap or clipped text.
- [ ] Every state exists and its copy follows the voice rules.
- [ ] Text contrast at least 4.5:1 (3:1 for large text); use a contrast checker, not eyeballing.
- [ ] Keyboard: logical tab order, visible focus, Escape closes dialogs.
- [ ] Reduced motion respected; nothing essential depends on animation.
- [ ] No lorem ipsum, placeholder images, dead links, default framework title or favicon.
- [ ] Page title, favicon and social/OG preview image set (submission links get previewed).
- [ ] Fonts and images load on a slow connection (self-host or fallback stack).
- [ ] Light/dark behavior matches the decision; no unreadable state.
- [ ] Final screenshots/GIF for the README and submission captured from the final build.
