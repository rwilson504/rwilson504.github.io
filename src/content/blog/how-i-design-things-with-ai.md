---
title: "How I Design Things with AI: From an Idea to a Part I Can Print"
description: "My workflow for designing physical things with AI in VS Code: code-based CAD, small fit tests, slicer checks, and reusable agents and skills. A Pixel Tag collar holder is the example."
pubDate: 2026-11-24
category: ai
tags:
  - "ai"
  - "agents"
  - "3d-printing"
  - "cad"
  - "openscad"
draft: false
heroImage: "/heroes/how-i-design-things-with-ai.png"
---

I've always wanted to get into 3D CAD. I tried learning it several times, but I kept stopping for the same reason: the software was complex, and it took a lot of time to learn before I could make the things I wanted to make.

The exception was theatre. I got pretty good at using Google SketchUp to design sets. I could lay out a scene and see how it would look onstage without modeling every construction detail. We often built walls in standard sizes and stored them for reuse, so I could design around pieces we already had. The model needed to be accurate enough to plan the set, but it didn't have to be a fabrication drawing for every piece.

AI gave me a way back into CAD through tools I already knew: code and VS Code. At first, the exciting part was getting from an idea to a model I could look at. Now I'm more interested in what happens after that first model: how I check the fit, how I change the part without breaking something that already works, and what I save so I don't have to figure it all out again on the next project.

A Pixel Tag holder for my dog's collar is a good example of where that process has gotten me. I couldn't thread the sewn collar through the closed loops on existing holders. I needed something that could go onto the webbing from the side. That was the idea. Getting from there to a part on the collar took measurements, a couple of small fit tests, some broken clips, and a few tools that each answered a different question.

## Bottom line

I don't ask AI to design the whole thing and then hit Print. I show it what I'm trying to do, ask for something small enough to check, and bring back what I find. Sometimes that's a measurement. Sometimes it's a picture with a circle around the part that doesn't look right. And sometimes it's a clip that broke in my hand.

The part I wish I'd figured out earlier: once we solve something, I ask the agent to save the lesson where it'll find it on the next project. That way I'm not starting the next chat by teaching it the same workflow again.

## The tools I use and what I use them for

In GitHub Copilot, I used GPT-6.2 Sol for most of the collar-holder project. That's the model I used for this example, not a requirement for following the process.

| Tool | Where it fits in my process |
| --- | --- |
| **[GitHub Copilot in VS Code](https://code.visualstudio.com/docs/copilot/overview)** | Turn a description, sketch, or marked-up screenshot into a design change. Edit the model code, run the rebuild, and review the results with me. |
| **Measuring tools:** [digital calipers](https://www.amazon.com/dp/B087N5N45G) or graph paper and a camera | I use calipers for direct measurements, or a photo on graph paper with a known grid size to give AI a scale for estimates. The caliper link is a non-affiliate example of an inexpensive 6-inch (150 mm) set; similar sets work fine. |
| **[Python](https://www.python.org/downloads/) and [build123d](https://build123d.readthedocs.io/en/latest/)** | Model the part with named dimensions. I can change one parameter and regenerate an STL instead of redrawing the part or scaling the whole thing. |
| **[Blender](https://www.blender.org/) with [blendquery](https://github.com/uki-dev/blendquery)** | Import build123d geometry into a separate 3D package for stronger renders and animations when the STL viewer isn't enough. |
| **[STL Viewer by Slevesque](https://marketplace.visualstudio.com/items?itemName=slevesque.vscode-3dviewer) in VS Code** | Quickly inspect the exported part without switching apps. When the outside view isn't enough, generate a cross-section from CAD. |
| **[Bambu Studio](https://github.com/bambulab/BambuStudio/releases) and a [Bambu Lab P2S](https://wiki.bambulab.com/en/p2s)** | Check orientation, supports, and filament use in the slicer, then print the test. The [Bambu Studio command line](https://github.com/bambulab/BambuStudio/wiki/Command-Line-Usage) helps me repeat slice checks without doing the same clicks every time. |
| **[OpenSCAD](https://openscad.org/) and [MakerWorld's Parametric Model Maker](https://makerworld.com/en/makerlab/parametricModelMaker?pageType=home)** | Give someone else a way to change fit and lettering in the browser instead of asking them to run my Python project. |

## I start with the thing in my hand

“Make me a Pixel Tag holder” sounds like a reasonable place to start. But looking at the collar, the tag wasn't the hard part. I could find plenty of examples of a pocket that holds a tracker. What I couldn't do was get my dog's collar through the loops. Once I explained that the buckle wasn't coming off, we had a much better problem to solve: could I tuck the flexible strap into a holder from the side?

This is where I reach for the calipers. The collar was nominally 20 mm, but the strap where the holder would sit measured **19.5 × 3.0 mm**. A photo helped explain how I wanted the clip to work. On its own, it didn't give the AI a reliable scale or tell it how easily the strap bent. I can supply both of those things without knowing how to draw the clip yet.

![Measurement diagram showing where to measure the strap width face-on and its thickness edge-on without compressing the webbing.](/images/ai-assisted-pixel-tag-holder/measure-collar.png)

**No calipers? Try graph paper.** Set the part on paper with a known grid size, such as 5 mm squares, and take a photo straight down with several squares visible around it. Tell the AI the square size and ask it to use the grid to estimate the part's width and length. For thickness, take a separate side-on photo with the grid behind the edge you're measuring, as close to the same plane as possible.

You can print graph paper, too. Select **Actual size** or **100%** instead of **Fit to page**, then check several squares with a ruler before using the grid as your scale. I treat the measurements from a photo as a starting point. A tilted camera or a raised edge can throw them off, so for a snug fit I'd still print a small test piece before committing to the whole part.

The design changed as I got my hands on it. An early version had a separate screw-on bezel. We moved to one piece that loads the tag from the back. When the little bumps inside the pocket held the tag firmly, I thought we'd solved that part. Then I tried getting the tag back out.

I could have asked the AI to make the pocket looser. But I liked how securely the tag sat. The problem was that I had nowhere to push it from the other side. We left the little bumps alone and extended the speaker opening so I could push the tag out through it. I wouldn't have thought to ask for that on the first pass. I had to try using the holder to find out what was missing.

Those are the kinds of changes I want to be able to make without starting over. With the dimensions in code, I can ask, “Keep the part that holds the tag the same, but make this fit a wider collar.” When I spotted a notch where a rail met a clip, I circled it in a screenshot so the AI knew exactly where to look. That gave us something specific to fix without changing the rest of the holder.

### One model, three kinds of STL

I use the same CAD script to export three kinds of STL, depending on what I'm trying to do:

| Export | What I use it for |
| --- | --- |
| **Design** | Review the shape in the viewer. The script puts a separate reference block next to the part. Its labeled faces tie words like *up*, *down*, *left*, and *right* to the model's axes. The block is for review, not for printing. |
| **Test** | Print the full part without the separate block. When I need to point out a fit problem after printing, I can put temporary direction labels right on the part: *top*, *bottom*, *left*, and *right*. |
| **Production** | Slice or share the clean part, without the reference block or test-only labels. Intended features, like the holder's engraved name, stay. |

The block saves me from saying “move the clip on the left” and finding out the AI and I were looking at opposite sides. I can point to a labeled direction in a screenshot, and that direction stays tied to the model even if I rotate the view. That's separate from print orientation: the holder stands on a short end for printing, even though that isn't what I'd call *down* when it's on the collar.

![The same full holder in all three panels: design has a separate direction block, test illustrates top, bottom, left, and right labels on the holder itself, and production has no orientation aids.](/images/ai-assisted-pixel-tag-holder/stl-export-modes.png)

The middle panel illustrates where labels could go on a full test print; those labels aren't part of the released collar holder.

![Close-up of the blue direction block with engraved top, bottom, left, right, front, and back labels.](/images/ai-assisted-pixel-tag-holder/design-reference-block.png)

The design cube maps direction names to the model's axes. The labels stay useful as I rotate the CAD view.

### The design cube tells me which way. The GLB tells me which part.

I also ask for a **GLB** when I want to talk through a change with the AI. The STL is what I send to the slicer. The GLB is what I open in VS Code to look around the design. It can keep names and colors for individual features, even when those features print as one piece.

On the collar holder, I can expand the **Hierarchy** panel and see the holder, the rails, the little bumps that retain the tag, and stand-ins for the tag and collar. In the screenshot, I've selected `Tag_detent_1`, one of the small bumps that keeps the tag in the pocket. I can see where it sits on the model without confusing it with the clips that hold the collar.

![The VS Code GLB viewer shows Tag_detent_1 selected in the hierarchy and the small retaining bump highlighted inside the holder.](/images/ai-assisted-pixel-tag-holder/glb-hierarchy.png)

That changes what I can ask for. Instead of “make that bump a little smaller,” I can share the screenshot and say, “Make `Tag_detent_1` stick out a little less, but leave the tag pocket and collar clips alone.” The name tells the AI what to change, the screenshot shows where, and the last part tells it what to preserve. The detent is still part of the one-piece print; it just gets its own name in the review file.

### Version 28 didn't mean 28 prints

The holder I put on the collar was version 28, but I didn't print every version along the way. I used the version numbers as checkpoints. After asking for a change, I'd open the new STL next to the previous one and check two things: did it change what I meant, and did it leave the parts I already liked alone?

Making the holder shorter was a good example. One attempt shortened the clips too, which meant less of each clip held onto the strap. I didn't need to print it to see that wasn't what I wanted. For the next version, I asked to keep the full clip length and move the clips closer together instead. Keeping the earlier export made it easy to show what I wanted to keep.

I try not to pile several unrelated changes into one request. If the next version looks wrong, I'd rather be able to point to one change and say, “That's not what I meant.” When the question is about shape or a dimension I can check on screen, a saved version is enough. When it's about how the strap bends, how snug the tag feels, or whether a clip survives cleanup, that's when I turn on the printer.

![Outward and collar-side CAD views from V1 through V28, with contrasting lettering starting at V13.](/images/ai-assisted-pixel-tag-holder/holder-design-evolution.gif)

The animation runs once for 26 seconds. You can also [view eight key milestones without animation](/images/ai-assisted-pixel-tag-holder/holder-design-evolution-overview.png). These are CAD renders, not photos of 28 prints. The contrasting lettering starts at V13 to show when the two-color inlay became an option. The final ASA holder I put on the collar was still a single-color print.

## I'd rather print a clip than another whole holder

Before printing anything, I looked at split AirTag holders to see how their clips let a strap in from the side. I also looked at Pixel Tag cases to get a better sense of the pocket shape. I wasn't combining pieces of those models. They gave me ideas for geometry I could build myself. They couldn't tell me which opening would work with my collar or how snug I'd want the tag to be.

AI can also help reverse-engineer a part from an STL or a CAD file. I can ask it to measure features, take cross-sections, or help rebuild the shape as an editable model. But being able to rebuild a model doesn't mean I have permission to reuse it. Before I adapt someone else's design, I check whether the license allows derivative works and whether it covers what I want to do: make one for myself, share a remix, or sell prints. Free to download doesn't mean free to sell. I also check for attribution or other sharing requirements. If the terms aren't clear, I ask the creator or find another starting point.

That's where *coupons* come in: small pieces that reproduce just the feature I need to test. For this holder I asked two separate questions:

| Question | What I printed | What I learned |
| --- | --- | --- |
| What side gap works with this webbing? | Two PLA clip coupons with the same **20 × 3.6 mm** channel and **10 mm** or **14 mm** openings. | I preferred 10 mm on my flexible nylon strap. |
| How much clearance does the tag need? | Pocket-only gauges with **0.20 mm** and **0.35 mm** clearance per side. | Both fit; I preferred the snugger 0.20 mm gauge. |

![CAD render of the small G10 test coupon, with a 10 mm opening between the two retaining lips.](/images/ai-assisted-pixel-tag-holder/clip-coupon.png)

The nice thing about the clip test was that I could pick up both pieces and try them on the same strap. I wasn't comparing one holder with a bunch of changes against another holder with a bunch of different changes. The channel was the same; only the opening changed. I liked the smaller gap on my collar. If I were making one for stiff leather, I'd want to try it again rather than assume the same answer.

I did the pocket test for the same reason. I wanted to know how much the tag moved when I pressed on it, not whether the whole holder looked good on the printer. Once I liked both fits separately, I printed the whole thing to find out what the little tests couldn't tell me: could I get everything together, and could I get the tag back out? I still use full prototypes. I just try not to print one to answer a question a small piece could answer first.

## The clip that broke told me more than the preview did

Printing face-down looked like the easier option in the slicer. It could use shorter supports, and the print was quicker on paper. Then a clip snapped along a layer as I removed the supports.

“Make it stronger” could have sent us in a dozen directions. What helped was telling the AI which piece broke and when: it was one of the arms holding the collar, not one of the little bumps holding the tag, and it happened during cleanup. That gave us a reason to look at which way the layers ran, not just how thick the clip was.

I smoothed and reinforced the places where the clips join the body and stood the holder on a short end instead of laying it face-down. The next PLA print felt noticeably stronger in hand. I changed both the shape and the print direction, so I can't tell you how much credit each change deserves. But I knew which combination I wanted to carry into the ASA print.

I chose ASA because I wanted a stiff holder that could handle sunlight outdoors. The single-color print went well, and I put it on the collar. That's the finish line I was aiming at when I started: something I could actually use. It doesn't tell me how it'll hold up over time.

For anyone who wants the settings, I used the P2S with a 0.4 mm nozzle, 0.20 mm layers, five walls, 15% gyroid infill, tree supports, and a 7 mm brim. The detail I'd put ahead of any of those numbers is **print it upright on the short end**. That's the setup that worked for me.

## Making one for my dog was different from sharing it

Once I had a holder I liked, I didn't want the next person to have to use my collar measurements or my dog's name. This is where having the design in code paid off. I could ask for a set of collar widths from 15 to 40 mm, try different thicknesses and clip gaps, and compare the results while leaving the tag pocket alone. I didn't print all those sizes. I checked the models so I could see where the changes were working and where they needed more attention.

The lettering was a good example of something I noticed by looking at the results, not by writing a requirement up front. A long name squeezed onto one line looked tiny on a holder with plenty of space above and below it. I asked the AI to try splitting names at a space if that let the letters stay bigger. Then I asked for the same treatment below the speaker opening, where someone might want both a phone number and an email address.

![Same-scale lettering previews show how splitting long sample names across two lines makes the letters larger on the 35 and 40 mm holders.](/images/ai-assisted-pixel-tag-holder/lettering-wrap.png)

I made an OpenSCAD version so someone on MakerWorld could enter those choices in the browser instead of setting up my Python tools. I kept the Python version as my reference and compared the files the two tools produced. One combination even failed when Python tried to join a clip to the body, while OpenSCAD produced a part. I reran the Python case on its own and got the same failure. Being able to export one version didn't prove the other worked, and checking either on my computer didn't prove all the sizes fit in real life.

![Six views of the Python and OpenSCAD exports, showing the lettering face, collar-facing pocket, side profiles, and both clip openings.](/images/ai-assisted-pixel-tag-holder/six-view-comparison.png)

Two-color text was another one of those “it looks right, so it must be right” moments. The file had separate colors, but when I actually sliced it, Bambu Studio planned to use one filament. I had to keep the letters lined up with the body and tell the slicer which filament belonged to each. Only then did I check that both colors would go onto the holder itself, not just into waste.

The next surprise was the estimate: about eight hours and 226 filament swaps for one little holder on my single-nozzle setup. That was a slicer estimate, not a print I ran. I still like the two-color look, but seeing the cost made the default an easy decision: engraved text in one color, with the inlay there if someone wants it.

The same idea applies to sharing the design. I prepared a MakerWorld listing with real photos and rich text, and kept the fixed ASA profile separate from the customizable model. One gives someone a known set of slicer settings for a fixed size; the other generates geometry for measurements they enter. Reopening the saved draft checks what the site actually kept. It doesn't tell me whether every Customizer download will slice or fit.

## 5. Save what I'd otherwise have to explain again

If you're wondering what I mean by **agents** and **skills**, I think of an agent as the job I'm asking for and a skill as the instructions it can pull out to do that job. I go to my CAD Builder when the clip needs to change shape. I go to my 3D Print Operator when I want to know whether I can print that shape the way I intended. I don't need either one to do everything, and neither replaces me trying the part on the collar.

The skills are where I keep the checks I've learned to ask for. If I change a clip, rebuild the export and inspect the section that changed. If I save a listing, reopen it before calling it done. I keep those methods in my own setup; I don't need to publish my complete agent or skill definitions to explain the process.

One of the most useful prompts I give an agent is something I ask near the end of a project, while the failed attempts and fixes are still fresh:

> Let's review what we've done so far and what we learned. Incorporate the lessons that will help on future projects into the relevant agents and skills. Keep project-specific decisions with the project.

The important part is asking it to update the instructions, not just give me a recap in chat. Take that two-color print: before, seeing both colors in the file looked like a good enough check. Now I want my Print Operator to confirm that the slicer will put both filaments on the part itself. A filament change at the purge tower doesn't count. I shouldn't have to remember to ask for that again on the next project.

There's a useful line between a project decision and a reusable lesson. “Use the 10 mm gap for this strap” belongs with the holder. “Compare gap sizes on a small coupon before printing the whole part” belongs in the workflow for my next design.

## If you're trying this for the first time

Pick something you can measure that's already on your desk. A clip for a cable is a good example. Don't start with the whole desk organizer. Measure the cable and pick one question: how wide should the clip opening be so I can get the cable in without it slipping back out?

> Make me two small test clips for this cable. Keep the inside size the same and vary only the opening. Label them so I can tell them apart after printing.

Try both and tell the AI what happened. “The cable went in easily, but it slipped back out” gives you somewhere to go on the next pass. You don't need my full setup or a library of skills to start. The loop is the part worth trying: make a small change, check it against something real, and use what you learn to decide what to do next.

