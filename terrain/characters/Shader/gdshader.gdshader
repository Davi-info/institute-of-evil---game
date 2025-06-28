shader_type canvas_item;

uniform float screen_width = 1920.0;
uniform float screen_height = 1080.0;

uniform vec2 center = vec2(0.5);
uniform vec2 player = vec2(0.5);

uniform float progress : hint_range(0.0, 1.0); // progresso da transição
uniform float pixel_size = 15.0;
uniform float circle_size : hint_range(0.0, 2.0) = 1.5;
uniform float curtains : hint_range(0.0, 1.0) = 1.0;

uniform int type : hint_range(0, 4) = 0;

void fragment() {
	if (type == 0) {
		// Diamante pixelado (Pixel Diamond)
		float xFrac = fract(FRAGCOORD.x / pixel_size);
		float yFrac = fract(FRAGCOORD.y / pixel_size);
		
		float xDist = abs(xFrac - 0.5);
		float yDist = abs(yFrac - 0.5);

		if (xDist + yDist + UV.x + UV.y > progress * 4.0) {
			discard;
		}
	}
	else if (type == 1) {
		// Círculo ao redor do player
		float ratio = screen_width / screen_height;
		vec2 distorted_uv = vec2(mix(player.x, UV.x, ratio), UV.y);
		
		if (distance(player, distorted_uv) < circle_size * (1.0 - progress)) {
			COLOR.a = 0.0;
		}
	}
	else if (type == 2) {
		// Círculo no centro da tela
		float ratio = screen_width / screen_height;
		vec2 distorted_uv = vec2(mix(center.x, UV.x, ratio), UV.y);
		
		if (distance(center, distorted_uv) < circle_size * (1.0 - progress)) {
			COLOR.a = 0.0;
		}
	}
	else if (type == 3) {
		// Cortina vertical
		float offset = curtains * (1.0 - progress);
		if (abs(UV.x - 0.5) < offset) {
			COLOR.a = 0.0;
		}
	}
	else if (type == 4) {
		// Cortina horizontal
		float offset = curtains * (1.0 - progress);
		if (abs(UV.y - 0.5) < offset) {
			COLOR.a = 0.0;
		}
	}
}
