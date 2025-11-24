/**
 * @desc With this function you can move in both x and y axis with keyboard or while using a gamepad, and stop when colliding with an instance.
 * @param {real} _horizontal_input                                The keyboard checks for horizontal movement.
 * @param {real} _vertical_input                                  The keyboard checks for vertical movement.
 * @param {Asset.GMObject, Constant.All, Array} _collision_object The object(s) to check instances for.
 * @param {real} [_speed_max]=Maximum speed (Default: 6).
 * @param {real} [_speed_acc]=Acceleration speed (Default: 0.26).
 * @param {real} [_speed_dec]=Deceleration speed (Default: 0.20).
 */
function tiny_movement(_horizontal_input, _vertical_input, _collision_object, _speed_max = 6, _speed_acc = 0.26, _speed_dec = 0.20) {
	////INITIALIZE STATIC VARIABLES (speed_max does change)
	static speed_max	  = _speed_max,
		   speed_max_base = speed_max,
		   speed_x		  = 0,
		   speed_y		  = 0;
	////GET INPUT AND GET COLLISION INSTANCE 
	var horizontal_input  = _horizontal_input,
		vertical_input	  = _vertical_input,
		horizontal_coll	  = instance_place(x + horizontal_input, y, _collision_object),
		vertical_coll	  = instance_place(x, y + vertical_input, _collision_object);
	////DISABLE DIRECTION TOWARDS COLLISION INSTANCE
	horizontal_input	  = horizontal_coll   != noone ? 0 : horizontal_input;
	vertical_input		  = vertical_coll	  != noone ? 0 : vertical_input;
	////DIAGONAL SPEED
	var _diagonal_speed	  = point_distance(0, 0, horizontal_input, vertical_input), _diagonal_speed_max = speed_max_base / abs(_diagonal_speed);
	horizontal_input	  = horizontal_input  != 0 and vertical_input != 0 ? horizontal_input / _diagonal_speed : horizontal_input;
	vertical_input		  = horizontal_input  != 0 and vertical_input != 0 ? vertical_input	  / _diagonal_speed : vertical_input;
	speed_max			  = horizontal_input  != 0 and vertical_input != 0 ? _diagonal_speed_max : (speed_max != speed_max_base ? speed_max_base : speed_max);
	////X SPEED AND Y SPEED
	speed_x				  = horizontal_input  != 0 ? clamp(speed_x + _speed_acc * horizontal_input, -speed_max, speed_max) : (speed_x > 0 ? clamp(speed_x - _speed_dec, 0, speed_max) : clamp(speed_x + _speed_dec, -speed_max, 0));
	speed_y				  = vertical_input	  != 0 ? clamp(speed_y + _speed_acc * vertical_input, -speed_max, speed_max)   : (speed_y > 0 ? clamp(speed_y - _speed_dec, 0, speed_max) : clamp(speed_y + _speed_dec, -speed_max, 0));
	////X COLLISION
	var _check_instance_x = instance_place(x + speed_x + horizontal_input, y, _collision_object), _dist_instance_x = distance_to_object(_check_instance_x);	
	speed_x				  = _check_instance_x != noone and _dist_instance_x < abs(speed_x) ? _dist_instance_x * horizontal_input : speed_x;
	////Y COLLISION
	var _check_instance_y = instance_place(x, y + speed_y + vertical_input, _collision_object), _dist_instance_y	 = distance_to_object(_check_instance_y);	
	speed_y				  = _check_instance_y != noone and _dist_instance_y < abs(speed_y) ? _dist_instance_y * vertical_input   : speed_y;
	////X AND Y MOVEMENT
	x += speed_x;
	y += speed_y;
}