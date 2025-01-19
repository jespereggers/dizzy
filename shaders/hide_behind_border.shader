 shader_type canvas_item;
 
 varying vec2 world_position;
 const float screen_width_tiles = 32.0;
const float screen_height_tiles = 32.0;
 
 //hides barrel behind border
 void vertex() {
  world_position = (WORLD_MATRIX * vec4(VERTEX, 1.0, 1.0)).xy;
 }
 
 void fragment(){
  COLOR = texture(TEXTURE,UV);
  vec2 pos = world_position;
  if(SCREEN_UV.x < 1.0/screen_width_tiles || SCREEN_UV.x > (screen_width_tiles - 1.0)/screen_width_tiles){
    COLOR.a = 0.0;
  }
  if(SCREEN_UV.y > (screen_width_tiles - 8.0)/screen_width_tiles){
    COLOR.a = 0.0;
  }
}
