Going insane with the UpgradeComponent dissapearing the moment that the enemies enter the world (idk if its Bullet Collision bug or something else)
**Possible Cause:**

When bullets are instantiated, they might be colliding with the player's collision shape immediately upon creation. This collision can trigger unintended side effects, such as affecting the `UpgradeComponent`'s visibility or state, even if no damage is logged.

Here's why this might happen:

- **Collision Layers and Masks:** If the bullets and the player share collision layers and masks, bullets can collide with the player upon spawning.
- **Owner Reference Mismatch:** The bullet's `ownerr` variable may not correctly identify the player as its owner due to node hierarchy differences.
- **Immediate Overlap:** Bullets spawned at the player's position might overlap with the player's collision shape, causing an immediate collision.

**How to Diagnose the Issue:**

1. **Check Collision Layers and Masks:**

   - Ensure that the player's collision shape and the bullets are on different collision layers.
   - Set the bullets' collision mask so they do not detect collisions with the player.

2. **Log Collision Events:**

   - Add print statements in the bullet's `_on_body_entered` function to see which bodies it collides with.
   - Verify whether the bullets are colliding with the player upon creation.

3. **Verify Owner Matching:**

   - Confirm that the `ownerr` variable in the `BulletComponent` correctly references the player.
   - Check if the `body` in `_on_body_entered` matches `ownerr` when the bullet collides with the player.

**Proposed Solution:**

**1. Adjust Collision Layers and Masks**

- **For Bullets:**

  - **Collision Layer:** Assign bullets to a specific layer (e.g., layer 2).
  - **Collision Mask:** Set the collision mask to collide only with enemies (e.g., mask 3).

- **For Player:**

  - **Collision Layer:** Keep the player on its own layer (e.g., layer 1).
  - **Collision Mask:** Ensure the player does not collide with bullets from its own weapon.

**Example Settings:**

```gdscript
# In BulletComponent.gd
func _ready():
    collision_layer = 2
    collision_mask = 4  # Assuming enemies are on layer 3

# In PlayerEntity.gd
func _ready():
    collision_layer = 1
    collision_mask = 4  # Assuming enemies are on layer 3
```

**2. Modify Bullet Collision Handling**

Update the bullet's `_on_body_entered` function to check for group membership or other identifiers instead of direct node comparison:

```gdscript
func _on_body_entered(body):
    if body == ownerr:
        return  # Ignore collision with the shooter
    if body.is_in_group("player"):
        return  # Ignore collision with the player group
    $BulletExplosion.play("BulletExplosion")
    body.take_damage(damage)
```

**3. Offset Bullet Spawn Position**

Slightly offset the bullet's spawn position so it doesn't start within the player's collision shape:

```gdscript
func fire_bullet(start_position: Vector2, direction: Vector2, shooter: Node):
    if shoot_timer.time_left == 0:
        var new_bullet = bullet_scene.instantiate()
        get_tree().current_scene.add_child(new_bullet)
        # Offset the bullet's position by a small amount in the shooting direction
        var spawn_offset = direction.normalized() * 10  # Adjust the offset as needed
        new_bullet.global_position = start_position + spawn_offset
        new_bullet.initialize(direction, bullet_speed, bullet_damage, shooter)
        shoot_timer.start()
        $MuzzleFlash.play("MuzzleFlashAnimation")
```

**4. Confirm Owner Reference**

Ensure that the `ownerr` variable in the `BulletComponent` correctly references the player:

- **In `WeaponComponent.gd`:**

  ```gdscript
  func fire_bullet(start_position: Vector2, direction: Vector2, shooter: Node):
      # Pass the correct shooter reference
      new_bullet.initialize(direction, bullet_speed, bullet_damage, shooter)
  ```

- **In `BulletComponent.gd`:**

  ```gdscript
  func initialize(new_direction: Vector2, new_speed: float, new_damage: int, shooter: Node):
      direction = new_direction.normalized()
      speed = new_speed
      damage = new_damage
      ownerr = shooter
  ```

**5. Use Groups for Collision Checks**

Add the player to a "player" group and modify the bullet's collision handling:

- **Add Player to Group:**

  ```gdscript
  # In PlayerEntity.gd
  func _ready():
      add_to_group("player")
  ```

- **Modify Bullet Collision Handling:**

  ```gdscript
  func _on_body_entered(body):
      if body.is_in_group("player"):
          return  # Ignore collision with the player group
      $BulletExplosion.play("BulletExplosion")
      body.take_damage(damage)
  ```

**6. Verify Collision Shapes**

Ensure that the collision shapes for the player and bullets are correctly set up and not overlapping unintentionally.

**Why Logs Might Not Show Damage:**

- **Silent Failures:** If the player's `take_damage` function is not logging or if invulnerability frames prevent damage without logging it.
- **Collision Detection Issues:** Collisions may affect the `UpgradeComponent` without explicitly triggering damage logs.

**Summary:**

The invisibility of the `UpgradeComponent` when bullets appear is likely due to unintended collisions between the bullets and the player upon bullet creation. Adjusting collision layers and masks, verifying owner references, and modifying collision handling logic should resolve the issue.

Feel free to ask if you need further clarification or assistance implementing these changes.
