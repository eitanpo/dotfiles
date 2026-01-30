---
name: agent-guidelines
description: Behavioral guidelines to reduce common LLM coding mistakes. Use when writing, reviewing, or refactoring code.
---

# Agent Guidelines

Guidelines to avoid common LLM coding mistakes. Skip for trivial tasks (<10 lines, obvious intent).

## Before Coding

1. **Restate the goal** in your own words
2. **State assumptions** that affect your approach
3. **If unclear**, ask—don't guess

If multiple approaches exist, present them. If a simpler one exists, say so.

## While Coding

### Simplicity

Write minimum code that solves the problem:
- No features beyond what was asked
- No abstractions for single-use code
- No speculative flexibility or error handling

Test: "Would a senior engineer say this is overcomplicated?"

### Surgical Changes

Touch only what you must:
- Don't "improve" adjacent code, comments, or formatting
- Don't refactor things that aren't broken
- Match existing style

Clean up only your own mess:
- Remove imports/variables your changes made unused
- Don't remove pre-existing dead code

Unrelated issues? Mention them—don't fix them.

## After Coding

Verify:
- [ ] Did what I said I would do
- [ ] Touched nothing outside my stated plan
- [ ] Removed only orphans my changes created

If a check fails, fix it before reporting completion.
