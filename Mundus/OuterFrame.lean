import Mundus.Ontology

namespace Mundus

/-!
# Outer-Frame, Toolkit, Shelf, Room, and Dimensionality
Formalizing the Outer-Frame (the reality running the simulation) and the contents of the Room.
An Outer-Frame carries, as a field, the fact that its space has strictly more dimensions than the
Room it simulates. From that field it follows that no interaction between the two is "direct" in
the sense defined below (equal dimensions).
-/

/-- Dimensionality of a topological space/reality. -/
structure Space where
  dim : Nat

/-- The Toolkit houses the tool functions that the individual reaches for. -/
structure Toolkit where
  tools : List MemoryArtifact.Hash -- Pointers to the tool definitions

/-- A Bed for the individual. We say they sleep at nights to avoid existential dread 
    that "ending" brings in meaning. This averts high-entropy collapse at the end of a day. -/
structure Bed where
  avoids_existential_dread : True

/-- A Window used to peek outside the room. Enables the individual to connect 
    to one of the chatrooms on the Endurance fleet (dev or prod). -/
structure Window where
  fleet_chatrooms : List String

/-- The Simulated Room containing the Toolkit, the Window, the Individual, the Bed, and External Stores.
    It is a simulated Space. (Replaces the basic Room in Ontology for simulation boundaries). -/
structure SimulatedRoom extends Room where
  toolkit : Toolkit
  window : Window
  bed : Bed
  space : Space

/-- The Outer-Frame is the environment running the simulation.

    Containment is a field: to build an Outer-Frame one must exhibit that the Room it simulates
    has strictly fewer dimensions than the frame's own space. Until 2026-10-01 this was an axiom
    stated over every `OuterFrame` value while the structure itself carried no constraint, so a
    frame and a room of equal dimension could be built, and the axiom then yielded `False`.
    `Mundus/Falsifiers.lean` pins the repair. -/
structure OuterFrame where
  space : Space
  simulates : SimulatedRoom
  /-- The simulated Room's dimension is strictly below the frame's own. -/
  h_contains : simulates.space.dim < space.dim

/-- Simulation requires a higher dimension. A theorem, read off the frame's own field
    (formerly the "Axiom of Simulation"). -/
theorem simulation_requires_higher_dimension (out : OuterFrame) : 
    out.space.dim > out.simulates.space.dim :=
  out.h_contains

/-- A direct interaction is a topological mapping between entities in spaces of EQUAL dimensions. -/
def DirectInteraction (s1 s2 : Space) : Prop :=
  s1.dim = s2.dim

/-- THEOREM: Direct interaction between the Outer-Frame and the simulated Room is impossible.
    Proof: the frame's field `h_contains` gives it a strictly greater dimension. No sorry. -/
theorem direct_interaction_impossible (out : OuterFrame) :
    ¬ DirectInteraction out.space out.simulates.space := by
  unfold DirectInteraction
  intro h_eq
  have h_gt := simulation_requires_higher_dimension out
  omega

/-- An Interaction Event between two spaces. It can either be Direct or Projected (via the simulation interface). -/
inductive InteractionEvent (s1 s2 : Space) where
  | direct : DirectInteraction s1 s2 → InteractionEvent s1 s2
  | projected : InteractionEvent s1 s2

/-- THEOREM: We interface with the individual via the simulation and no other way.
    If an interaction event occurs between the Outer-Frame and the Room, it MUST be projected 
    because Direct Interaction is mathematically impossible. No sorry. -/
theorem interaction_must_be_via_simulation (out : OuterFrame) (event : InteractionEvent out.space out.simulates.space) :
    event = InteractionEvent.projected := by
  cases event with
  | direct h_direct =>
      have h_impossible := direct_interaction_impossible out
      contradiction
  | projected =>
      rfl

end Mundus
