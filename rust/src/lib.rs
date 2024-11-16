pub mod rust_test_node;
pub mod enemy_spawner;

use godot::prelude::*;

struct MyExtension;

#[gdextension]
unsafe impl ExtensionLibrary for MyExtension {}
