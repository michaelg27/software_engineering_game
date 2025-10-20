extends Node3D

@onready var jump_particles: GPUParticles3D = $JumpSmoke

func emitJump():
	jump_particles.emitting = true
