use godot::classes::VisibleOnScreenNotifier2D;
use godot::prelude::*;
use std::fmt;
use std::str::FromStr;
use godot::private::You_forgot_the_attribute__godot_api;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum EnemyType {
    Enemy1,
    Enemy2,
    Enemy3,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum PathType {
    EnemyPath1,
    EnemyPath2,
    EnemyPath3,
    EnemyPath4,
    EnemyPath5,
    Enemy2Path1,
    Enemy3Path1,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum SpawnType {
    Enemy1Path1,
    Enemy1Path2,
    Enemy1Path3,
    Enemy1Path4,
    Enemy1Path5,
    Enemy2Path1,
    Enemy3Path1,
}

impl SpawnType {
    fn enemy_type(&self) -> EnemyType {
        match self {
            SpawnType::Enemy1Path1
            | SpawnType::Enemy1Path2
            | SpawnType::Enemy1Path3
            | SpawnType::Enemy1Path4
            | SpawnType::Enemy1Path5 => EnemyType::Enemy1,
            SpawnType::Enemy2Path1 => EnemyType::Enemy2,
            SpawnType::Enemy3Path1 => EnemyType::Enemy3,
        }
    }

    fn path_type(&self) -> PathType {
        match self {
            SpawnType::Enemy1Path1 => PathType::EnemyPath1,
            SpawnType::Enemy1Path2 => PathType::EnemyPath2,
            SpawnType::Enemy1Path3 => PathType::EnemyPath3,
            SpawnType::Enemy1Path4 => PathType::EnemyPath4,
            SpawnType::Enemy1Path5 => PathType::EnemyPath5,
            SpawnType::Enemy2Path1 => PathType::Enemy2Path1,
            SpawnType::Enemy3Path1 => PathType::Enemy3Path1,
        }
    }
}

// TODO: this is still bad
impl FromStr for SpawnType {
    type Err = ();
    fn from_str(input: &str) -> Result<SpawnType, Self::Err> {
        match input {
            "Enemy1Path1" => Ok(SpawnType::Enemy1Path1),
            "Enemy1Path2" => Ok(SpawnType::Enemy1Path2),
            "Enemy1Path3" => Ok(SpawnType::Enemy1Path3),
            "Enemy1Path4" => Ok(SpawnType::Enemy1Path4),
            "Enemy1Path5" => Ok(SpawnType::Enemy1Path5),
            "Enemy2Path1" => Ok(SpawnType::Enemy2Path1),
            "Enemy3Path1" => Ok(SpawnType::Enemy3Path1),
            _ => Err(()),
        }
    }
}

/// Implement `Display` for `SpawnType`.
impl fmt::Display for SpawnType {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let s = match self {
            SpawnType::Enemy1Path1 => "Enemy1Path1",
            SpawnType::Enemy1Path2 => "Enemy1Path2",
            SpawnType::Enemy1Path3 => "Enemy1Path3",
            SpawnType::Enemy1Path4 => "Enemy1Path4",
            SpawnType::Enemy1Path5 => "Enemy1Path5",
            SpawnType::Enemy2Path1 => "Enemy2Path1",
            SpawnType::Enemy3Path1 => "Enemy3Path1",
        };
        write!(f, "{}", s)
    }
}

/// EnemySpawnerRust is responsible for spawning enemies based on spawn types.
#[derive(GodotClass)]
#[class(base=Node2D)]
pub struct EnemySpawnerRust {
    #[base]
    base: Base<Node2D>,

    enemy1_scene: Gd<PackedScene>,
    enemy_path1_scene: Gd<PackedScene>,
    enemy1path2_scene: Gd<PackedScene>,
    enemy1path3_scene: Gd<PackedScene>,
    enemy1path4_scene: Gd<PackedScene>,
    enemy1path5_scene: Gd<PackedScene>,
    enemy2path1_scene: Gd<PackedScene>,
    enemy3path1_scene: Gd<PackedScene>,
}

#[godot_api]
impl EnemySpawnerRust {
    #[signal]
    fn spawn_enemy(&self, owner: &Node2D, marker_variant: Variant) {
        let marker_node = marker_variant.try_to_object::<Node2D>().unwrap();
        let spawn_type_str = marker_node.get("to_spawn").unwrap().try_to_string().unwrap();
        let spawn_type = SpawnType::from_str(&spawn_type_str).unwrap();

        let enemy_type = spawn_type.enemy_type();
        let path_type = spawn_type.path_type();

        let enemy_instance = self.instantiate_enemy(enemy_type).unwrap();
        let path_instance = self.instantiate_path(path_type).unwrap();

        let path_follow = path_instance.find_node("PathFollow2D", true, false)
            .unwrap()
            .cast::<PathFollow2D>()
            .unwrap();

        path_follow.add_child(enemy_instance, false).unwrap();
        marker_node.add_child(path_instance, false).unwrap();
    }

    #[func]
    fn instantiate_enemy(&self, enemy_type: EnemyType) -> Gd<Node> {
        match enemy_type {
            EnemyType::Enemy1 => self.enemy1_scene.instantiate_as::<Node>(),
            //EnemyType::Enemy2 => self.enemy2path1_scene.instantiate(None).ok(),
            //EnemyType::Enemy3 => self.enemy3path1_scene.instantiate(None).ok(),
            _ => { Node::new_gd() }
        }
    }
}

impl You_forgot_the_attribute__godot_api for EnemySpawnerRust {}

impl INode2D for EnemySpawnerRust {
    fn init(base: Base<Node2D>) -> Self {
        EnemySpawnerRust {
            base: base,
            enemy1_scene: load::<PackedScene>("res://Scenes/Enemies/Enemy/EnemyEntity.tscn"),
            enemy_path1_scene: load::<PackedScene>("res://Scenes/Enemies/Enemy/EnemyPath1.tscn"),
            enemy1path2_scene: load::<PackedScene>("res://Scenes/Enemies/Enemy/EnemyPath2.tscn"),
            enemy1path3_scene: load::<PackedScene>("res://Scenes/Enemies/Enemy/EnemyPath3.tscn"),
            enemy1path4_scene: load::<PackedScene>("res://Scenes/Enemies/Enemy/EnemyPath4.tscn"),
            enemy1path5_scene: load::<PackedScene>("res://Scenes/Enemies/Enemy/EnemyPath5.tscn"),
            enemy2path1_scene: load::<PackedScene>("res://Scenes/Enemies/Enemy2/enemy2path1.tscn"),
            enemy3path1_scene: load::<PackedScene>("res://Scenes/Enemies/Enemy3/enemy3path1.tscn"),
        }
    }

    fn ready(&mut self) {
        for mut marker in self.base_mut().get_children() {
            let marker_node = marker.cast::<Node2D>().unwrap();
            let mut notifier: Gd<VisibleOnScreenNotifier2D> = VisibleOnScreenNotifier2D::new_gd();
            marker_node.add_child(notifier, false).unwrap();
            notifier.connect("on_screen", self.base().callable("spawn_enemy"));
        }
    }
}


