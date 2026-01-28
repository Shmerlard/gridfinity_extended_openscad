include <../module_gridfinity_sliding_lid.scad>
include <../gridfinity_constants.scad>
include <../module_gridfinity_block.scad>

include <../module_gridfinity_cup.scad>

/* [Debug] */
debug_target = "Lid"; // ["Lid", "Support", "Cavity", "Cup", "PartitionedCavity"]

render_cup = false;
render_support = false;
render_cavity = false;
render_partitioned_cavity = false;
render_grid_block = false;
render_sliding_lid = true;
render_sliding_lid_support = true;
render_sliding_lid_cavity = true;

cup_position = [0,0];
partitioned_cavity_position = [0,0,0];
grid_block_position = [0,0,0];
sliding_lid_position = [0,0,0];
sliding_lid_support_position = [0,0,0];
sliding_lid_cavity_position = [0,0,0];

$fn = 64;
echo("debug_gridfinity_sliding_lid is enabled");

// Common Debug Parameters
d_num_x = 4;
d_num_y = 3;
d_wall_thickness = 0.8;
d_lid_thickness = 1.6;
d_clearance = 0.1;

// Re-create settings list for the helper modules
debug_settings = SlidingLidSettings(
  slidingLidEnabled = true,
  slidingLidThickness = d_lid_thickness,
  slidingMinWallThickness = 0.4,
  slidingMinSupport = 0.8,
  slidingClearance = d_clearance,
  wallThickness = d_wall_thickness,
  slidingLidLipEnabled = true
);

if (debug_target == "Lid") {
  SlidingLid(
    num_x = d_num_x, 
    num_y = d_num_y,
    wall_thickness = d_wall_thickness,
    clearance = d_clearance,
    lidThickness = d_lid_thickness,
    lidMinSupport = 0.8,
    lidMinWallThickness = 0.4,
    limitHeight = true,
    lipStyle = "normal",
    lip_notches = true,
    lip_top_relief_height = 5, 
    addLiptoLid = true,
    cutoutEnabled = false,
    cutoutSize = [0,0],
    cutoutRadius = 0,
    cutoutPosition = [0,0]
  );
   // Calculate and print size 
   // (Using the simplified calculation from the module logic for display)
   lid_w = d_num_x * 42 - 0.4; // rough approx based on lidMinWallThickness logic
   lid_d = d_num_y * 42 - 0.4;
   echo("Estimated Lid Size:", lid_w, lid_d, d_lid_thickness);
   
} else if (debug_target == "Support") {
  // Mocking context variables usually provided by the cup module
  mock_inner_radius = 3.2; // roughly corner_radius - wall
  mock_zpoint = 10; 
  
  SlidingLidSupportMaterial(
    num_x = d_num_x, 
    num_y = d_num_y,
    wall_thickness = d_wall_thickness,
    sliding_lid_settings = debug_settings,
    innerWallRadius = mock_inner_radius,
    zpoint = mock_zpoint
  );
} 
if (render_sliding_lid_cavity) {
  above_lid_height = 0;
  translate(sliding_lid_cavity_position)
  SlidingLidCavity(
    num_x = d_num_x, 
    num_y = d_num_y,
    wall_thickness = d_wall_thickness,
    sliding_lid_settings = debug_settings,
    aboveLidHeight = above_lid_height
  );
} 
if (render_cup) {
    translate(cup_position)
  gridfinity_cup(
    width = d_num_x,
    depth = d_num_y,
    height = 3,
    wall_thickness = d_wall_thickness,
    sliding_lid_lip_enabled = true,
    sliding_lid_enabled = true,
    sliding_lid_thickness = d_lid_thickness,
    sliding_min_wall_thickness = 0.4,
    sliding_min_support = 0.8, 
    sliding_clearance = d_clearance,
    lip_settings = LipSettings(
        lipNotch = true,
        lip_style="normal"),
    filled_in = "disabled"
  );
}
if (render_partitioned_cavity) {
    // Need valid cup base settings for magnet calculations
    d_cupBase_settings = CupBaseSettings(
        magnetSize = [6.5, 2.4],
        screwSize = [3, 6],
        holeOverhangRemedy = 2,
        floorThickness = 1.2
    );
    translate(partitioned_cavity_position)
    partitioned_cavity(
      num_x = d_num_x,
      num_y = d_num_y,
      num_z = 3,
      wall_thickness = d_wall_thickness,
      cupBase_settings = d_cupBase_settings,
      sliding_lid_settings = debug_settings,
      lip_settings = LipSettings(lipNotch = false, lipStyle="reduced"),
      calculated_vertical_separator_positions = [],
      calculated_horizontal_separator_positions = [],
      finger_slide_settings = FingerSlideSettings(
          type = "none",
          radius = 10,
          walls = [0,0,0,0],
          lip_aligned = true),
      label_settings = LabelSettings(labelStyle="disabled")
    );
  if (render_grid_block){
    translate(grid_block_position)
    grid_block(
      num_x = d_num_x,
      num_y = d_num_y,
      num_z = 3,
      wall_thickness = d_wall_thickness,
      sliding_lid_settings = debug_settings,
      lip_settings = LipSettings(lipNotch = true, lipStyle="normal"),
      calculated_vertical_separator_positions = [],
      calculated_horizontal_separator_positions = [],
      finger_slide_settings = FingerSlideSettings(
          type = "none",
          radius = 10,
          walls = [0,0,0,0],
          lip_aligned = true),
      label_settings = LabelSettings(labelStyle="disabled")
    );
  }
}
