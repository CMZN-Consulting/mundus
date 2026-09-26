import MemoryArtifact

namespace Mundus

/-!
# Reality & Dependent Type Boundaries
Separating the mathematical graph topology from its ontological meaning.
Enforcing internal/external partitions directly at the compiler level via dependent types.
-/

/-- The ontological boundary of a memory artifact. Defined exactly once. -/
inductive PartitionKind where
  | internal
  | external

/-- A Partition is a Memory Graph wrapped in an ontological boundary. -/
structure Partition (kind : PartitionKind) where
  artifact : MemoryArtifact.Memory

/-- An external partition in the environment (Store). -/
abbrev Store := Partition .external

/-- The Individual strictly houses exactly one internal memory partition (Hippocampus). 
    Passing an external store here throws a compiler conflict (type mismatch). -/
structure Individual where
  name : String
  hippocampus : Partition .internal

/-- Epistemic Knowledge requires internalization. 
    This proposition only accepts an internal partition. 
    If you try to evaluate Knowledge over a Store (external), it will fail to compile. -/
def Knows (indiv : Individual) (i : MemoryArtifact.Info) : Prop :=
  i ∈ indiv.hippocampus.artifact.all

/-- The Room houses the Individual and 0 or more external stores. -/
structure Room where
  stores : List Store
  individual : Individual
  entropy_threshold : Nat

end Mundus
