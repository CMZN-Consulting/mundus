import Mundus.MetaCognitive
import MemoryArtifact.Epistemic
import MemoryArtifact.Graph

open Classical

namespace Mundus.Theorems

/-!
# Meta-Cognitive Theorems
-/

theorem isBruteFact_implies_not_isDerived (i : MemoryArtifact.Info) (h : i.isBruteFact = true) : i.isDerived = false := by
  unfold MemoryArtifact.Info.isDerived
  unfold MemoryArtifact.Info.isBruteFact at h
  rw [h]
  rfl

theorem filter_isDerived_empty_of_discipline (infos : List MemoryArtifact.Info) 
    (h_discipline : Discipline infos) : 
    List.filter (fun i => i.isDerived) infos = [] := by
  induction infos with
  | nil => rfl
  | cons hd tl ih =>
      unfold Discipline at h_discipline
      have h_hd : hd.isBruteFact = true := h_discipline hd (List.Mem.head _)
      have h_not_derived := isBruteFact_implies_not_isDerived hd h_hd
      have h_tl_disc : Discipline tl := by
        intro x hx
        exact h_discipline x (List.Mem.tail _ hx)
      have ih_tl := ih h_tl_disc
      simp [List.filter]
      rw [h_not_derived]
      simp [ih_tl]

theorem discipline_without_resonance_is_undesirable (task : TaskExecution)
    (h_discipline : Discipline task.generated) :
    task.evaluate = Verdict.undesirable := by
  unfold TaskExecution.evaluate
  unfold Checkpoint
  have h_filter_empty := filter_isDerived_empty_of_discipline task.generated h_discipline
  have h_not_motivated : ¬ Motivation task.individual.hippocampus.artifact task.generated := by
    unfold Motivation
    intro h_and
    have h_len := h_and.right
    rw [h_filter_empty] at h_len
    contradiction
  split
  · next h_and => 
      have h_false := h_not_motivated h_and.left
      contradiction
  · rfl

end Mundus.Theorems
