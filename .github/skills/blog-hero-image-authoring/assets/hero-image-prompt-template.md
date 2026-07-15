# Hero Image Prompt Template

Use this as the default prompt for a new generated blog header image.

```text
Create a wide technical blog hero image for an article titled "<ARTICLE_TITLE>".

Article context:
- Topic: <TOPIC>
- Reader problem or outcome: <PROBLEM_OR_OUTCOME>
- Products/services involved: <PRODUCTS>
- Visual metaphor: <VISUAL_METAPHOR>

Style:
- Wide banner, 16:9 aspect ratio, high-resolution PNG.
- Clean Microsoft-adjacent technical design: deep navy/blue/teal palette, crisp lighting, subtle grid or cloud/infrastructure background.
- One clear central concept with two to four supporting symbols such as cloud, lock, identity card, database, pipeline, terminal, table, arrows, workflow nodes, or device panels.
- Professional technical illustration, not a generic stock image.
- Leave comfortable margins around the main subject so it works in article headers, cards, and OpenGraph crops.

Text rules:
- Prefer no embedded title text.
- If labels are necessary, use only these short labels and spell them exactly: <OPTIONAL_LABELS_OR_NONE>.
- Do not include tiny UI text, code, fake error messages, URLs, tenant IDs, tokens, emails, subscription IDs, or secrets.

Composition requirements:
- Main subject: <MAIN_SUBJECT>
- Supporting objects: <SUPPORTING_OBJECTS>
- Mood: <MOOD>
- Avoid: cluttered dashboards, unreadable small text, exact sensitive data, generic business people, excessive purple gradients.

Output should be suitable to save as: public/heroes/<SLUG>.png
```

## Example: Troubleshooting Fix

```text
Create a wide technical blog hero image for an article titled "Fixing PAC CLI non-recoverable error in GCC High and DoD by enabling telemetry".

Article context:
- Topic: Power Platform CLI telemetry crash in government cloud environments.
- Reader problem or outcome: A CLI command fails with a non-recoverable error, and enabling telemetry resolves the crash path.
- Products/services involved: Power Platform CLI, GCC High, DoD, telemetry, terminal.
- Visual metaphor: A broken warning path on the left becoming a healthy secured command path on the right.

Style:
- Wide banner, 16:9 aspect ratio, high-resolution PNG.
- Dark navy technical background with blue and teal circuit/grid accents, crisp glow, professional troubleshooting mood.
- Central shield or terminal symbol with a repair/checkmark concept.
- Supporting symbols: terminal window, warning icon, telemetry signal, government cloud boundary.

Text rules:
- Prefer no embedded title text.
- If labels are necessary, use only: "PAC CLI", "Telemetry", "Enabled".
- Do not include tiny UI text, code, fake error messages, URLs, tenant IDs, tokens, emails, subscription IDs, or secrets.

Composition requirements:
- Main subject: secured Power Platform CLI terminal recovering from an error.
- Supporting objects: warning state on left, telemetry signal in middle, checkmark state on right.
- Mood: practical, secure, technical, resolved.
- Avoid: cluttered dashboards, unreadable small text, exact sensitive data, generic business people, excessive purple gradients.

Output should be suitable to save as: public/heroes/fixing-pac-cli-non-recoverable-error-in.png
```

## Example: Architecture / Integration

```text
Create a wide technical blog hero image for an article titled "Bridging Clouds: Secure Pipelines from Azure DevOps to GCC High".

Article context:
- Topic: Moving artifacts from Azure DevOps Commercial to GCC High Storage using managed identity and workload identity federation.
- Reader problem or outcome: Secure cross-cloud file transfer without long-lived secrets.
- Products/services involved: Azure DevOps, managed identity, workload identity federation, GCC High Storage.
- Visual metaphor: A secure dotted pipeline crossing from commercial cloud to government cloud through an identity card and lock.

Style:
- Wide banner, 16:9 aspect ratio, high-resolution PNG.
- Clean flat technical diagram with Microsoft-adjacent blues, white cloud shapes, simple arrows, and security lock accents.
- One clear cross-cloud flow from left to right.

Text rules:
- Short labels are allowed and should be spelled exactly: "Azure DevOps", "Managed Identity", "GCC High Storage".
- Do not include tiny UI text, code, fake error messages, URLs, tenant IDs, tokens, emails, subscription IDs, or secrets.

Composition requirements:
- Main subject: managed identity card in the center connecting both clouds.
- Supporting objects: Azure DevOps symbol on left, secured cloud lock above, storage/database symbol on right, dotted federation path.
- Mood: secure, clear, compliant, practical.
- Avoid: cluttered dashboards, unreadable small text, exact sensitive data, generic business people, excessive purple gradients.

Output should be suitable to save as: public/heroes/bridging-clouds-secure-pipelines-from.png
```