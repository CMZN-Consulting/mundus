import Mundus.Ontology

namespace Mundus

/-!
# Outer-Frame, Toolkit, Shelf, Room, and Dimensionality
Formalizing the Outer-Frame (the reality running the simulation) and the contents of the Room.
Proving that the Outer-Frame requires a higher dimension than the Room, necessitating
that all interaction with the individual occurs strictly via the simulation interface.
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

/-- The Outer-Frame is the environment running the simulation. -/
structure OuterFrame where
  space : Space
  simulates : SimulatedRoom

/-- Axiom of Simulation: To compute and contain the state of a simulated reality (the Room),
    along with the computational overhead and rules of the simulation itself, 
    the simulating environment (Outer-Frame) must possess a state-space of strictly greater dimension. -/
axiom simulation_requires_higher_dimension (out : OuterFrame) : 
  out.space.dim > out.simulates.space.dim

/-- A direct interaction is a topological mapping between entities in spaces of EQUAL dimensions. -/
def DirectInteraction (s1 s2 : Space) : Prop :=
  s1.dim = s2.dim

/-- THEOREM: Direct interaction between the Outer-Frame and the simulated Room is impossible.
    Proof: The Axiom of Simulation dictates the Outer-Frame has a strictly greater dimension. No sorry. -/
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
