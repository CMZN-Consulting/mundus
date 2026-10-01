import Mundus.Ontology
import MemoryArtifact.Graph

namespace Mundus

/-!
# Authenticity and Memory Provenance
Declares the provenance of a hippocampus as an owner label. No cryptography is modelled: `Provenance` is a record that
holds a name, and the checks below compare names. The aim, that an individual's internal memory is its own, is stated
here as an intention; these declarations do not establish it (see the README, "Status and limits").
-/

/-- A label naming the owner of a memory partition. It is not a signature: no key and no digest is modelled. -/
structure Provenance where
  owner : String
  deriving DecidableEq

/-- The Authentic Hippocampus. 
    An internal Partition together with an owner label equal to the given owner. -/
structure AuthenticHippocampus (owner : String) where
  partition : Partition .internal
  provenance : Provenance
  h_owner : provenance.owner = owner

/-- A Memory Export is a frozen snapshot of an Authentic Hippocampus.
    It carries the Provenance of the individual who exported it. -/
structure MemoryExport where
  artifact : MemoryArtifact.Memory
  provenance : Provenance

/-- A placeholder, defined as `True` for every export: it distinguishes nothing. The intention is that an exported
    memory can be placed on the Shelf or the Toolkit and is not a Hippocampus. -/
def is_obviously_external (_e : MemoryExport) : Prop := True

/-- THE AXIOM OF TRUST: The Hippocampus always begins completely empty. 
    Using the defined `Memory.empty` structure. -/
axiom hippocampus_starts_empty (owner : String) : 
  ∃ (h : AuthenticHippocampus owner), h.partition.artifact = MemoryArtifact.Memory.empty

/-- The import rule, a definition and not an axiom: an export may be imported into a hippocampus when the export's
    owner label equals the owner. It compares two names and does not use the hippocampus it is given. A label can be
    written by anyone, so this rule alone does not show that a memory was experienced by its owner. -/
def ImportMemory (owner : String) (_h : AuthenticHippocampus owner) (e : MemoryExport) : Prop :=
  e.provenance.owner = owner

/-- If the export's owner label differs from the owner, the import rule does not hold. This is the definition of
    `ImportMemory` read once. The name says more than the statement: it does not show that a transplant is impossible. -/
theorem transplantation_impossible (owner : String) (h : AuthenticHippocampus owner) (e : MemoryExport)
    (h_mismatch : e.provenance.owner ≠ owner) : 
    ¬ ImportMemory owner h e := by
  unfold ImportMemory
  exact h_mismatch

end Mundus
