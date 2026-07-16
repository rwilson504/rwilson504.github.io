# Blog Style Guide

This guide summarizes the current article conventions in `rwilson504.github.io` based on the Astro schema and representative posts across the archive.

Publishing target identity:

- GitHub repository: `rwilson504/rwilson504.github.io`
- Expected local clone folder: `rwilson504.github.io`
- NPM package name: `richardawilson-com`
- Blog content root: `src/content/blog`
- Public hero root: `public/heroes`
- Public body image root: `public/images`

When drafting from another repository, use that repo only for source context. Final article review, image path checks, hero image generation, and build validation belong in the `rwilson504/rwilson504.github.io` clone.

## Content Model

Posts live in `src/content/blog` as `.md` or `.mdx` files. The schema is defined in `src/content.config.ts`.

Required frontmatter:

- `title`: quoted string preferred, title case or sentence case depending on the article.
- `description`: one or two sentences. It should summarize the practical scenario, not tease the post.
- `pubDate`: `YYYY-MM-DD`.
- `category`: one of the fixed category slugs.
- `tags`: YAML array.
- `draft`: `false` for publishable posts.

Optional frontmatter:

- `updatedDate`: use for meaningful refreshes to an older article.
- `heroImage`: usually `/heroes/<slug>.png` for newer posts.
- `heroImageAlt`: specific description. Include when `heroImage` exists unless preserving a migrated legacy post.
- `originalBloggerUrl`: only for migrated/legacy redirect support.

## Categories

Allowed categories:

- `power-apps`: Power Platform, Dataverse, Dynamics, Power Automate, Power Pages, connectors, Azure patterns used with Power Platform. This is the dominant category.
- `ai`: AI tools, agents, model workflows, hosted assistants.
- `electronics`: hardware and maker electronics.
- `3d-printing`: printer tuning, models, slicer/workflow notes.
- `windows`: Windows administration, server/client fixes, desktop tooling.
- `dev-tools`: developer tooling, local tools, CLIs, GitHub Copilot, OpenClaw, VS Code adjacent workflows.
- `personal`: theater, family, personal updates.
- `misc`: everything that does not fit the above.

When unsure between `power-apps` and another category, choose the category that matches the reader's problem. For example, an Azure Logic Apps article used from a Dataverse plug-in belongs in `power-apps`.

## Tags

Tags are mostly lowercase and kebab-case, with occasional compact product tags used historically. Use existing vocabulary where possible.

Common tags include:

- Power Platform: `power-apps`, `power-platform`, `power-automate`, `power-pages`, `dataverse`, `dynamics`, `dynamics-365`, `flow`, `canvas`, `pcf`, `webapi`, `customconnector`.
- Azure and identity: `azure`, `azuredevops`, `azurestorage`, `azuresecurity`, `azuremanagedidentity`, `managedidentity`, `oauth`, `oauth2`, `authentication`, `security`, `gcc-high`, `dod`, `government`.
- Troubleshooting and tooling: `powershell`, `clierrors`, `paccli`, `debugging`, `troubleshooting`, `error`, `tools`, `devops`.
- Data: `data`, `power-bi`, `power-query`, `etl`, `reporting`, `datamodeling`, `queryfolding`.
- Legacy Microsoft stack: `crm`, `crm-2011`, `crm-4`, `sharepoint-2007`, `sharepoint-2010`, `iis`, `adfs-2`, `sql`, `javascript`, `ribbon`.

Guidelines:

- Use 3 to 8 tags for most posts. Deep technical guides can use 8 to 12 when it improves discovery.
- Prefer tags already used in the repo so tag pages are linkable once used by 2+ posts.
- Use product, problem, and technique tags. Example: `power-platform`, `paccli`, `gcc-high`, `telemetry`, `troubleshooting`.
- Avoid one-off clever tags unless the subject really needs them.

## Titles And Descriptions

Titles are concrete and often include the product plus outcome:

- `Fixing PAC CLI “non-recoverable error” in GCC High and DoD by enabling telemetry`
- `Power Query: Driftless Merges using Table.Buffer`
- `Calling Dataverse Web API in PowerShell using Client Credentials`
- `Locking Down a Logic App (Consumption) with OAuth for Calls from Dataverse Plug-ins using Managed Identity`

Good title patterns:

- `Fixing <error or symptom> in <product/context>`
- `<Product>: <specific pattern or fix>`
- `<Action> <system> with <tool/approach>`
- `<Problem>: <practical framing>`

Descriptions should be plain summaries of the scenario. They often start with the real-world trigger: `Recently I was working on...`, `If you use...`, `I’m using...`, `When managing...`.

## Structure Patterns

### Troubleshooting Fix

Use when the post is about an error, crash, confusing behavior, or operational gotcha.

Recommended sections:

- Opening paragraph with symptom and context.
- `## What I observed`
- `## The surprising trigger` or `## Why this happens`
- `## Check your ...`
- `## Fix: ...`
- `## Why the error is misleading` when relevant.
- `## Quick troubleshooting checklist`
- `## Wrap-up`

This pattern matches posts like the PAC CLI telemetry article.

### Step-By-Step How-To

Use when the reader needs to perform setup in a portal, CLI, or product UI.

Recommended sections:

- `## Introduction` or `## Why I did this`
- `## Key Placeholders to Fill In` for multi-environment setup.
- Numbered `## Step 1 - ...`, `## Step 2 - ...` sections.
- Screenshots immediately after the step they clarify.
- A validation or test section.
- `## References`

Use placeholders like `<<tenant-id>>`, `<<resource-group-name>>`, and `<<service-connection-name>>` for values the reader must replace.

### Pattern Or Best Practice

Use when teaching a repeatable design pattern.

Recommended sections:

- `## Introduction`
- Problem framing.
- Why the pattern works.
- Step-by-step implementation.
- Tradeoffs or cautions.
- `## Conclusion`

This pattern matches Dataverse autonumber/alternate key and Power Query `Table.Buffer` posts.

### Long-Form Playbook

Use for broad guidance spanning multiple audiences or phases.

Recommended sections:

- A short summary paragraph.
- `**Table of Contents**` when the post is long.
- `## Introduction`
- `## Part I`, `## Part II`, `## Part III` sections.
- Deep subsections with examples, standards, and links.
- `## Conclusion` and references.

## Tone

The voice is practical, experienced, and field-tested.

Do:

- Explain what prompted the post.
- Name the product, environment, and version when relevant.
- Acknowledge confusing or misleading product behavior plainly.
- Use first person sparingly but naturally.
- Give readers exact commands, paths, settings, and expected outcomes.
- Mention caveats and cleanup steps, especially for security-sensitive fixes.

Avoid:

- Generic intros like `In today's fast-paced digital world`.
- Overstating certainty beyond what was tested.
- Sales language or broad claims without a practical path.
- Vague phrases like `seamless experience` unless backed by specific behavior.

## Markdown Conventions

- Use `##` for major sections and `###` for subsections.
- Use numbered lists for procedures.
- Use bullets for observations, cautions, and options.
- Use fenced code blocks for commands, PowerShell, JSON, YAML, M, C#, and pipeline examples.
- Keep command blocks copyable; do not prefix commands with prompts unless the prompt is important.
- Use bold text for product UI labels and key terms.
- Use blockquotes for quoted errors or important notes.
- Screenshots usually live under `/images/<post-slug>/NN-description.png`.
- Hero images usually live under `/heroes/<post-slug>.png`.

## Screenshots And Images

Newer posts use hero images when available, commonly at `/heroes/<slug>.png`. Body screenshots are stored under `/images/<slug>/` with a numeric prefix.

Use Markdown image syntax:

```markdown
![Short useful alt text](/images/example-slug/01-settings-page.png)
```

For migrated legacy posts, wrapped linked images appear in older content. New posts should prefer simple image syntax unless linking to the original full-size image is important.

## References

Include `## References` when the post depends on official docs, tools, upstream repos, specs, or standards. Link to Microsoft Learn, GitHub, product docs, jwt.ms, XrmToolBox tools, or API specs as appropriate.

Before publishing, check external internet links from the blog repo:

```powershell
.\.github\skills\blog-post-authoring\scripts\check-post-links.ps1 -Path .\src\content\blog\<slug>.md
```

Fix broken links before setting `draft: false`. If a site blocks automated requests but opens manually, record that in the handoff/final response instead of silently ignoring it.

## Quality Checklist

- The post answers: what happened, who it affects, why it happens, how to fix/use it, and how to confirm success.
- Security-sensitive examples avoid real secrets, tenant IDs, tokens, and private URLs.
- Any temporary tracing or diagnostic step includes removal guidance.
- External internet links have been checked, and broken or redirected stale URLs have been corrected.
- The tags reinforce discoverability without drifting into unrelated subjects.
- The description works as a search result snippet.
- The article still makes sense if a reader lands directly from search.