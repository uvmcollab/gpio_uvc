`ifndef TOP_COVERAGE_SV
`define TOP_COVERAGE_SV

class top_coverage extends uvm_component;

  `uvm_component_utils(top_coverage)

  `uvm_analysis_imp_decl(_gpio_data)
uvm_analysis_imp_gpio_data #(gpio_uvc_sequence_item,top_coverage) gpio_data_imp_export;

  // Transaction types
  gpio_uvc_sequence_item m_trans;

  // Crear el coverage

  covergroup m_cov;
  cp_gpio: coverpoint m_trans.m_gpio_pin {bins gpio_bin[]={[9:15]};}
  

  endgroup

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
    extern function void write_gpio_data(input gpio_uvc_sequence_item t);

  extern function void report_phase(uvm_phase phase);
  
  // Covergroups

endclass : top_coverage


function top_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  m_trans = gpio_uvc_sequence_item::type_id::create("m_trans");
  m_cov = new();
endfunction : new


function void top_coverage::build_phase(uvm_phase phase);
  gpio_data_imp_export = new("gpio_data_imp_export", this);

endfunction : build_phase

function void top_coverage::write_gpio_data(input gpio_uvc_sequence_item t);
// ya tengo un objeto m_trans en el coverage y le hago una copia
m_trans = t;
// Tomo una muestra con los valores actules
m_cov.sample();

endfunction : write_gpio_data

function void top_coverage::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("FINAL Coverage Score = %3.1f%%", m_cov.get_coverage()), UVM_DEBUG)

endfunction : report_phase

`endif // TOP_COVERAGE_SV