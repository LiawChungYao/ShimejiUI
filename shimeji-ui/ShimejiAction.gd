extends Resource

class_name ShimejiAction

# Define the properties
var name: String
var type: String
var action_class: String  # Changed from 'class' to 'action_class'
var border_type: String
var ie_offset_x: float
var ie_offset_y: float
var gravity: float
var velocity_param: String
var registance_x: float
var registance_y: float
var loop: bool
var condition: String
var born_x: float
var born_y: float
var born_behavior: String
var animations: Array[ShimejiAnimation] = []
var action_ref: Array[ActionReference] = []
var action: Array[ShimejiAction] = []

# Add other methods as needed...
