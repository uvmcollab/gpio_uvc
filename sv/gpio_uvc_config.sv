`ifndef GPIO_UVC_CONFIG_SV
`define GPIO_UVC_CONFIG_SV

class gpio_uvc_config extends uvm_object;

  `uvm_object_utils(gpio_uvc_config)

  virtual gpio_uvc_if     vif;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration parameters
  int unsigned            gpio_width;
  gpio_uvc_data_t         start_value = 'd0;

  extern function new(string name = "");
  extern function gpio_uvc_data_t get_mask();

endclass : gpio_uvc_config

function gpio_uvc_config::new(string name = "");
  super.new(name);
endfunction : new


function gpio_uvc_data_t gpio_uvc_config::get_mask();
  gpio_uvc_data_t  mask;
  mask = '0;
  for (int i = 0; i < gpio_width; i++) begin
    mask[i] = 1'b1;
  end
  return mask;
endfunction : get_mask


`endif  // GPIO_UVC_CONFIG_SV
