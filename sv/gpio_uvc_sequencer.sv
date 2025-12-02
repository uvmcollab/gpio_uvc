`ifndef GPIO_UVC_SEQUENCER_SV
`define GPIO_UVC_SEQUENCER_SV

class gpio_uvc_sequencer extends uvm_sequencer #(gpio_uvc_sequence_item);

  `uvm_component_utils(gpio_uvc_sequencer)

  gpio_uvc_config m_config;

  extern function new(string name, uvm_component parent);

endclass : gpio_uvc_sequencer


function gpio_uvc_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


`endif // GPIO_UVC_SEQUENCER_SV
