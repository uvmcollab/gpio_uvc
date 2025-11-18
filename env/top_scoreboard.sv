`ifndef TOP_SCOREBOARD_SV
`define TOP_SCOREBOARD_SV

class top_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(top_scoreboard)

  `uvm_analysis_imp_decl(_gpio_data)
  uvm_analysis_imp_gpio_data #(gpio_uvc_sequence_item,top_scoreboard) gpio_data_imp_export;

  // Statistics
  int unsigned m_num_passed = 0;
  int unsigned m_num_failed = 0;

  // Queue to store data
  gpio_uvc_sequence_item m_a_queue[$];

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);
  extern function void write_gpio_data(input gpio_uvc_sequence_item t);
  extern function int ref_model(input gpio_uvc_sequence_item trans_A, gpio_uvc_sequence_item trans_B);

endclass : top_scoreboard


function top_scoreboard::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void top_scoreboard::build_phase(uvm_phase phase);
  // Implementation Export
  gpio_data_imp_export = new("gpio_data_imp_export", this);
endfunction : build_phase


task top_scoreboard::run_phase(uvm_phase phase);
  // Variables
  string s;

  // Main scoreboard loop
  // forever begin
  //   wait(m_a_queue.size() >= 2);
  //   last_index = m_a_queue.size() - 1;
  // end

endtask : run_phase

function int top_scoreboard::ref_model(input gpio_uvc_sequence_item trans_A, gpio_uvc_sequence_item trans_B);
  return (trans_A.m_gpio_pin[7:0] + trans_B.m_gpio_pin[7:0]);
endfunction : ref_model


function void top_scoreboard::write_gpio_data(input gpio_uvc_sequence_item t);
  gpio_uvc_sequence_item received_trans;
  received_trans = gpio_uvc_sequence_item::type_id::create("received_trans");
  received_trans.do_copy(t);
  m_a_queue.push_back(received_trans);
endfunction : write_gpio_data


function void top_scoreboard::report_phase(uvm_phase phase);
// imprimimos las queue
// string s;
// foreach (m_a_queue[i]) begin
//   s = {s, $sformatf("\nTRANS[%3d]: \n ------ SCOREBOARD (ADDER UVC) ------  ", i), m_a_queue[i].convert2string(), "\n"};
// end
//       `uvm_info(get_type_name(), s, UVM_DEBUG)
//        s="";
`uvm_info(get_type_name(), $sformatf("PASSED = %3d, FAILED = %3d", m_num_passed, m_num_failed), UVM_MEDIUM)

endfunction : report_phase


`endif // TOP_SCOREBOARD_SV
