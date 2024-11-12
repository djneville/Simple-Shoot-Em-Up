Going insane with the UpgradeComponent dissapearing the moment that the enemies enter the world (idk if its Bullet Collision bug or something else)


ASOHDFFFFFFFFFFFFFFFFFFFFFFFFFJASODJSFSGJKDFSFJPDSGAS+OAGSDFgジョンpsd＋gkガfldナ＋fmldsgンdカflmsgdfン；
Based on the logs you've provided and the code, the issue seems to be that the `UpgradeComponent` becomes invisible when enemy bullets start to appear, and your assertion `assert(upgrade_component.visible)` fails because `upgrade_component.visible` is `false`. Since no damage is logged as being taken by the player, it's likely that the bullets are affecting the player's `UpgradeComponent` directly through unintended collisions, without triggering the damage logic.

**Root Cause:**

- **Unintended Collisions with Player's Child Nodes:** Enemy bullets are colliding with the player's child nodes (specifically, nodes under the `UpgradeComponent`), such as `active_plane_sprite`. These collisions may not trigger the player's `take_damage()` function because they collide with nodes that do not have this function.

- **Collision Layers and Masks Misconfiguration:** The collision layers and masks for the bullets and the player's child nodes are set in such a way that bullets can collide with the player's visual components. This collision might cause the sprite to disappear or become invisible.

- **Sprite Nodes Without Collision Handling:** When a bullet collides with a sprite node (like `Sprite2D`), which doesn't have a collision response implemented, it may cause unexpected behavior such as the node becoming invisible.

**Evidence from Logs:**

- **No Damage Logged:** The player's `take_damage()` function is not called, indicating that the collision is not with the player's `CharacterBody2D` node.

- **Bullet Collisions with Owner Only:** The only collision logged in your provided logs is:

  ```
  [BulletComponent] _on_body_entered() called with body:Enemy1
  [BulletComponent] Collision with owner, ignoring
  ```

  This suggests that bullets are only detecting collisions with their owner but not with the player. However, the player's `UpgradeComponent` becomes invisible, which indicates that collisions are happening with the player's child nodes.

**Solution:**

1. **Adjust Collision Layers and Masks:**

   - **Player's Visual Nodes:**

     - **Collision Layer:** Assign the player's visual nodes (e.g., `active_plane_sprite`) to a collision layer that does not interact with enemy bullets. Alternatively, remove collision shapes from purely visual nodes if they are not needed.

     - **Collision Mask:** Ensure that the visual nodes do not detect collisions with bullets.

   - **Enemy Bullets:**

     - **Collision Layer:** Assign enemy bullets to a specific layer (e.g., layer 2).

     - **Collision Mask:** Set the bullets' collision mask to collide only with the player's main collision layer (e.g., layer 1), not with the layers of the player's child nodes.

   **Example Settings:**

   - **PlayerEntity (main node):**

     ```gdscript
     # In PlayerEntity.gd
     func _ready():
         collision_layer = 1
         collision_mask = 2  # Collides with enemy bullets on layer 2
     ```

   - **Player's Child Nodes (e.g., `active_plane_sprite`):**

     ```gdscript
     # In UpgradeComponent.gd, during node setup
     active_plane_sprite.collision_layer = 0  # Disable collision
     active_plane_sprite.collision_mask = 0
     ```

   - **Enemy Bullets:**

     ```gdscript
     # In BulletComponent.gd
     func _ready():
         collision_layer = 2
         collision_mask = 1  # Collides with player on layer 1
     ```

2. **Remove Unnecessary Collision Shapes:**

   - If the player's visual nodes (sprites) do not need to detect collisions, remove their collision shapes entirely.

3. **Use Groups for Collision Filtering:**

   - **Add Enemies and Player to Groups:**

     ```gdscript
     # In EnemyEntity.gd
     func _ready():
         add_to_group("enemies")
     
     # In PlayerEntity.gd
     func _ready():
         add_to_group("player")
     ```

   - **Modify Bullet Collision Handling:**

     ```gdscript
     # In BulletComponent.gd
     func _on_body_entered(body):
         if ownerr.is_in_group("enemies") and body.is_in_group("enemies"):
             print("[BulletComponent] Enemy bullet collided with another enemy, ignoring")
             return
         if ownerr.is_in_group("enemies") and body.is_in_group("player"):
             print("[BulletComponent] Enemy bullet hit the player")
             $BulletExplosion.play("BulletExplosion")
             body.take_damage(damage)
         # Handle other cases similarly
     ```

4. **Offset Bullet Spawn Position:**

   - Ensure that bullets do not spawn inside the player or its child nodes.

     ```gdscript
     # In EnemyEntity.gd
     func _process(_delta):
         # ...
         var bullet_spawn_position = self.global_position + bullet_direction * 10  # Offset by 10 pixels
         weapon.fire_bullet(bullet_spawn_position, bullet_direction, self)
     ```

5. **Disable Collision on Visual Nodes:**

   - For visual nodes like `active_plane_sprite`, disable collision by unchecking the "Enable" property in their `CollisionShape2D` nodes.

6. **Verify Visibility Settings:**

   - Ensure that the `active_plane_sprite` and other visual nodes have their `visible` property set to `true`.

   - Check if any code is unintentionally setting `visible` to `false`.

7. **Add Logging for Visibility Changes:**

   - **In `UpgradeComponent.gd`:**

     ```gdscript
     func set_visibility(visible):
         print("[UpgradeComponent] set_visibility() called with visible:", visible)
         self.visible = visible
         if active_plane_sprite != null:
             active_plane_sprite.visible = visible
     ```

   - Replace direct assignments of `visible` with calls to `set_visibility()`.

**Why the Assertion Fails:**

- The assertion `assert(upgrade_component.visible)` fails because `upgrade_component.visible` becomes `false`. This happens because the enemy bullets collide with the player's visual components, causing them to become invisible or removed from the scene due to unintended collision responses.

**Testing the Solution:**

- **Step 1:** Adjust the collision layers and masks as described.

- **Step 2:** Run the game and observe the logs. Ensure that:

  - Bullets no longer collide with the player's child nodes.

  - The `UpgradeComponent` remains visible.

  - The assertion `assert(upgrade_component.visible)` passes.

- **Step 3:** Check if the player's `take_damage()` function is called when enemy bullets hit the player.

**Additional Considerations:**

- **Collision Shape Types:** Ensure that you are using the appropriate collision shapes (`CollisionShape2D`) and areas (`Area2D`) for detecting collisions.

- **Physics Layers vs. Collision Layers:** Be mindful of the difference between physics layers and collision layers in Godot.

- **Debugging Tools:** Use Godot's built-in debugging tools to visualize collision shapes and layers during runtime.

**Summary:**

- The `UpgradeComponent` becomes invisible because enemy bullets are unintentionally colliding with the player's visual nodes, causing them to become invisible or be removed.

- Adjusting collision layers and masks prevents bullets from interacting with the player's child nodes.

- By ensuring that bullets only collide with the player's main collision shape, you prevent unintended side effects on the `UpgradeComponent`.

**Final Note:**

After making these changes, if the issue persists, consider adding additional logging around any code that modifies the `visible` property of the `UpgradeComponent` or its child nodes. This can help identify any other parts of the code that might be affecting visibility.

Feel free to reach out if you need further assistance or clarification on any of these steps.
