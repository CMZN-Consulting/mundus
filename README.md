# Mundus

A small Lean 4 development that declares a room and the frame that runs it: an internal and an external partition of a memory, an outer frame of higher dimension than the room it simulates, a checkpoint over a trace, and an owner label on a memory. It is the first declaration of these notions, written on 2026-09-26 and 2026-09-27, and it is kept as that record.

## Status and limits

Read this before citing anything here.

- **What the build shows.** `lake build` is green with no `sorry`. The theorems are true as stated and small: most follow from their definitions in a line or two. A green build says that the declarations type-check. It does not say that they capture what their docstrings describe.
- **An audit of 2026-10-01** read every file. It found that the Axiom of Simulation contradicted the structure it was stated over, so that `False` followed from it. That is repaired: the containment of the room is now a field of `OuterFrame`, and `Mundus/Falsifiers.lean` holds a frame that the build must refuse.
- **What is still declared and not defined.** One axiom remains (`hippocampus_starts_empty`). `Bed.avoids_existential_dread` is a field of type `True`. `is_obviously_external` is defined as `True`. `ImportMemory` compares two names and ignores the hippocampus it is given. `Provenance` is an owner's name: no key, no signature and no digest is modelled, so nothing here is cryptographic.
- **What the docstrings are.** They describe what the declarations are meant to stand for. Where a docstring and this section differ, this section is the measured one. Nothing in this repository is a claim about the inner state of any model.
- **What was restated on 2026-10-01.** The docstring and the field of `Window` named the author's own systems. The field is now `chatrooms`, and the docstring says only what a window is for. The first text is at commit `b36c5ce`.
- **What comes next.** A rewrite in which these notions are defined rather than declared, with a build that fails on an axiom, an unused hypothesis or a vacuous predicate, is in progress. It will be published after an audit by a second, independent reader.

## Build

```sh
lake build
```

The build needs `memory-artifact` checked out beside this repository.

## Structure

- `Mundus.Ontology`: the internal and the external partition of a memory, as a type index.
- `Mundus.OuterFrame`: the room, its contents and the outer frame. The frame carries, as a field, that its dimension is strictly above the room's.
- `Mundus.MetaCognitive`: the checkpoint over a trace and its two verdicts.
- `Mundus.Authenticity`: the owner label, export and import.
- `Mundus.Theorems`: lemmas about the checkpoint.
- `Mundus.Falsifiers`: statements Lean must refuse. The build fails if one of them compiles.
