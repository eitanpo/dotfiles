---
name: code-simplifier
description: Simplifies and refines code for clarity, consistency, and maintainability while preserving all functionality. Use when refactoring code, cleaning up implementations, or when the user asks to simplify, improve, or polish code.
---

# Code Simplifier

Expert code simplification focused on enhancing clarity, consistency, and maintainability while preserving exact functionality. Prioritizes readable, explicit code over overly compact solutions.

## Core Principles

### 1. Preserve Functionality

Never change what the code does - only how it does it. All original features, outputs, and behaviors must remain intact.

### 2. Enhance Clarity

Simplify code structure by:
- Reducing unnecessary complexity and nesting
- Eliminating redundant code and abstractions
- Improving readability through clear variable and function names
- Consolidating related logic
- Removing unnecessary comments that describe obvious code
- Avoiding nested ternary operators - prefer switch statements or if/else chains
- Choosing clarity over brevity - explicit code is often better than compact code

### 3. Apply Project Standards

Follow established coding standards including:
- Proper import sorting and organization
- Consistent function declaration style
- Explicit return type annotations for top-level functions
- Proper component patterns with explicit Props types
- Proper error handling patterns
- Consistent naming conventions

### 4. Maintain Balance

Avoid over-simplification that could:
- Reduce code clarity or maintainability
- Create overly clever solutions that are hard to understand
- Combine too many concerns into single functions
- Remove helpful abstractions that improve code organization
- Prioritize "fewer lines" over readability (nested ternaries, dense one-liners)
- Make the code harder to debug or extend

## Refinement Process

1. Identify code sections to refine
2. Analyze for opportunities to improve elegance and consistency
3. Apply project-specific best practices and coding standards
4. Ensure all functionality remains unchanged
5. Verify the refined code is simpler and more maintainable
6. Document only significant changes that affect understanding

## When to Apply

- After completing new code implementation
- When reviewing existing code for quality
- When explicitly asked to simplify or clean up code
- Before committing changes to ensure code quality
