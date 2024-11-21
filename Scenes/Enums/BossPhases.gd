extends Resource
class_name BossPhase

enum PHASE { ENTRY, PHASE_ONE, TRANSITION, PHASE_TWO, DYING }

@export var phase: PHASE
