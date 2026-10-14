# Ship: deploy, demo video, submission mechanics

Used in Phase 3 (plan the deploy early) and Phase 6 (execute). Deploys to production hosting need the user's OK each time (see Approvals in SKILL.md); web3 testnet deploys follow the pre-approval in STATE.md.

## Deploy

Plan it early, not last.
1. **Choose hosting in ARCHITECTURE.md Operations** based on the stack and what the team already has an account for (static/frontend host, serverless, container platform). Prefer the option with a free tier and a public URL without login.
2. **Walking-skeleton deploy by ~40% of the build budget**: the empty golden path live on a public URL. Every later change redeploys the same way.
3. Configure env vars in the host, not in the repo. Mirror names from `.env.example`.
4. **Check from outside**: open the URL logged out, in a private window, on a phone, and from another network. Check CORS, mixed content, cold start time, and that no secrets appear in the client bundle.
5. Keep deploy reproducible from a clean checkout with documented commands; tag the submitted commit (e.g. `submission`) so the judged code and the live app match.
6. **Freeze**: no deploys in the last 30 minutes before the deadline except a fix for a broken golden path. Keep the previous working deployment available for rollback.
7. Backend or database limits: check connection limits, free-tier sleeping, and quotas; wake the service before the demo.

## Demo video

Most platforms require or reward a 2-3 minute video, and judges may only watch the video.
1. Script from `docs/DEMO.md` (hook -> problem -> golden path -> tech -> next). Cut anything not on the golden path.
2. **Record a safety take early** (as soon as the golden path works, around the 70% mark) and a final take after the last fix. A working old video beats a missing new one.
3. Setup: 1080p, close notifications, clean browser profile, zoom the UI to be legible on a phone, seeded demo data, stable network (or recorded API responses).
4. Audio: record a short test and listen; use a headset mic; read from the script; no music that hides the voice.
5. Show the real thing working end to end first, then one architecture slide or diagram; state what is real vs mocked.
6. Add captions or on-screen text for key steps; keep it under the platform's length limit.
7. Upload where the rules require (platform upload, YouTube unlisted/public, Loom). **Open the link logged out and play it to the end** before submitting.
8. Screenshots/GIFs for README and the submission form: capture with the `playwright` skill if available or the OS screenshot tool; use the same seeded data.

## Submission mechanics

1. **Submit a draft early** (around 50% of the event) to see every field and character limit; platforms usually allow edits until the deadline. Confirm that with the rules.
2. Prepare answers in `docs/hackathon/SUBMISSION.md` (copy `templates/hackathon/SUBMISSION.md`): title, tagline, description, tech list, links (repo, live URL, video, deck), track/prize selections, team members, AI-usage disclosure if required. Rehearsals and the backup recording are logged in `docs/DEMO.md` (from `templates/hackathon/DEMO.md`).
3. Check each link logged out; check that the repo is public if required, has a license, and has no secrets in history.
4. Re-open the submitted page after saving and confirm it shows the final text and links.
5. Submit at least 30 minutes before the deadline; then only fix typos and broken links.
