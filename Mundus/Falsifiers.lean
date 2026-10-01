import Mundus.OuterFrame

namespace Mundus.Falsifiers

/-!
# Falsifiers
Each block states something that must NOT be buildable or provable, and checks that Lean refuses it.
If a later change makes one of these compile, the build fails here.
-/

/-- A room of dimension 0 (the audit's witness W1 of 2026-10-01). -/
def room0 : SimulatedRoom :=
  { stores := [], individual := { name := "x", hippocampus := ⟨MemoryArtifact.Memory.empty⟩ },
    entropy_threshold := 0, toolkit := ⟨[]⟩, window := ⟨[]⟩, bed := ⟨trivial⟩, space := ⟨0⟩ }

/-- No Outer-Frame has the dimension of the Room it simulates. -/
theorem no_frame_of_equal_dimension (out : OuterFrame) :
    out.space.dim ≠ out.simulates.space.dim :=
  Nat.ne_of_gt out.h_contains

/-- The type is not empty: a frame of dimension 1 around `room0` is built, with its proof. -/
def frame1 : OuterFrame :=
  { space := ⟨1⟩, simulates := room0, h_contains := by decide }

/-! A frame of dimension 0 around `room0` is refused: the containment field asks for `0 < 0`.
This is the frame from which the former axiom yielded `False`. -/

/--
error: Tactic `decide` proved that the proposition
  room0.space.dim < { dim := 0 }.dim
is false
-/
#guard_msgs in
example : OuterFrame :=
  { space := ⟨0⟩, simulates := room0, h_contains := by decide }

end Mundus.Falsifiers
